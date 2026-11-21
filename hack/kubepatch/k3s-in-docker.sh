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

# Runs a throwaway single-node k3s in Docker with Envoy Gateway and a GatewayClass, to test the kubepatch chart
# before it goes to a real k3s host. Needs docker, helm and curl on the host that runs it.
#
#   k3s-in-docker.sh up        # start k3s, install Envoy Gateway, write ./kp-k3s.kubeconfig
#   k3s-in-docker.sh down      # remove the container
#
# HTTPS of the cluster is published on host port $HTTPS_PORT (18443).

set -euo pipefail

NAME=${NAME:-kp-k3s}
K3S_IMAGE=${K3S_IMAGE:-rancher/k3s:v1.36.6-k3s1}
EG_VERSION=${EG_VERSION:-v1.10.0}
GATEWAY_CLASS=${GATEWAY_CLASS:-ace}
HTTPS_PORT=${HTTPS_PORT:-18443}
API_PORT=${API_PORT:-16443}
KUBECONFIG_OUT=${KUBECONFIG_OUT:-$PWD/kp-k3s.kubeconfig}

up() {
    # The datastore (SQLite) sits on tmpfs: on a busy host a slow disk makes k3s' kine abort a transaction and exit.
    docker run -d --name "$NAME" --privileged --tmpfs /run --tmpfs /var/run \
        --tmpfs /var/lib/rancher/k3s/server/db:size=1g \
        -p "$API_PORT:6443" -p "$HTTPS_PORT:443" \
        "$K3S_IMAGE" server --disable traefik --tls-san 127.0.0.1 >/dev/null
    until docker exec "$NAME" kubectl get nodes 2>/dev/null | grep -q ' Ready'; do sleep 3; done
    docker exec "$NAME" cat /etc/rancher/k3s/k3s.yaml | sed "s|https://127.0.0.1:6443|https://127.0.0.1:$API_PORT|" >"$KUBECONFIG_OUT"
    chmod 600 "$KUBECONFIG_OUT"
    export KUBECONFIG=$KUBECONFIG_OUT
    helm upgrade -i eg oci://docker.io/envoyproxy/gateway-helm --version "$EG_VERSION" \
        -n envoy-gateway-system --create-namespace --wait --timeout 10m
    docker exec -i "$NAME" kubectl apply -f - <<YAML
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: $GATEWAY_CLASS
spec:
  controllerName: gateway.envoyproxy.io/gatewayclass-controller
YAML
    echo "kubeconfig: $KUBECONFIG_OUT"
}

down() {
    docker rm -f "$NAME" >/dev/null
    rm -f "$KUBECONFIG_OUT"
}

case "${1:-}" in
up) up ;;
down) down ;;
*) echo "usage: $0 up|down" >&2; exit 1 ;;
esac
