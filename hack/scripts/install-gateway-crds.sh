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

# service-gateway always renders EnvoyProxy, whose CRD comes from the crd-manager pre-install hook.
# helm maps every manifest kind before running hooks, so a fresh cluster needs the CRDs beforehand.
tmpDir=$(mktemp -d)
trap 'rm -rf "$tmpDir"' EXIT

tar -xzf charts/service-gateway/charts/voyager-gateway-*.tgz -C "$tmpDir"
helm install gateway-crds "$tmpDir/voyager-gateway/charts/crd-manager" -n default --wait
helm uninstall gateway-crds -n default
