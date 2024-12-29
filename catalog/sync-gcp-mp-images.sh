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
if [ -z "${TAG}" ]; then
    echo "TAG is not set"
    exit 1
fi

crane cp --allow-nondistributable-artifacts alpine:3.20 $IMAGE_REGISTRY/alpine:$TAG
crane cp --allow-nondistributable-artifacts bitnami/kubectl:1.28.5 $IMAGE_REGISTRY/kubectl:$TAG
crane cp --allow-nondistributable-artifacts bitnami/sealed-secrets-controller:0.25.0 $IMAGE_REGISTRY/sealed-secrets-controller:$TAG
crane cp --allow-nondistributable-artifacts cassandra:4.1.3 $IMAGE_REGISTRY/cassandra:$TAG
crane cp --allow-nondistributable-artifacts coredns/coredns:1.11.3 $IMAGE_REGISTRY/coredns:$TAG
crane cp --allow-nondistributable-artifacts falcosecurity/falco-no-driver:0.37.0 $IMAGE_REGISTRY/falco-no-driver:$TAG
crane cp --allow-nondistributable-artifacts falcosecurity/falcoctl:0.7.1 $IMAGE_REGISTRY/falcoctl:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-charts/ace-installer:v2025.1.17 $IMAGE_REGISTRY/ace-installer:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-charts/ace:v2025.1.17 $IMAGE_REGISTRY/ace:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-charts/service-gateway:v2025.1.17 $IMAGE_REGISTRY/service-gateway:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-charts/spoke-cluster-addons:v2024.7.10 $IMAGE_REGISTRY/spoke-cluster-addons:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-images/ingress-nginx-controller:v1.11.1 $IMAGE_REGISTRY/ingress-nginx-controller:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-images/nats:2.10.24-alpine $IMAGE_REGISTRY/nats:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-images/postgres:16.4-alpine $IMAGE_REGISTRY/postgres:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-images/redis:7.2.4-bookworm $IMAGE_REGISTRY/redis:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/aceshifter:v0.0.1 $IMAGE_REGISTRY/aceshifter:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/b3:v2025.1.17 $IMAGE_REGISTRY/b3:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/capa-vpc-peering-operator:v0.0.4 $IMAGE_REGISTRY/capa-vpc-peering-operator:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/capi-ops-manager:v0.0.2 $IMAGE_REGISTRY/capi-ops-manager:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/catalog-manager:v0.1.1 $IMAGE_REGISTRY/catalog-manager:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/cluster-presets:v0.0.7 $IMAGE_REGISTRY/cluster-presets:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/cluster-ui:0.9.13 $IMAGE_REGISTRY/cluster-ui:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/config-syncer:v0.15.2-ent $IMAGE_REGISTRY/config-syncer:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/csi-driver-cacerts:v0.1.0 $IMAGE_REGISTRY/csi-driver-cacerts:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/external-dns-operator:v0.0.8 $IMAGE_REGISTRY/external-dns-operator:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/falco-ui-server:v0.0.4 $IMAGE_REGISTRY/falco-ui-server:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/fileserver:v0.0.1 $IMAGE_REGISTRY/fileserver:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/flux-cli:v2.3.0 $IMAGE_REGISTRY/flux-cli:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/grafana-tools:v0.2.0 $IMAGE_REGISTRY/grafana-tools:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/grafana:v2024.10.31 $IMAGE_REGISTRY/grafana:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/inbox-agent:v0.0.1 $IMAGE_REGISTRY/inbox-agent:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/inbox-server:latest $IMAGE_REGISTRY/inbox-server:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/inbox-ui:0.0.3 $IMAGE_REGISTRY/inbox-ui:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/k8s-wait-for:v2.0 $IMAGE_REGISTRY/k8s-wait-for:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/kube-rbac-proxy:v0.15.0 $IMAGE_REGISTRY/kube-rbac-proxy:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/kube-ui-server:v0.0.50 $IMAGE_REGISTRY/kube-ui-server:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/kubectl-nonroot:1.31 $IMAGE_REGISTRY/kubectl-nonroot:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/kubedb-ui:0.7.12 $IMAGE_REGISTRY/kubedb-ui:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/license-proxyserver:v0.0.19 $IMAGE_REGISTRY/license-proxyserver:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/maxmind-geoip:city-mmdb-latest $IMAGE_REGISTRY/maxmind-geoip:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/openfga:v1.6.0 $IMAGE_REGISTRY/openfga:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/operator-shard-manager:v0.0.1 $IMAGE_REGISTRY/operator-shard-manager:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/panopticon:v0.0.16 $IMAGE_REGISTRY/panopticon:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/petset:v0.0.7 $IMAGE_REGISTRY/petset:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/platform-ui:0.8.11 $IMAGE_REGISTRY/platform-ui:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/prom-authproxy:v0.0.1 $IMAGE_REGISTRY/prom-authproxy:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/reloader:v1.0.79 $IMAGE_REGISTRY/reloader:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/s3proxy:sha-a82ca68 $IMAGE_REGISTRY/s3proxy:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/scanner:v0.0.19 $IMAGE_REGISTRY/scanner:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/service-provider:v0.0.1 $IMAGE_REGISTRY/service-provider:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/sidekick:v0.0.9 $IMAGE_REGISTRY/sidekick:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/supervisor:v0.0.7 $IMAGE_REGISTRY/supervisor:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/trickster:v2.0.0-beta3 $IMAGE_REGISTRY/trickster:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode/vcluster-plugin-ace:v0.0.3 $IMAGE_REGISTRY/vcluster-plugin-ace:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/external-secrets/external-secrets:v0.9.12 $IMAGE_REGISTRY/external-secrets:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/fluxcd/helm-controller:v1.0.1 $IMAGE_REGISTRY/flux-helm-controller:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/fluxcd/kustomize-controller:v1.3.0 $IMAGE_REGISTRY/flux-kustomize-controller:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/fluxcd/notification-controller:v1.3.0 $IMAGE_REGISTRY/flux-notification-controller:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/fluxcd/source-controller:v1.3.0 $IMAGE_REGISTRY/flux-source-controller:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kedacore/http-add-on-interceptor:0.8.0 $IMAGE_REGISTRY/keda-http-add-on-interceptor:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kedacore/http-add-on-operator:0.8.0 $IMAGE_REGISTRY/keda-http-add-on-operator:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kedacore/http-add-on-scaler:0.8.0 $IMAGE_REGISTRY/keda-http-add-on-scaler:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kedacore/keda-admission-webhooks:2.15.1 $IMAGE_REGISTRY/keda-admission-webhooks:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kedacore/keda-metrics-apiserver:2.15.1 $IMAGE_REGISTRY/keda-metrics-apiserver:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kedacore/keda:2.15.1 $IMAGE_REGISTRY/keda:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/addon-manager:v0.15.2 $IMAGE_REGISTRY/addon-manager:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/cluster-auth:v0.3.0 $IMAGE_REGISTRY/cluster-auth:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/cluster-gateway-manager:v1.10.0 $IMAGE_REGISTRY/cluster-gateway-manager:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/cluster-gateway:v1.10.0 $IMAGE_REGISTRY/cluster-gateway:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/cluster-profile:v0.4.0 $IMAGE_REGISTRY/cluster-profile:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/cluster-proxy:v0.6.0 $IMAGE_REGISTRY/cluster-proxy:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/clusteradm:v0.10.0 $IMAGE_REGISTRY/clusteradm:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/fluxcd-addon:v0.0.5 $IMAGE_REGISTRY/fluxcd-addon:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/managed-serviceaccount:v0.7.0 $IMAGE_REGISTRY/managed-serviceaccount:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/placement:v0.15.2 $IMAGE_REGISTRY/placement:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/registration-operator:v0.15.2 $IMAGE_REGISTRY/registration-operator:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/registration:v0.15.2 $IMAGE_REGISTRY/registration:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kluster-manager/work:v0.15.2 $IMAGE_REGISTRY/work:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/kubedb-autoscaler:v0.35.0 $IMAGE_REGISTRY/kubedb-autoscaler:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/kubedb-crd-manager:v0.5.0 $IMAGE_REGISTRY/kubedb-crd-manager:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/kubedb-ops-manager:v0.37.1 $IMAGE_REGISTRY/kubedb-ops-manager:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/kubedb-provisioner:v0.50.1 $IMAGE_REGISTRY/kubedb-provisioner:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/kubedb-schema-manager:v0.26.0 $IMAGE_REGISTRY/kubedb-schema-manager:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/kubedb-ui-server:v0.26.0 $IMAGE_REGISTRY/kubedb-ui-server:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/kubedb-webhook-server:v0.26.1 $IMAGE_REGISTRY/kubedb-webhook-server:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/pg-coordinator:v0.34.0 $IMAGE_REGISTRY/pg-coordinator:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/postgres-archiver:v0.11.0_16.1-alpine $IMAGE_REGISTRY/postgres-archiver:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/postgres-init:0.17.0 $IMAGE_REGISTRY/postgres-init:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/postgres-restic-plugin:v0.13.0_16.1 $IMAGE_REGISTRY/postgres-restic-plugin:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/redis-coordinator:v0.29.0 $IMAGE_REGISTRY/redis-coordinator:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/redis-init:0.9.0 $IMAGE_REGISTRY/redis-init:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/redis-restic-plugin:v0.13.0 $IMAGE_REGISTRY/redis-restic-plugin:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/redis_exporter:1.66.0 $IMAGE_REGISTRY/redis_exporter:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubedb/vcluster-plugin-kubedb:v0.0.1 $IMAGE_REGISTRY/vcluster-plugin-kubedb:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubestash/kubedump:v0.13.0 $IMAGE_REGISTRY/kubedump:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubestash/kubestash:v0.14.0 $IMAGE_REGISTRY/kubestash:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kubevault/vault-operator:v0.19.0 $IMAGE_REGISTRY/vault-operator:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kyverno/background-controller:v1.12.5 $IMAGE_REGISTRY/background-controller:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kyverno/cleanup-controller:v1.12.5 $IMAGE_REGISTRY/cleanup-controller:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kyverno/kyverno:v1.12.5 $IMAGE_REGISTRY/kyverno:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kyverno/kyvernopre:v1.12.5 $IMAGE_REGISTRY/kyvernopre:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/kyverno/reports-controller:v1.12.5 $IMAGE_REGISTRY/reports-controller:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/loft-sh/vcluster-oss:0.22.0 $IMAGE_REGISTRY/vcluster-oss:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/voyagermesh/echoserver:v20221109 $IMAGE_REGISTRY/echoserver:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/voyagermesh/envoy:v1.31.2-ac $IMAGE_REGISTRY/envoy:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/voyagermesh/gateway-converter:v0.0.1 $IMAGE_REGISTRY/gateway-converter:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/voyagermesh/gateway:v1.1.2 $IMAGE_REGISTRY/gateway:$TAG
crane cp --allow-nondistributable-artifacts hashicorp/vault-csi-provider:1.4.1 $IMAGE_REGISTRY/vault-csi-provider:$TAG
crane cp --allow-nondistributable-artifacts hashicorp/vault-secrets-operator:0.4.3 $IMAGE_REGISTRY/vault-secrets-operator:$TAG
crane cp --allow-nondistributable-artifacts hashicorp/vault:1.15.2 $IMAGE_REGISTRY/vault:$TAG
crane cp --allow-nondistributable-artifacts natsio/nats-boot-config:0.16.1 $IMAGE_REGISTRY/nats-boot-config:$TAG
crane cp --allow-nondistributable-artifacts natsio/nats-server-config-reloader:0.16.1 $IMAGE_REGISTRY/nats-server-config-reloader:$TAG
crane cp --allow-nondistributable-artifacts natsio/prometheus-nats-exporter:0.16.0 $IMAGE_REGISTRY/prometheus-nats-exporter:$TAG
crane cp --allow-nondistributable-artifacts openpolicyagent/gatekeeper:v3.13.3 $IMAGE_REGISTRY/gatekeeper:$TAG
crane cp --allow-nondistributable-artifacts opensearchproject/opensearch:2.1.0 $IMAGE_REGISTRY/opensearch:$TAG
crane cp --allow-nondistributable-artifacts prometheuscommunity/postgres-exporter:v0.15.0 $IMAGE_REGISTRY/postgres-exporter:$TAG
crane cp --allow-nondistributable-artifacts quay.io/jetstack/cert-manager-acmesolver:v1.15.4 $IMAGE_REGISTRY/cert-manager-acmesolver:$TAG
crane cp --allow-nondistributable-artifacts quay.io/jetstack/cert-manager-cainjector:v1.15.4 $IMAGE_REGISTRY/cert-manager-cainjector:$TAG
crane cp --allow-nondistributable-artifacts quay.io/jetstack/cert-manager-controller:v1.15.4 $IMAGE_REGISTRY/cert-manager-controller:$TAG
crane cp --allow-nondistributable-artifacts quay.io/jetstack/cert-manager-startupapicheck:v1.15.4 $IMAGE_REGISTRY/cert-manager-startupapicheck:$TAG
crane cp --allow-nondistributable-artifacts quay.io/jetstack/cert-manager-webhook:v1.15.4 $IMAGE_REGISTRY/cert-manager-webhook:$TAG
crane cp --allow-nondistributable-artifacts quay.io/prometheus-operator/prometheus-config-reloader:v0.75.2 $IMAGE_REGISTRY/prometheus-config-reloader:$TAG
crane cp --allow-nondistributable-artifacts quay.io/prometheus/alertmanager:v0.27.0 $IMAGE_REGISTRY/alertmanager:$TAG
crane cp --allow-nondistributable-artifacts quay.io/prometheus/node-exporter:v1.8.2 $IMAGE_REGISTRY/prometheus-node-exporter:$TAG
crane cp --allow-nondistributable-artifacts quay.io/prometheus/prometheus:v2.54.0 $IMAGE_REGISTRY/prometheus:$TAG
crane cp --allow-nondistributable-artifacts quay.io/thanos/thanos:v0.32.5 $IMAGE_REGISTRY/thanos:$TAG
crane cp --allow-nondistributable-artifacts rabbitmq:3.12.1-management $IMAGE_REGISTRY/rabbitmq:$TAG
crane cp --allow-nondistributable-artifacts rancher/kine:v0.11.4 $IMAGE_REGISTRY/kine:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/autoscaling/cluster-autoscaler:v1.27.1 $IMAGE_REGISTRY/cluster-autoscaler:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/csi-secrets-store/driver:v1.4.1 $IMAGE_REGISTRY/driver:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20221220-controller-v1.5.1-58-g787ea74b6 $IMAGE_REGISTRY/ingress-nginx-kube-webhook-certgen:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/kube-apiserver:v1.31.0 $IMAGE_REGISTRY/kube-apiserver:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/kube-controller-manager:v1.31.0 $IMAGE_REGISTRY/kube-controller-manager:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.13.0 $IMAGE_REGISTRY/kube-state-metrics:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/metrics-server/metrics-server:v0.7.2 $IMAGE_REGISTRY/metrics-server:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/prometheus-adapter/prometheus-adapter:v0.11.2 $IMAGE_REGISTRY/prometheus-adapter:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.11.1 $IMAGE_REGISTRY/csi-node-driver-registrar:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/sig-storage/csi-provisioner:v4.0.0 $IMAGE_REGISTRY/csi-provisioner:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/sig-storage/csi-snapshotter:v6.3.3 $IMAGE_REGISTRY/csi-snapshotter:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/sig-storage/livenessprobe:v2.13.1 $IMAGE_REGISTRY/csi-driver-livenessprobe:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/sig-storage/nfsplugin:v4.7.0 $IMAGE_REGISTRY/nfsplugin:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/sig-storage/snapshot-controller:v8.0.1 $IMAGE_REGISTRY/snapshot-controller:$TAG
crane cp --allow-nondistributable-artifacts registry.k8s.io/sig-storage/snapshot-validation-webhook:v8.0.1 $IMAGE_REGISTRY/snapshot-validation-webhook:$TAG
