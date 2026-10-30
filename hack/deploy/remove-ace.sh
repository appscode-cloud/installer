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
deleteHR=$(dirname "$(readlink -f "$0")")/delete-helmrelease.sh
fullPrune=false
forceArgs=()
timeout=2m
# removed last, as they serve webhooks/APIServices the other releases depend on; aceshifter is the root of their dependsOn
coreHRs="cert-manager|cert-manager-csi-driver-cacerts|license-proxyserver|kube-ui-server|akp-crd-manager|aceshifter"
# dependencies missing from spec.dependsOn: kubestash clears the finalizer of stash-presets' BackupStorage
extraDeps='{"stash-presets":["kubestash"]}'
# third-party CRDs (cert-manager, prometheus-operator, gateway-api, OCM, ...) may be vendor-managed
appscodeGroups='(.*\.)?(appscode\.com|kubedb\.com|kubestash\.com|x-helm\.dev|openviz\.dev|klusters\.dev|voyagermesh\.com)|cacerts\.csi\.cert-manager\.io|fluxcd\.open-cluster-management\.io'

for arg in "$@"; do
    case $arg in
        --full-prune) fullPrune=true ;;
        --force) forceArgs=(--force) ;;
        *)
            echo "usage: $(basename "$0") [--full-prune] [--force]" >&2
            exit 1
            ;;
    esac
done

for bin in kubectl helm jq; do
    if ! command -v "$bin" >/dev/null; then
        echo "$bin is required" >&2
        exit 1
    fi
done

crdExists() {
    kubectl get crd "$1" >/dev/null 2>&1
}

