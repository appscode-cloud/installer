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

BYTEBUILDERS_RESOURCE_MODEL_TAG=${BYTEBUILDERS_RESOURCE_MODEL_TAG:-v0.0.9}
FLUXCD_HELM_CONTROLLER=${FLUXCD_HELM_CONTROLLER:-v0.37.1}
FLUXCD_SOURCE_CONTROLLER=${FLUXCD_SOURCE_CONTROLLER:-v1.2.3}
KMODULES_RESOURCE_METADATA_TAG=${KMODULES_RESOURCE_METADATA_TAG:-v0.12.1}
KUBEOPS_EXTERNAL_DNS_OPERATOR=${KUBEOPS_EXTERNAL_DNS_OPERATOR:-v0.0.6}
KUBESTASH_APIMACHINERY_TAG=${KUBESTASH_APIMACHINERY_TAG:-v0.5.0}
OPEN_CLUSTER_MANAGEMENT_IO_API_TAG=${OPEN_CLUSTER_MANAGEMENT_IO_API_TAG:-v0.12.0}
PROMETHEUS_OPERATOR_PROMETHEUS_OPERATOR=${PROMETHEUS_OPERATOR_PROMETHEUS_OPERATOR:-v0.59.1}
X_HELM_APIMACHINERY_TAG=${X_HELM_APIMACHINERY_TAG:-v0.0.16}

crd-importer \
    --input=https://github.com/fluxcd/helm-controller/raw/${FLUXCD_HELM_CONTROLLER}/config/crd/bases/helm.toolkit.fluxcd.io_helmreleases.yaml \
    --input=https://github.com/fluxcd/source-controller/raw/${FLUXCD_SOURCE_CONTROLLER}/config/crd/bases/source.toolkit.fluxcd.io_helmrepositories.yaml \
    --input=https://github.com/x-helm/apimachinery/raw/${X_HELM_APIMACHINERY_TAG}/crds/charts.x-helm.dev_clusterchartpresets.yaml \
    --out=./charts/ace-installer/crds

crd-importer \
    --input=https://github.com/bytebuilders/resource-model/raw/${BYTEBUILDERS_RESOURCE_MODEL_TAG}/crds/cloud.appscode.com_credentials.yaml \
    --input=https://github.com/bytebuilders/resource-model/raw/${BYTEBUILDERS_RESOURCE_MODEL_TAG}/crds/cluster.appscode.com_clusterauthinfotemplates.yaml \
    --input=https://github.com/bytebuilders/resource-model/raw/${BYTEBUILDERS_RESOURCE_MODEL_TAG}/crds/cluster.appscode.com_clusterinfos.yaml \
    --input=https://github.com/bytebuilders/resource-model/raw/${BYTEBUILDERS_RESOURCE_MODEL_TAG}/crds/cluster.appscode.com_clusteruserauths.yaml \
    --input=https://github.com/x-helm/apimachinery/raw/${X_HELM_APIMACHINERY_TAG}/crds/products.x-helm.dev_plans.yaml \
    --input=https://github.com/x-helm/apimachinery/raw/${X_HELM_APIMACHINERY_TAG}/crds/products.x-helm.dev_products.yaml \
    --out=./charts/ace/crds

crd-importer \
    --input=https://github.com/kubeops/external-dns-operator/raw/${KUBEOPS_EXTERNAL_DNS_OPERATOR}/crds/external-dns.appscode.com_externaldns.yaml \
    --out=./charts/ace/crds

crd-importer \
    --input=https://github.com/open-viz/trickster-config/raw/master/config/crd/bases/trickstercache.org_trickstercaches.yaml \
    --input=https://github.com/open-viz/trickster-config/raw/master/config/crd/bases/trickstercache.org_tricksters.yaml \
    --out=./charts/ace/crds

crd-importer \
    --input=https://github.com/open-cluster-management-io/api/raw/${OPEN_CLUSTER_MANAGEMENT_IO_API_TAG}/cluster/v1beta1/0000_02_clusters.open-cluster-management.io_placements.crd.yaml \
    --input=https://github.com/open-cluster-management-io/api/raw/${OPEN_CLUSTER_MANAGEMENT_IO_API_TAG}/cluster/v1beta2/0000_01_clusters.open-cluster-management.io_managedclustersetbindings.crd.yaml \
    --input=https://github.com/open-cluster-management-io/api/raw/${OPEN_CLUSTER_MANAGEMENT_IO_API_TAG}/work/v1alpha1/0000_00_work.open-cluster-management.io_manifestworkreplicasets.crd.yaml \
    --out=./charts/ace-ocm-addons/crds

crd-importer \
    --input=https://github.com/x-helm/apimachinery/raw/${X_HELM_APIMACHINERY_TAG}/crds/charts.x-helm.dev_clusterchartpresets.yaml \
    --out=./charts/capi-cluster-presets/crds

crd-importer \
    --input=https://github.com/prometheus-operator/prometheus-operator/raw/${PROMETHEUS_OPERATOR_PROMETHEUS_OPERATOR}/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml \
    --out=./charts/license-proxyserver/crds

crd-importer \
    --input=https://github.com/open-cluster-management-io/api/raw/${OPEN_CLUSTER_MANAGEMENT_IO_API_TAG}/addon/v1alpha1/0000_00_addon.open-cluster-management.io_clustermanagementaddons.crd.yaml \
    --input=https://github.com/open-cluster-management-io/api/raw/${OPEN_CLUSTER_MANAGEMENT_IO_API_TAG}/cluster/v1beta1/0000_02_clusters.open-cluster-management.io_placements.crd.yaml \
    --input=https://github.com/open-cluster-management-io/api/raw/${OPEN_CLUSTER_MANAGEMENT_IO_API_TAG}/cluster/v1beta2/0000_01_clusters.open-cluster-management.io_managedclustersetbindings.crd.yaml \
    --out=./charts/license-proxyserver-addon-manager/crds

crd-importer \
    --input=https://github.com/fluxcd/source-controller/raw/${FLUXCD_SOURCE_CONTROLLER}/config/crd/bases/source.toolkit.fluxcd.io_helmrepositories.yaml \
    --input=https://github.com/kmodules/resource-metadata/raw/master/crds/ui.k8s.appscode.com_features.yaml \
    --input=https://github.com/kmodules/resource-metadata/raw/master/crds/ui.k8s.appscode.com_featuresets.yaml \
    --input=https://github.com/x-helm/apimachinery/raw/${HELM_X_APIMACHINERY_TAG}/crds/drivers.x-helm.dev_appreleases.yaml \
    --out=./charts/opscenter-features/crds

crd-importer \
    --input=https://github.com/kubestash/apimachinery/raw/${KUBESTASH_APIMACHINERY_TAG}/crds/storage.kubestash.com_backupstorages.yaml \
    --input=https://github.com/kubestash/apimachinery/raw/${KUBESTASH_APIMACHINERY_TAG}/crds/storage.kubestash.com_retentionpolicies.yaml \
    --input=https://github.com/x-helm/apimachinery/raw/${X_HELM_APIMACHINERY_TAG}/crds/charts.x-helm.dev_clusterchartpresets.yaml \
    --out=./charts/stash-presets/crds
