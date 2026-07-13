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

set -x

if [ -z "${IMAGE_REGISTRY}" ]; then
    echo "IMAGE_REGISTRY is not set"
    exit 1
fi

TARBALL=${1:-}
tar -zxvf $TARBALL

CMD="./crane"

$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-ace-installer-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/ace-installer:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-ace-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/ace:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-aceshifter-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/aceshifter:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-appscode-otel-stack-v2026.6.2.tar $IMAGE_REGISTRY/appscode-charts/appscode-otel-stack:v2026.6.2
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-aws-credential-manager-v2026.1.20.tar $IMAGE_REGISTRY/appscode-charts/aws-credential-manager:v2026.1.20
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-aws-ebs-csi-driver-2.23.0.tar $IMAGE_REGISTRY/appscode-charts/aws-ebs-csi-driver:2.23.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-aws-load-balancer-controller-1.11.0.tar $IMAGE_REGISTRY/appscode-charts/aws-load-balancer-controller:1.11.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-azure-credential-manager-v2026.4.16.tar $IMAGE_REGISTRY/appscode-charts/azure-credential-manager:v2026.4.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-capa-vpc-peering-operator-v2023.12.11.tar $IMAGE_REGISTRY/appscode-charts/capa-vpc-peering-operator:v2023.12.11
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-capi-catalog-v2024.10.24.tar $IMAGE_REGISTRY/appscode-charts/capi-catalog:v2024.10.24
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-capi-ops-manager-v2024.8.14.tar $IMAGE_REGISTRY/appscode-charts/capi-ops-manager:v2024.8.14
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-catalog-manager-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/catalog-manager:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cert-manager-csi-driver-cacerts-v2026.1.15.tar $IMAGE_REGISTRY/appscode-charts/cert-manager-csi-driver-cacerts:v2026.1.15
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cert-manager-v1.19.3.tar $IMAGE_REGISTRY/appscode-charts/cert-manager:v1.19.3
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cluster-auth-manager-v2026.2.16.tar $IMAGE_REGISTRY/appscode-charts/cluster-auth-manager:v2026.2.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cluster-autoscaler-9.29.0.tar $IMAGE_REGISTRY/appscode-charts/cluster-autoscaler:9.29.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cluster-gateway-manager-v2026.6.26.tar $IMAGE_REGISTRY/appscode-charts/cluster-gateway-manager:v2026.6.26
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cluster-manager-hub-v2026.2.16.tar $IMAGE_REGISTRY/appscode-charts/cluster-manager-hub:v2026.2.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cluster-manager-spoke-v2026.2.16.tar $IMAGE_REGISTRY/appscode-charts/cluster-manager-spoke:v2026.2.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cluster-presets-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/cluster-presets:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cluster-profile-manager-v2026.6.26.tar $IMAGE_REGISTRY/appscode-charts/cluster-profile-manager:v2026.6.26
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-cluster-proxy-manager-v2026.6.26.tar $IMAGE_REGISTRY/appscode-charts/cluster-proxy-manager:v2026.6.26
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-config-syncer-v0.15.4.tar $IMAGE_REGISTRY/appscode-charts/config-syncer:v0.15.4
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-crossplane-1.14.0.tar $IMAGE_REGISTRY/appscode-charts/crossplane:1.14.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-csi-driver-nfs-v4.7.0.tar $IMAGE_REGISTRY/appscode-charts/csi-driver-nfs:v4.7.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-csi-secrets-store-provider-azure-1.5.2.tar $IMAGE_REGISTRY/appscode-charts/csi-secrets-store-provider-azure:1.5.2
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-external-dns-operator-v2026.6.22.tar $IMAGE_REGISTRY/appscode-charts/external-dns-operator:v2026.6.22
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-external-secrets-0.9.12.tar $IMAGE_REGISTRY/appscode-charts/external-secrets:0.9.12
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-falco-ui-server-v2026.1.15.tar $IMAGE_REGISTRY/appscode-charts/falco-ui-server:v2026.1.15
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-falco-4.0.0.tar $IMAGE_REGISTRY/appscode-charts/falco:4.0.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-flux2-2.17.0.tar $IMAGE_REGISTRY/appscode-charts/flux2:2.17.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-fluxcd-manager-v2026.2.16.tar $IMAGE_REGISTRY/appscode-charts/fluxcd-manager:v2026.2.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-gatekeeper-grafana-dashboards-v2023.10.1.tar $IMAGE_REGISTRY/appscode-charts/gatekeeper-grafana-dashboards:v2023.10.1
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-gatekeeper-library-v2023.10.1.tar $IMAGE_REGISTRY/appscode-charts/gatekeeper-library:v2023.10.1
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-gatekeeper-3.13.3.tar $IMAGE_REGISTRY/appscode-charts/gatekeeper:3.13.3
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-gateway-api-v2025.3.14.tar $IMAGE_REGISTRY/appscode-charts/gateway-api:v2025.3.14
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-gcp-credential-manager-v2026.3.11.tar $IMAGE_REGISTRY/appscode-charts/gcp-credential-manager:v2026.3.11
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-grafana-operator-v2026.6.12.tar $IMAGE_REGISTRY/appscode-charts/grafana-operator:v2026.6.12
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-hub-cluster-robot-v2026.2.16.tar $IMAGE_REGISTRY/appscode-charts/hub-cluster-robot:v2026.2.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-inbox-agent-v2026.6.2.tar $IMAGE_REGISTRY/appscode-charts/inbox-agent:v2026.6.2
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-inbox-server-v2025.12.25.tar $IMAGE_REGISTRY/appscode-charts/inbox-server:v2025.12.25
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-inbox-ui-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/inbox-ui:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-keda-add-ons-http-0.12.0.tar $IMAGE_REGISTRY/appscode-charts/keda-add-ons-http:0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-keda-2.19.0.tar $IMAGE_REGISTRY/appscode-charts/keda:2.19.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kube-grafana-dashboards-v2023.10.1.tar $IMAGE_REGISTRY/appscode-charts/kube-grafana-dashboards:v2023.10.1
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kube-prometheus-stack-69.2.2.tar $IMAGE_REGISTRY/appscode-charts/kube-prometheus-stack:69.2.2
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kube-ui-server-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/kube-ui-server:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kubedb-opscenter-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/kubedb-opscenter:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kubedb-provider-aws-v2024.1.31.tar $IMAGE_REGISTRY/appscode-charts/kubedb-provider-aws:v2024.1.31
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kubedb-provider-azure-v2024.1.31.tar $IMAGE_REGISTRY/appscode-charts/kubedb-provider-azure:v2024.1.31
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kubedb-provider-gcp-v2024.1.31.tar $IMAGE_REGISTRY/appscode-charts/kubedb-provider-gcp:v2024.1.31
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kubedb-ui-presets-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/kubedb-ui-presets:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kubedb-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/kubedb:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kubestash-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/kubestash:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kubevault-opscenter-v2026.2.27.tar $IMAGE_REGISTRY/appscode-charts/kubevault-opscenter:v2026.2.27
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kubevault-v2026.2.27.tar $IMAGE_REGISTRY/appscode-charts/kubevault:v2026.2.27
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kyverno-policies-3.2.5.tar $IMAGE_REGISTRY/appscode-charts/kyverno-policies:3.2.5
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-kyverno-3.2.6.tar $IMAGE_REGISTRY/appscode-charts/kyverno:3.2.6
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-license-proxyserver-manager-v2026.2.16.tar $IMAGE_REGISTRY/appscode-charts/license-proxyserver-manager:v2026.2.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-license-proxyserver-v2026.2.16.tar $IMAGE_REGISTRY/appscode-charts/license-proxyserver:v2026.2.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-longhorn-1.7.2.tar $IMAGE_REGISTRY/appscode-charts/longhorn:1.7.2
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-managed-serviceaccount-manager-v2026.2.16.tar $IMAGE_REGISTRY/appscode-charts/managed-serviceaccount-manager:v2026.2.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-metrics-server-3.11.0.tar $IMAGE_REGISTRY/appscode-charts/metrics-server:3.11.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-monitoring-operator-v2026.6.12.tar $IMAGE_REGISTRY/appscode-charts/monitoring-operator:v2026.6.12
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-opencost-grafana-dashboards-v2023.10.1.tar $IMAGE_REGISTRY/appscode-charts/opencost-grafana-dashboards:v2023.10.1
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-opencost-1.18.1.tar $IMAGE_REGISTRY/appscode-charts/opencost:1.18.1
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-operator-shard-manager-v2026.6.22.tar $IMAGE_REGISTRY/appscode-charts/operator-shard-manager:v2026.6.22
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-opscenter-features-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/opscenter-features:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-panopticon-v2026.6.22.tar $IMAGE_REGISTRY/appscode-charts/panopticon:v2026.6.22
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-prepare-cluster-v2023.12.21.tar $IMAGE_REGISTRY/appscode-charts/prepare-cluster:v2023.12.21
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-prom-label-proxy-v2026.6.2.tar $IMAGE_REGISTRY/appscode-charts/prom-label-proxy:v2026.6.2
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-prometheus-adapter-4.9.0.tar $IMAGE_REGISTRY/appscode-charts/prometheus-adapter:4.9.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-reloader-2.2.9.tar $IMAGE_REGISTRY/appscode-charts/reloader:2.2.9
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-scanner-v2026.1.15.tar $IMAGE_REGISTRY/appscode-charts/scanner:v2026.1.15
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-sealed-secrets-2.14.2.tar $IMAGE_REGISTRY/appscode-charts/sealed-secrets:2.14.2
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-secrets-store-csi-driver-provider-aws-0.3.6.tar $IMAGE_REGISTRY/appscode-charts/secrets-store-csi-driver-provider-aws:0.3.6
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-secrets-store-csi-driver-provider-gcp-0.1.0.tar $IMAGE_REGISTRY/appscode-charts/secrets-store-csi-driver-provider-gcp:0.1.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-secrets-store-csi-driver-provider-virtual-secrets-v2026.2.27.tar $IMAGE_REGISTRY/appscode-charts/secrets-store-csi-driver-provider-virtual-secrets:v2026.2.27
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-secrets-store-csi-driver-1.4.1.tar $IMAGE_REGISTRY/appscode-charts/secrets-store-csi-driver:1.4.1
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-service-backend-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/service-backend:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-service-gateway-presets-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/service-gateway-presets:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-service-gateway-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/service-gateway:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-service-provider-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/service-provider:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-sidekick-v2026.6.22.tar $IMAGE_REGISTRY/appscode-charts/sidekick:v2026.6.22
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-snapshot-controller-3.0.6.tar $IMAGE_REGISTRY/appscode-charts/snapshot-controller:3.0.6
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-stash-opscenter-v2025.7.31.tar $IMAGE_REGISTRY/appscode-charts/stash-opscenter:v2025.7.31
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-stash-presets-v2026.6.19.tar $IMAGE_REGISTRY/appscode-charts/stash-presets:v2026.6.19
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-stash-v2025.7.31.tar $IMAGE_REGISTRY/appscode-charts/stash:v2025.7.31
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-storage-metrics-server-v0.1.0.tar $IMAGE_REGISTRY/appscode-charts/storage-metrics-server:v0.1.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-supervisor-v2026.2.16.tar $IMAGE_REGISTRY/appscode-charts/supervisor:v2026.2.16
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-tenant-operator-v2026.6.2.tar $IMAGE_REGISTRY/appscode-charts/tenant-operator:v2026.6.2
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-thanos-operator-v2026.6.2.tar $IMAGE_REGISTRY/appscode-charts/thanos-operator:v2026.6.2
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-topolvm-15.0.0.tar $IMAGE_REGISTRY/appscode-charts/topolvm:15.0.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-alert-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-alert:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-backup-option-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-backup-option:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-backupconfiguration-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-backupconfiguration:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-certificates-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-certificates:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-data-sources-items-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-data-sources-items:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-database-runtime-settings-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-database-runtime-settings:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-env-from-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-env-from:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-env-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-env:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-health-checker-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-health-checker:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-initialization-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-initialization:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-jwtoidc-config-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-jwtoidc-config:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-kubedb-ui-presets-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-kubedb-ui-presets:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-match-expressions-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-match-expressions:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-match-fields-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-match-fields:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-monitoring-option-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-monitoring-option:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-pod-template-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-pod-template:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-repository-create-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-repository-create:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-resources-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-resources:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-runtime-settings-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-runtime-settings:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-se-linux-options-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-se-linux-options:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-selector-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-selector:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-service-templates-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-service-templates:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uibytebuildersdev-component-stash-presets-v0.12.0.tar $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-stash-presets:v0.12.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-capi-capa-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-capi-capa-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-capi-capg-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-capi-capg-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-capi-capz-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-capi-capz-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-capi-core-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-capi-core-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-crossplane-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-crossplane-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-ocm-hub-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-ocm-hub-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-ocm-spoke-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-ocm-spoke-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-backup-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-backup-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-core-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-core-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-cost-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-cost-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-datastore-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-datastore-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-networking-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-networking-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-observability-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-observability-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-policy-management-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-policy-management-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-secret-management-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-secret-management-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-security-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-security-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-storage-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-storage-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-opscenter-tools-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-tools-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-uik8sappscodecom-featureset-saas-core-editor-v0.35.0.tar $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-saas-core-editor:v0.35.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-vault-secrets-operator-0.4.3.tar $IMAGE_REGISTRY/appscode-charts/vault-secrets-operator:0.4.3
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-vault-0.27.0.tar $IMAGE_REGISTRY/appscode-charts/vault:0.27.0
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-virtual-secrets-server-v2026.2.27.tar $IMAGE_REGISTRY/appscode-charts/virtual-secrets-server:v2026.2.27
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-voyager-gateway-v2026.1.15.tar $IMAGE_REGISTRY/appscode-charts/voyager-gateway:v2026.1.15
$CMD push --allow-nondistributable-artifacts --insecure images/appscode-charts-voyager-v2026.3.23.tar $IMAGE_REGISTRY/appscode-charts/voyager:v2026.3.23
