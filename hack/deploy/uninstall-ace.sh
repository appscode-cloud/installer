#!/bin/bash

# Copyright AppsCode Inc. and Contributors
#
# Licensed under the AppsCode Community License 1.0.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://github.com/appscode/licenses/raw/1.0.0/AppsCode-Community-1.0.0.md
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

hr=helmreleases.helm.toolkit.fluxcd.io
fullPrune=false
timeout=2m
# removed after other releases, as they serve webhooks/APIServices those releases depend on
coreHRs="cert-manager|cert-manager-csi-driver-cacerts|license-proxyserver|kube-ui-server|akp-crd-manager"
# third-party CRDs (cert-manager, prometheus-operator, gateway-api, OCM, ...) may be vendor-managed
appscodeGroups='(.*\.)?(appscode\.com|kubedb\.com|kubestash\.com|x-helm\.dev|openviz\.dev|klusters\.dev|voyagermesh\.com)|cacerts\.csi\.cert-manager\.io|fluxcd\.open-cluster-management\.io'

for arg in "$@"; do
    case $arg in
        --full-prune) fullPrune=true ;;
        *)
            echo "usage: $(basename "$0") [--full-prune]" >&2
            exit 1
            ;;
    esac
done

crdExists() {
    kubectl get crd "$1" >/dev/null 2>&1
}

# Operators are uninstalled in parallel, so finalizers on a release's objects may have no controller
# left to clear them, which blocks helm uninstall forever.
stripReleaseFinalizers() {
    local release kind ns name
    release=$(kubectl get "$hr" "$2" -n "$1" -o jsonpath='{.status.history[0].namespace} {.status.history[0].name}')
    echo "removing finalizers of terminating objects in release $release"
    # shellcheck disable=SC2086
    helm get manifest -n $release | kubectl get -f - -o json --ignore-not-found |
        jq -r '(.items // [.])[] | select(.metadata.deletionTimestamp)
            | "\(.kind | ascii_downcase)\(if (.apiVersion | contains("/")) then "." + (.apiVersion | split("/")[0]) else "" end) \(.metadata.namespace // "default") \(.metadata.name)"' |
        while read -r kind ns name; do
            kubectl patch "$kind" "$name" -n "$ns" --type=merge -p '{"metadata":{"finalizers":null}}'
        done
}

