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

# Removes what the trustconsole demo put on a k3s host, and nothing else. Run it on the host:
#
#   hack/trustconsole/teardown.sh          # print what it would remove
#   hack/trustconsole/teardown.sh --yes    # remove it
#
# What the demo creates: the helm release `trustconsole` in namespace trustconsole, its PVCs and the Secrets that are not
# Helm's (trustconsole-credentials, trustconsole-tls, trustconsole-nats-creds, trustconsole-nats-server), the namespace, and
# the images imported by build-images.sh. The Gateway controller and the Gateway API CRDs are not its own and stay.

set -uo pipefail

K="sudo k3s kubectl"
H="sudo env KUBECONFIG=/etc/rancher/k3s/k3s.yaml helm"
NS=${NS:-trustconsole}
IMAGE_PATTERN='ghcr.io/appscode/trust-console(-ui)?:tc-'

run() {
    if [ "${YES:-}" = 1 ]; then
        echo "+ $*"
        "$@" || true
    else
        echo "would run: $*"
    fi
}

[ "${1:-}" = "--yes" ] && YES=1

run $H uninstall trustconsole -n "$NS"
run $K -n "$NS" delete pvc --all
run $K -n "$NS" delete secret trustconsole-credentials trustconsole-tls trustconsole-nats-creds trustconsole-nats-server --ignore-not-found
# Only if you made the read-only ServiceAccount to link a cluster to AKP (docs/trustconsole.md).
run $K delete clusterrolebinding trustconsole-akp-link --ignore-not-found
run $K delete namespace "$NS" --ignore-not-found
for i in $(sudo k3s ctr -n k8s.io images ls -q 2>/dev/null | grep -E "$IMAGE_PATTERN"); do
    run sudo k3s ctr -n k8s.io images rm "$i"
done
