#!/usr/bin/env bash

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

# Removes everything the kubepatch demo put on a k3s host, and nothing else. Run it on the host:
#
#   hack/kubepatch/teardown.sh          # print what it would remove
#   hack/kubepatch/teardown.sh --yes    # remove it
#
# What the demo creates:
#   namespace kubepatch       the helm release `kubepatch`, its PVCs, and the Secrets that are not Helm's
#                             (kubepatch-credentials, kubepatch-tls, kubepatch-nats-creds, kubepatch-nats-server)
#   namespace voyager-gateway-system   the helm release `voyager-gateway`
#   cluster scoped            GatewayClass ace (and the EnvoyProxy ace it points at, in voyager-gateway-system); the CRDs of group gateway.envoyproxy.io (5); ClusterRoles
#                             voyager-gateway-*, voyager:gateway:*, vg-crd-manager; their ClusterRoleBindings;
#                             MutatingWebhookConfiguration envoy-gateway-topology-injector.voyager-gateway-system
#   containerd                the images imported by load-images.sh
# The Gateway API CRDs are k3s' and stay.

set -uo pipefail

K="sudo k3s kubectl"
H="sudo env KUBECONFIG=/etc/rancher/k3s/k3s.yaml helm"
NS=${NS:-kubepatch}
GWNS=${GWNS:-voyager-gateway-system}
IMAGE_PATTERN='ghcr.io/appscode/(b3|patch-console|patch-console-ui):kubepatch'

run() {
    if [ "${YES:-}" = 1 ]; then
        echo "+ $*"
        "$@" || true
    else
        echo "would run: $*"
    fi
}

[ "${1:-}" = "--yes" ] && YES=1

run $H uninstall kubepatch -n "$NS"
run $K -n "$NS" delete pvc --all
run $K -n "$NS" delete secret kubepatch-credentials kubepatch-tls kubepatch-nats-creds kubepatch-nats-server --ignore-not-found
run $K delete namespace "$NS" --ignore-not-found
run $K delete gatewayclass ace --ignore-not-found
run $K -n "$GWNS" delete envoyproxy ace --ignore-not-found
run $H uninstall voyager-gateway -n "$GWNS"
run $K delete mutatingwebhookconfiguration "envoy-gateway-topology-injector.$GWNS" --ignore-not-found
for r in $($K get clusterrole,clusterrolebinding -o name 2>/dev/null | grep -E 'voyager-gateway|voyager:gateway|vg-crd-manager'); do
    run $K delete "$r" --ignore-not-found
done
for c in backends backendtrafficpolicies clienttrafficpolicies envoypatchpolicies envoyproxies; do
    run $K delete crd "$c.gateway.envoyproxy.io" --ignore-not-found
done
run $K delete namespace "$GWNS" --ignore-not-found
for i in $(sudo k3s ctr -n k8s.io images ls -q 2>/dev/null | grep -E "$IMAGE_PATTERN"); do
    run sudo k3s ctr -n k8s.io images rm "$i"
done
