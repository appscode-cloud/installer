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

# Installs what the AKP v2 demo needs on a single-node k3s, in order. Run it on the host, from the checkout (or a copy of
# `charts` and `hack/akp-v2-demo`), after load-images.sh has imported the images:
#
#   hack/akp-v2-demo/install.sh gateway    Voyager Gateway (GatewayClass ace; k3s keeps its Gateway API CRDs)
#   hack/akp-v2-demo/install.sh prereqs    Postgres, Casdoor, the NATS identities, the Gateway certificate
#   hack/akp-v2-demo/install.sh ace        the ace chart: ProductLine AKP, global.akp.mode v2_only
#   hack/akp-v2-demo/install.sh all
#
# Settings: HOST (public name, default akp.10.2.0.73.nip.io: it appears in charts/ace/profiles/akp-v2-demo.yaml and
# hack/akp-v2-demo/prereqs-values.yaml too, change all three), NS (default akp).

set -euo pipefail

NS=${NS:-akp}
HOST=${HOST:-akp.10.2.0.73.nip.io}
GWNS=voyager-gateway-system
here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/../.." && pwd)

gateway() {
    # controllerName: the class `ace` of the ace chart's Gateway; crd-manager must leave k3s' Gateway API CRDs alone.
    helm upgrade --install voyager-gateway oci://ghcr.io/appscode-charts/voyager-gateway --version v2026.10.10 \
        -n "$GWNS" --create-namespace \
        --set gateway.config.envoyGateway.gateway.controllerName=gateway.voyagermesh.com/ace \
        --set crd-manager.featureGates.GatewayOfficial=false --set crd-manager.updateExistingCRDs=false --wait --timeout 5m
    # Without parametersRef the Voyager infrastructure runner panics.
    kubectl apply -f "$here/gateway.yaml"
}

prereqs() {
    helm upgrade --install akp-prereqs "$root/charts/akp-prereqs" -n "$NS" --create-namespace \
        -f "$here/prereqs-values.yaml" --set global.platform.host="$HOST" --wait --timeout 8m
}

ace() {
    "$here/ace-values.sh"
    helm upgrade --install ace "$root/charts/ace" -n "$NS" -f "$root/charts/ace/profiles/akp-v2-demo.yaml" \
        -f "${OUT:-$HOME/akp/ace-secrets.values.json}" --set global.platform.host="$HOST" \
        --set settings.iam.casdoor.publicUrl="https://casdoor.$HOST" \
        --set platform-ui.loginURL="https://$HOST/iam/casdoor/login" --set cluster-ui.loginURL="https://$HOST/iam/casdoor/login" \
        --wait --timeout 15m
}

case "${1:-}" in
    gateway) gateway ;;
    prereqs) prereqs ;;
    ace) ace ;;
    all)
        gateway
        prereqs
        ace
        ;;
    *)
        sed -n 17,28p "$0" >&2
        exit 1
        ;;
esac
