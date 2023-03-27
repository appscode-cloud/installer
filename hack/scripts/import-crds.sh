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

BYTEBUILDERS_RESOURCE_MODEL_TAG=${BYTEBUILDERS_RESOURCE_MODEL_TAG:-master}
KUBEPACK_KUBEPACK_TAG=${KUBEPACK_KUBEPACK_TAG:-master}

crd-importer \
    --input=https://github.com/kmodules/custom-resources/raw/kubernetes-1.21.1/crds/appcatalog.appscode.com_appbindings.yaml \
    --out=./charts/opscenter-features/crds

crd-importer \
    --input=https://github.com/bytebuilders/resource-model/raw/${BYTEBUILDERS_RESOURCE_MODEL_TAG}/crds/cloud.bytebuilders.dev_credentials.yaml \
    --input=https://github.com/bytebuilders/resource-model/raw/${BYTEBUILDERS_RESOURCE_MODEL_TAG}/crds/cluster.bytebuilders.dev_clusterauthinfotemplates.yaml \
    --input=https://github.com/bytebuilders/resource-model/raw/${BYTEBUILDERS_RESOURCE_MODEL_TAG}/crds/cluster.bytebuilders.dev_clusterinfos.yaml \
    --input=https://github.com/bytebuilders/resource-model/raw/${BYTEBUILDERS_RESOURCE_MODEL_TAG}/crds/cluster.bytebuilders.dev_clusteruserauths.yaml \
    --input=https://github.com/kubepack/kubepack/raw/${KUBEPACK_KUBEPACK_TAG}/crds/kubepack.com_plans.yaml \
    --input=https://github.com/kubepack/kubepack/raw/${KUBEPACK_KUBEPACK_TAG}/crds/kubepack.com_products.yaml \
    --out=./charts/ace/crds

crd-importer \
    --input=https://github.com/kubeops/external-dns-operator/raw/v0.0.1/crds/external-dns.appscode.com_externaldns.yaml \
    --out=./charts/ace/crds

crd-importer \
    --input=https://github.com/open-viz/trickster-config/raw/master/config/crd/bases/trickstercache.org_trickstercaches.yaml \
    --input=https://github.com/open-viz/trickster-config/raw/master/config/crd/bases/trickstercache.org_tricksters.yaml \
    --out=./charts/ace/crds

crd-importer \
    --input=https://github.com/prometheus-operator/prometheus-operator/raw/v0.59.1/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml \
    --out=./charts/license-proxyserver/crds

KMODULES_RESOURCE_METADATA_TAG=${KMODULES_RESOURCE_METADATA_TAG:-v0.12.1}
KUBEPACK_PRESET_TAG=${KUBEPACK_PRESET_TAG:-v0.0.2}

crd-importer \
    --input=https://github.com/kmodules/resource-metadata/raw/${KMODULES_RESOURCE_METADATA_TAG}/crds/ui.k8s.appscode.com_resourceeditors.yaml \
    --input=https://github.com/kubepack/preset/raw/${KUBEPACK_PRESET_TAG}/crds/charts.x-helm.dev_chartpresets.yaml \
    --input=https://github.com/kubepack/preset/raw/${KUBEPACK_PRESET_TAG}/crds/charts.x-helm.dev_clusterchartpresets.yaml \
    --input=https://github.com/kubepack/preset/raw/${KUBEPACK_PRESET_TAG}/crds/charts.x-helm.dev_vendorchartpresets.yaml \
    --out=./charts/monitoring-ui-presets/crds
