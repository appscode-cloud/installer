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

BYTEBUILDERS_CATALOG_TAG=${BYTEBUILDERS_CATALOG_TAG:-v0.0.6}
BYTEBUILDERS_KUBE_BIND_TAG=${BYTEBUILDERS_KUBE_BIND_TAG:-master}
BYTEBUILDERS_RESOURCE_MODEL_TAG=${BYTEBUILDERS_RESOURCE_MODEL_TAG:-v0.0.9}
FLUXCD_HELM_CONTROLLER=${FLUXCD_HELM_CONTROLLER:-v0.37.1}
FLUXCD_SOURCE_CONTROLLER=${FLUXCD_SOURCE_CONTROLLER:-v1.2.3}
KMODULES_RESOURCE_METADATA_TAG=${KMODULES_RESOURCE_METADATA_TAG:-master}
KUBEOPS_EXTERNAL_DNS_OPERATOR=${KUBEOPS_EXTERNAL_DNS_OPERATOR:-v0.0.7}
KUBESTASH_APIMACHINERY_TAG=${KUBESTASH_APIMACHINERY_TAG:-v0.5.0}
OPEN_CLUSTER_MANAGEMENT_IO_API_TAG=${OPEN_CLUSTER_MANAGEMENT_IO_API_TAG:-v0.13.0}
PROMETHEUS_OPERATOR_PROMETHEUS_OPERATOR=${PROMETHEUS_OPERATOR_PROMETHEUS_OPERATOR:-v0.71.2}
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
    --input=https://github.com/kubeops/external-dns-operator/raw/${KUBEOPS_EXTERNAL_DNS_OPERATOR}/crds/external-dns.appscode.com_externaldnses.yaml \
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
    --input=https://github.com/open-cluster-management-io/api/raw/${OPEN_CLUSTER_MANAGEMENT_IO_API_TAG}/work/v1alpha1/0000_00_work.open-cluster-management.io_manifestworkreplicasets.crd.yaml \
    --out=./charts/license-proxyserver-manager/crds

crd-importer \
    --input=https://github.com/fluxcd/source-controller/raw/${FLUXCD_SOURCE_CONTROLLER}/config/crd/bases/source.toolkit.fluxcd.io_helmrepositories.yaml \
    --input=https://github.com/kmodules/resource-metadata/raw/${KMODULES_RESOURCE_METADATA_TAG}/crds/ui.k8s.appscode.com_features.yaml \
    --input=https://github.com/kmodules/resource-metadata/raw/${KMODULES_RESOURCE_METADATA_TAG}/crds/ui.k8s.appscode.com_featuresets.yaml \
    --input=https://github.com/x-helm/apimachinery/raw/${HELM_X_APIMACHINERY_TAG}/crds/drivers.x-helm.dev_appreleases.yaml \
    --out=./charts/opscenter-features/crds

crd-importer \
    --input=https://github.com/kubestash/apimachinery/raw/${KUBESTASH_APIMACHINERY_TAG}/crds/storage.kubestash.com_backupstorages.yaml \
    --input=https://github.com/kubestash/apimachinery/raw/${KUBESTASH_APIMACHINERY_TAG}/crds/storage.kubestash.com_retentionpolicies.yaml \
    --input=https://github.com/x-helm/apimachinery/raw/${X_HELM_APIMACHINERY_TAG}/crds/charts.x-helm.dev_clusterchartpresets.yaml \
    --out=./charts/stash-presets/crds

crd-importer \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_druidbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_elasticsearchbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_ferretdbbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_kafkabindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_mariadbbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_memcachedbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_mssqlserverbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_mongodbbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_mysqlbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_perconaxtradbbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_pgbouncerbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_pgpoolbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_postgresbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_proxysqlbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_rabbitmqbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_redisbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_singlestorebindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_solrbindings.yaml \
    --input=https://github.com/bytebuilders/catalog/raw/${BYTEBUILDERS_CATALOG_TAG}/crds/catalog.appscode.com_zookeeperbindings.yaml \
    --out=./charts/catalog-manager/crds

crd-importer \
    --input=https://github.com/bytebuilders/kube-bind/raw/${BYTEBUILDERS_KUBE_BIND_TAG}/crds/kube-bind.appscode.com_apiservicebindings.yaml \
    --input=https://github.com/bytebuilders/kube-bind/raw/${BYTEBUILDERS_KUBE_BIND_TAG}/crds/kube-bind.appscode.com_apiserviceexportrequests.yaml \
    --input=https://github.com/bytebuilders/kube-bind/raw/${BYTEBUILDERS_KUBE_BIND_TAG}/crds/kube-bind.appscode.com_apiserviceexports.yaml \
    --input=https://github.com/bytebuilders/kube-bind/raw/${BYTEBUILDERS_KUBE_BIND_TAG}/crds/kube-bind.appscode.com_apiservicenamespaces.yaml \
    --input=https://github.com/bytebuilders/kube-bind/raw/${BYTEBUILDERS_KUBE_BIND_TAG}/crds/kube-bind.appscode.com_clusterbindings.yaml \
    --out=./charts/service-provider/crds

crd-importer \
    --input=https://github.com/envoyproxy/gateway/raw/v0.6.0/charts/gateway-helm/crds/generated/gateway.envoyproxy.io_envoyproxies.yaml \
    --input=https://github.com/kubeops/csi-driver-cacerts/raw/v0.0.2/crds/cacerts.csi.cert-manager.io_caproviderclasses.yaml \
    --input=https://github.com/kubeops/external-dns-operator/raw/${KUBEOPS_EXTERNAL_DNS_OPERATOR}/crds/external-dns.appscode.com_externaldns.yaml \
    --input=https://github.com/kubeops/external-dns-operator/raw/v0.0.6/crds/external-dns.appscode.com_externaldns.yaml \
    --input=https://github.com/kubernetes-sigs/gateway-api/raw/v1.0.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml \
    --input=https://github.com/kubernetes-sigs/gateway-api/raw/v1.0.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml \
    --input=https://github.com/kubernetes-sigs/gateway-api/raw/v1.0.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml \
    --input=https://github.com/kubernetes-sigs/gateway-api/raw/v1.0.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml \
    --input=https://github.com/kubevault/apimachinery/raw/v0.17.0/crds/kubevault.com_vaultservers.yaml \
    --input=https://github.com/kubevault/apimachinery/raw/v0.17.0/crds/policy.kubevault.com_vaultpolicies.yaml \
    --input=https://github.com/kubevault/apimachinery/raw/v0.17.0/crds/policy.kubevault.com_vaultpolicybindings.yaml \
    --out=./charts/service-presets/crds
