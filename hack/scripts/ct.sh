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

set -eou pipefail

for dir in charts/*/; do
    dir=${dir%*/}
    dir=${dir##*/}
    num_files=$(find charts/${dir}/templates -type f | wc -l)
    echo $dir
    if [ $num_files -le 1 ] ||
        [[ "$dir" = "acaas" ]] ||
        [[ "$dir" = "accounts-ui" ]] ||
        [[ "$dir" = "ace" ]] ||
        [[ "$dir" = "billing" ]] ||
        [[ "$dir" = "catalog-manager" ]] ||
        [[ "$dir" = "dns-proxy" ]] ||
        [[ "$dir" = "gh-ci-webhook" ]] ||
        [[ "$dir" = "grafana" ]] ||
        [[ "$dir" = "license-proxyserver-manager" ]] ||
        [[ "$dir" = "marketplace-api" ]] ||
        [[ "$dir" = "offline-license-server" ]] ||
        [[ "$dir" = "opscenter-features" ]] ||
        [[ "$dir" = "outbox-syncer" ]] ||
        [[ "$dir" = "platform-api" ]] ||
        [[ "$dir" = "platform-links" ]] ||
        [[ "$dir" = "platform-ui" ]] ||
        [[ "$dir" = "service-backend" ]] ||
        [[ "$dir" = "service-gateway-presets" ]] ||
        [[ "$dir" = "service-provider" ]] ||
        [[ "$dir" = "service-vault" ]] ||
        [[ "$dir" = "smtprelay" ]] ||
        [[ "$dir" = "website" ]]; then
        make ct CT_COMMAND=lint TEST_CHARTS=charts/$dir
    elif [[ "$dir" = "cert-manager-webhook-ace" ]]; then
        make ct TEST_CHARTS=charts/$dir || true
    else
        ns=app-$(date +%s | head -c 6)
        kubectl create ns $ns
        kubectl label ns $ns pod-security.kubernetes.io/enforce=restricted
        make ct TEST_CHARTS=charts/$dir KUBE_NAMESPACE=$ns
        kubectl patch $(kubectl get gatewayclass -o name) -p '{"metadata":{"finalizers":null}}' --type=merge || true
        kubectl delete gatewayclass -A --all || true
        kubectl delete ns $ns || true
    fi
done
