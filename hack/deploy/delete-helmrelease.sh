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
app=applications.argoproj.io
fargocdFinalizer=fargocd.appscode.com/finalizer
hookFinalizer=argocd.argoproj.io/hook-finalizer
argoNS=${ARGO_NS:-argocd}
timeout=2m
force=false
args=()

for arg in "$@"; do
    case $arg in
        --timeout=*) timeout=${arg#*=} ;;
        --force) force=true ;;
        *) args+=("$arg") ;;
    esac
done
if [[ ${#args[@]} -lt 1 ]]; then
    echo "usage: $(basename "$0") <namespace> [helmrelease...] [--timeout=2m] [--force]" >&2
    exit 1
fi
ns=${args[0]}

stripTerminating() {
    local only=${1:-} kind group objNS name ref remaining
    local -a nsArgs
    while IFS='|' read -r kind group objNS name; do
        [[ -n $name ]] || continue
        ref=$(tr "[:upper:]" "[:lower:]" <<<"$kind")${group:+.$group}
        nsArgs=()
        [[ -n $objNS ]] && nsArgs=(-n "$objNS")
        remaining=$(kubectl get "$ref" "$name" ${nsArgs[@]+"${nsArgs[@]}"} --ignore-not-found -o json |
            jq -c --arg f "$only" 'select(.metadata.deletionTimestamp) | (.metadata.finalizers // [])
                | if $f == "" then null elif index($f) then . - [$f] else empty end') || continue
        [[ -n $remaining ]] || continue
        echo "  removing ${only:-all} finalizers of terminating $ref ${objNS:+$objNS/}$name"
        kubectl patch "$ref" "$name" ${nsArgs[@]+"${nsArgs[@]}"} --type=merge -p "{\"metadata\":{\"finalizers\":$remaining}}"
    done
}

# Argo CD never clears argocd.argoproj.io/hook-finalizer of Helm-hook objects when their Application is deleted
unblockApplication() {
    kubectl get "$app" "$1" -n "$argoNS" -o json |
        jq -r '.status.resources[]? | "\(.kind)|\(.group // "")|\(.namespace // "")|\(.name)"' |
        stripTerminating "${2:-}"
}

# Operators are uninstalled in parallel, so finalizers on a release's objects may have no controller left to clear them
unblockFluxRelease() {
    local release
    release=$(kubectl get "$hr" "$1" -n "$ns" -o json | jq -r '.status.history[0] // empty | "\(.namespace) \(.name)"')
    if [[ -z $release ]]; then
        echo "  $ns/$1 has no release history"
        return 0
    fi
    # shellcheck disable=SC2086
    helm get manifest -n $release | kubectl get -f - -o json --ignore-not-found |
        jq -r '(.items // [.])[] | select(.metadata.deletionTimestamp)
            | "\(.kind)|\(if (.apiVersion | contains("/")) then (.apiVersion | split("/")[0]) else "" end)|\(.metadata.namespace // "")|\(.metadata.name)"' |
        stripTerminating
}

# a running sync (e.g. waiting on a never-healthy Job) keeps re-applying resources and blocks the cascade delete
terminateSync() {
    local phase
    phase=$(kubectl get "$app" "$1" -n "$argoNS" -o jsonpath='{.status.operationState.phase}')
    [[ $phase == Running ]] || return 0
    echo "  terminating running sync of Application $argoNS/$1"
    kubectl patch "$app" "$1" -n "$argoNS" --type=merge -p '{"status":{"operationState":{"phase":"Terminating"}}}'
}

waitGone() {
    kubectl wait --for=delete "$hr/$1" -n "$ns" --timeout="$2" >/dev/null 2>&1
}

names=()
appNames=()
appsJSON=""
for name in "${args[@]:1}"; do
    hrJSON=$(kubectl get "$hr" "$name" -n "$ns" -o json --ignore-not-found)
    if [[ -z $hrJSON ]]; then
        echo "$hr $ns/$name not found, skipping"
        continue
    fi
    appName=""
    if [[ $(jq --arg f "$fargocdFinalizer" '.metadata.finalizers // [] | index($f) != null' <<<"$hrJSON") == true ]]; then
        [[ -n $appsJSON ]] || appsJSON=$(kubectl get "$app" -n "$argoNS" -o json)
        appName=$(jq -r --arg key "$ns/$name" '.items[] | select(.metadata.annotations["fargocd.appscode.com/helmrelease"] == $key) | .metadata.name' <<<"$appsJSON")
    fi
    echo "deleting $hr $ns/$name${appName:+ (Application $argoNS/$appName)}"
    [[ -z $appName ]] || terminateSync "$appName"
    names+=("$name")
    appNames+=("$appName")
done
[[ ${#names[@]} -gt 0 ]] || exit 0

# deleted together so independent releases tear down in parallel
kubectl delete "$hr" -n "$ns" "${names[@]}" --wait=false

for i in "${!names[@]}"; do
    name=${names[$i]}
    appName=${appNames[$i]}
    # nothing ever clears the hook finalizer, so waiting the full timeout for it is pointless; other finalizers may still be doing cleanup
    if [[ -n $appName ]]; then
        waitGone "$name" 20s && continue
        kubectl get "$app" "$appName" -n "$argoNS" >/dev/null 2>&1 && unblockApplication "$appName" "$hookFinalizer"
    fi
    waitGone "$name" "$timeout" && continue

    echo "$ns/$name is stuck"
    if [[ -n $appName ]] && kubectl get "$app" "$appName" -n "$argoNS" >/dev/null 2>&1; then
        terminateSync "$appName"
        unblockApplication "$appName"
        waitGone "$name" 1m && continue
        if [[ $force != true ]]; then
            echo "still stuck; inspect: kubectl get $app $appName -n $argoNS -o yaml; rerun with --force to remove the Application finalizer" >&2
            exit 1
        fi
        echo "  --force: removing finalizers of Application $argoNS/$appName"
        kubectl patch "$app" "$appName" -n "$argoNS" --type=merge -p '{"metadata":{"finalizers":null}}'
    elif [[ -z $appName ]]; then
        unblockFluxRelease "$name"
    fi
    waitGone "$name" 1m && continue

    if [[ $force != true ]]; then
        echo "$hr $ns/$name still stuck; rerun with --force to remove its finalizers" >&2
        exit 1
    fi
    echo "  --force: removing finalizers of $hr $ns/$name"
    kubectl patch "$hr" "$name" -n "$ns" --type=merge -p '{"metadata":{"finalizers":null}}'
done