deleteHRs() {
    local ns=$1
    shift
    [[ $# -gt 0 ]] || return 0
    "$deleteHR" "$ns" "$@" --timeout="$timeout" "${forceArgs[@]}"
}

deleteAndWait() {
    local resource=$1 ns=$2 name
    shift 2
    [[ $# -gt 0 ]] || return 0
    echo "deleting $resource in $ns: $*"
    kubectl delete "$resource" -n "$ns" "$@" --ignore-not-found --wait=false
    for name in "$@"; do
        kubectl wait --for=delete "$resource/$name" -n "$ns" --timeout="$timeout" >/dev/null 2>&1 && continue
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

requireController() {
    local kind=$1 selector=$2 found ns name replicas
    found=$(kubectl get "$kind" -A -l "$selector" -o json | jq -r '.items[0] // empty | "\(.metadata.namespace) \(.metadata.name) \(.spec.replicas)"')
    if [[ -z $found ]]; then
        echo "$kind with labels $selector not found" >&2
        exit 1
    fi
    read -r ns name replicas <<<"$found"
    if [[ $replicas == 0 ]]; then
        kubectl scale "$kind" "$name" -n "$ns" --replicas=1
    fi
    kubectl rollout status "$kind" "$name" -n "$ns" --timeout="$timeout"
}

# Deletes the HRs of a {name: [dependsOn...]} map, dependents before their dependencies
deleteInWaves() {
    local deps=$1 wave
    while [[ $deps != "{}" ]]; do
        wave=$(jq -r '([.[][]] | unique) as $needed | keys[] | select(. as $n | $needed | index($n) | not)' <<<"$deps")
        if [[ -z $wave ]]; then
            echo "dependency cycle, deleting the rest together"
            wave=$(jq -r 'keys[]' <<<"$deps")
        fi
        # the cluster-manager operator tears down the hub it created only while it is still running
        if grep -qx cluster-manager-hub <<<"$wave" && crdExists clustermanagers.operator.open-cluster-management.io; then
            # their namespaces' ManifestWork finalizers are cleared by the hub's work-controller
            crdExists managedclusters.cluster.open-cluster-management.io && timeout=30s deleteAll managedclusters.cluster.open-cluster-management.io
            deleteAll clustermanagers.operator.open-cluster-management.io
            kubectl delete ns open-cluster-management-hub --ignore-not-found --timeout="$timeout"
        fi
        # shellcheck disable=SC2086
        deleteHRs kubeops $wave
        deps=$(jq -c --arg wave "$wave" '($wave | split("\n")) as $w | with_entries(select(.key as $k | $w | index($k) | not))' <<<"$deps")
    done
}

owners='["ace-installer"]'
if crdExists featuresets.ui.k8s.appscode.com; then
    owners=$(kubectl get featuresets.ui.k8s.appscode.com -o json | jq -c '["ace-installer"] + [.items[].metadata.name]')
fi
# HRs created outside the ace-installer/FeatureSet charts (e.g. by b3) carry only the part-of label
aceHRJSON=$(kubectl get "$hr" -n kubeops -o json | jq --argjson owners "$owners" \
    '[.items[] | select((.metadata.annotations["meta.helm.sh/release-name"] // .metadata.labels["app.kubernetes.io/part-of"]) as $r | $owners | index($r))]')
gatewayHR=$(kubectl get "$hr" gateway -n ace -o json --ignore-not-found)
allHRJSON=$(jq --argjson gw "${gatewayHR:-null}" '. + ([$gw] - [null])' <<<"$aceHRJSON")

# fargocd mirrors HRs into Argo CD Applications; the rest are reconciled by Flux helm-controller
if [[ $(jq 'any(.[]; .metadata.finalizers // [] | index("fargocd.appscode.com/finalizer") | not)' <<<"$allHRJSON") == true ]]; then
    requireController deploy app.kubernetes.io/component=helm-controller,app.kubernetes.io/part-of=flux
    requireController deploy app.kubernetes.io/component=source-controller,app.kubernetes.io/part-of=flux
fi
if [[ $(jq 'any(.[]; .metadata.finalizers // [] | index("fargocd.appscode.com/finalizer"))' <<<"$allHRJSON") == true ]]; then
    requireController deploy app.kubernetes.io/name=fargocd
    requireController statefulset app.kubernetes.io/name=argocd-application-controller
fi

# Flux is kept: helm-controller skips the uninstall (and HelmChart cleanup) of a suspended HR
if [[ $(jq 'any(.[]; .metadata.name == "flux2")' <<<"$aceHRJSON") == true ]]; then
    fluxChart=$(kubectl get "$hr" flux2 -n kubeops -o jsonpath='{.status.helmChart}')
    kubectl patch "$hr" flux2 -n kubeops --type=merge -p '{"spec":{"suspend":true}}'
    deleteHRs kubeops flux2
    if [[ -n $fluxChart ]]; then
        kubectl delete helmcharts.source.toolkit.fluxcd.io "${fluxChart#*/}" -n "${fluxChart%%/*}" --ignore-not-found
    fi
    aceHRJSON=$(jq '[.[] | select(.metadata.name != "flux2")]' <<<"$aceHRJSON")
fi

aceHRs=$(jq -r '.[].metadata.name' <<<"$aceHRJSON")
aceNamespaces=$(jq -c '["ace", "kubeops"] + [.[].spec.targetNamespace // empty] | unique' <<<"$aceHRJSON")
echo "ACE HelmReleases: $(echo $aceHRs)"

if [[ $fullPrune != true ]]; then
    userObjects=$(for kind in $(kubectl api-resources --api-group=kubedb.com -o name) backupconfigurations.core.kubestash.com; do
        crdExists "$kind" || continue
        kubectl get "$kind" -A -o json | jq -r --argjson ns "$aceNamespaces" --arg kind "$kind" \
            '.items[] | select(.metadata.namespace as $n | $ns | index($n) | not) | "  \($kind) \(.metadata.namespace)/\(.metadata.name)"'
    done)
    if [[ -n $userObjects ]]; then
        printf 'WARNING: these objects outside ACE namespaces lose their operator and keep their finalizers:\n%s\n' "$userObjects" >&2
    fi
fi

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
# shellcheck disable=SC2046
deleteHRs kubeops $(grep -x ace <<<"$aceHRs" || true)
# shellcheck disable=SC2046
deleteHRs kubeops $(grep -x catalog-manager <<<"$aceHRs" || true)
deleteHRs ace gateway

# Releases go in reverse dependsOn order, so operators outlive the objects whose finalizers or CRDs they own
# (e.g. OCM addon managers' ClusterManagementAddOns need the hub CRDs).
deleteInWaves "$(jq -c --arg pinned "^(ace|catalog-manager|opscenter-features|$coreHRs)$" --argjson extra "$extraDeps" \
    '[.[] | .metadata.name as $n | select($n | test($pinned) | not)
        | {key: $n, value: ([.spec.dependsOn[]?.name] + ($extra[$n] // []))}] | from_entries' <<<"$aceHRJSON")"

# before kube-ui-server, which clears the Feature finalizers
# shellcheck disable=SC2046
deleteHRs kubeops $(grep -x opscenter-features <<<"$aceHRs" || true)
for kind in features.ui.k8s.appscode.com featuresets.ui.k8s.appscode.com; do
    crdExists "$kind" && deleteAll "$kind"
done

deleteInWaves "$(jq -c --arg core "^($coreHRs)$" \
    '[.[] | select(.metadata.name | test($core))] | (map(.metadata.name)) as $names
        | map({key: .metadata.name, value: [.spec.dependsOn[]?.name | select(. as $d | $names | index($d))]}) | from_entries' <<<"$aceHRJSON")"

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

# helm keeps hook-created webhook configs (e.g. kubestash) on uninstall; their dead services block later installs
for kind in mutatingwebhookconfigurations validatingwebhookconfigurations; do
    kubectl get "$kind" -o json | jq -r --argjson ns "$aceNamespaces" '.items[]
        | select(.metadata.labels["helm.toolkit.fluxcd.io/namespace"] == "kubeops" or any(.webhooks[]?; .clientConfig.service.namespace as $n | $n != null and ($ns | index($n))))
        | .metadata.name as $name | .webhooks[]?.clientConfig.service | select(. != null)
        | "\($name) \(.namespace) \(.name)"' | sort -u |
        while read -r name ns svc; do
            kubectl get svc "$svc" -n "$ns" >/dev/null 2>&1 || kubectl delete "$kind" "$name" --ignore-not-found
        done
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
