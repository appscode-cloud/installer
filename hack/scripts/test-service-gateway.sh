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

# cert-manager must be pre-installed

tenant=ace
echo "Installing cluster service-gateway"
kubectl create ns $tenant || true
helm upgrade -i --wait $tenant charts/service-gateway -n $tenant \
    --set gateway.config.envoyGateway.gateway.controllerName="gateway.voyagermesh.com/${tenant}"

for tenant in c1 c2; do
    echo
    echo "Installing service-gateway for tenant $tenant"
    kubectl create ns ${tenant}-gw || true
    helm upgrade -i --wait ${tenant} charts/service-gateway -n ${tenant}-gw \
        --set gateway.config.envoyGateway.gateway.controllerName="gateway.voyagermesh.com/${tenant}"
done