deleteAndWait() {
    local resource=$1 ns=$2 name
    shift 2
    [[ $# -gt 0 ]] || return 0
    echo "deleting $resource in $ns: $*"
    kubectl delete "$resource" -n "$ns" "$@" --ignore-not-found --wait=false
    for name in "$@"; do
        kubectl wait --for=delete "$resource/$name" -n "$ns" --timeout="$timeout" >/dev/null && continue
        if [[ $resource == "$hr" ]]; then
            stripReleaseFinalizers "$ns" "$name" || echo "failed to unblock release of $hr $ns/$name"
            kubectl wait --for=delete "$resource/$name" -n "$ns" --timeout=1m >/dev/null && continue
        fi
        echo "$resource $ns/$name is stuck, removing finalizers"
        kubectl patch "$resource" "$name" -n "$ns" --type=merge -p '{"metadata":{"finalizers":null}}' || echo "failed to patch $resource $ns/$name"
    done
}

deleteAll() {
    local resource=$1 ns
    for ns in $(kubectl get "$resource" -A -o json | jq -r '[.items[].metadata.namespace // "default"] | unique[]'); do
        # shellcheck disable=SC2046
        deleteAndWait "$resource" "$ns" $(kubectl get "$resource" -n "$ns" -o jsonpath='{.items[*].metadata.name}')
    done
}

patchAll() {
    local resource=$1 patch=$2 filter=$3 ns name
    kubectl get "$resource" -A -o json | jq -r ".items[] | select($filter) | \"\(.metadata.namespace // \"default\") \(.metadata.name)\"" |
        while read -r ns name; do
            kubectl patch "$resource" "$name" -n "$ns" --type=merge -p "$patch"
        done
}

for deploy in helm-controller source-controller; do
    if [[ $(kubectl get deploy "$deploy" -n flux-system -o jsonpath='{.spec.replicas}') == 0 ]]; then
        kubectl scale deploy "$deploy" -n flux-system --replicas=1
    fi
    kubectl rollout status deploy "$deploy" -n flux-system --timeout="$timeout"
done

owners='["ace-installer"]'
if crdExists featuresets.ui.k8s.appscode.com; then
    owners=$(kubectl get featuresets.ui.k8s.appscode.com -o json | jq -c '["ace-installer"] + [.items[].metadata.name]')
fi
aceHRJSON=$(kubectl get "$hr" -n kubeops -o json | jq --argjson owners "$owners" \
    '[.items[] | select(.metadata.annotations["meta.helm.sh/release-name"] as $r | $owners | index($r))]')
aceHRs=$(jq -r '.[].metadata.name' <<<"$aceHRJSON")
aceNamespaces=$(jq -c '["ace", "kubeops"] + [.[].spec.targetNamespace // empty] | unique' <<<"$aceHRJSON")
echo "ACE HelmReleases: $(echo $aceHRs)"

if [[ $fullPrune == true ]]; then
    # their finalizers wait on spoke agents / backup backends; don't block on them
    crdExists managedclusters.cluster.open-cluster-management.io && timeout=30s deleteAll managedclusters.cluster.open-cluster-management.io
    for kind in $(kubectl api-resources --api-group=kubedb.com -o name); do
        patchAll "$kind" '{"spec":{"deletionPolicy":"WipeOut"}}' true
        deleteAll "$kind"
    done
    for kind in backupconfigurations.core.kubestash.com backupsessions.core.kubestash.com restoresessions.core.kubestash.com; do
        crdExists "$kind" && deleteAll "$kind"
    done
    crdExists repositories.storage.kubestash.com && timeout=30s deleteAll repositories.storage.kubestash.com
    crdExists backupstorages.storage.kubestash.com && deleteAll backupstorages.storage.kubestash.com
fi

# dashboard finalizers call ACE's Grafana/Perses, which go away with the ace release
for kind in grafanadashboards.openviz.dev persesdashboards.openviz.dev; do
    crdExists "$kind" && deleteAll "$kind"
done

# ace runs the platform-api that reconciles FeatureSets; catalog-manager creates ace/gateway
deleteAndWait "$hr" kubeops $(grep -x ace <<<"$aceHRs" || true)
deleteAndWait "$hr" kubeops $(grep -x catalog-manager <<<"$aceHRs" || true)
deleteAndWait "$hr" ace gateway
# shellcheck disable=SC2046
deleteAndWait "$hr" kubeops $(grep -vxE "ace|catalog-manager|opscenter-features|$coreHRs" <<<"$aceHRs" || true)
# before kube-ui-server, which clears the Feature finalizers
deleteAndWait "$hr" kubeops $(grep -x opscenter-features <<<"$aceHRs" || true)
for kind in features.ui.k8s.appscode.com featuresets.ui.k8s.appscode.com; do
    crdExists "$kind" && deleteAll "$kind"
done
# shellcheck disable=SC2046
deleteAndWait "$hr" kubeops $(grep -xE "$coreHRs" <<<"$aceHRs" || true)

if helm status -n kubeops ace-installer >/dev/null 2>&1; then
    helm uninstall -n kubeops ace-installer --wait --timeout "$timeout"
fi

echo "deleting ACE data"
kubectl delete jobs,pvc -n ace --all --ignore-not-found --timeout="$timeout"

for name in $(kubectl get apiservices -o json | jq -r --argjson ns "$aceNamespaces" '.items[]
    | select(.spec.service.namespace as $n | $n != null and ($ns | index($n)))
    | select(any(.status.conditions[]?; .type == "Available" and .status == "False")) | .metadata.name'); do
    kubectl delete apiservice "$name"
done

if [[ $fullPrune == true ]]; then
    crds=$(kubectl get crd -o json | jq -r --arg re "^($appscodeGroups)$" '.items[] | select(.spec.group | test($re)) | .metadata.name')
    for crd in $crds; do
        patchAll "$crd" '{"metadata":{"finalizers":null}}' .metadata.finalizers
    done
    # shellcheck disable=SC2086
    deleteAndWait crd default $crds

    for ns in $(jq -r '.[]' <<<"$aceNamespaces"); do
        if [[ -n $(kubectl get secret -n "$ns" -l owner=helm -o name) || -n $(kubectl get "$hr" -n "$ns" -o name) ]]; then
            echo "keeping namespace $ns: it still has Helm or Flux releases"
            continue
        fi
        kubectl delete ns "$ns" --ignore-not-found --timeout="$timeout"
    done
fi
