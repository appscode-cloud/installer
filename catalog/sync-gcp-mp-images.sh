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

crane cp alpine:3.20 $IMAGE_REGISTRY/alpine:$TAG
crane cp bitnami/kubectl:1.28.5 $IMAGE_REGISTRY/kubectl:$TAG
crane cp bitnami/sealed-secrets-controller:0.25.0 $IMAGE_REGISTRY/sealed-secrets-controller:$TAG
crane cp cassandra:4.1.3 $IMAGE_REGISTRY/cassandra:$TAG
crane cp coredns/coredns:1.11.3 $IMAGE_REGISTRY/coredns:$TAG
crane cp falcosecurity/falco-no-driver:0.37.0 $IMAGE_REGISTRY/falco-no-driver:$TAG
crane cp falcosecurity/falcoctl:0.7.1 $IMAGE_REGISTRY/falcoctl:$TAG
crane cp ghcr.io/appscode-images/nats:2.10.18-alpine $IMAGE_REGISTRY/nats:$TAG
crane cp ghcr.io/appscode-images/postgres:15.5-alpine $IMAGE_REGISTRY/postgres:$TAG
crane cp ghcr.io/appscode-images/redis:7.2.4-bookworm $IMAGE_REGISTRY/redis:$TAG
crane cp ghcr.io/appscode/b3:v2024.9.30 $IMAGE_REGISTRY/b3:$TAG
crane cp ghcr.io/appscode/capa-vpc-peering-operator:v0.0.4 $IMAGE_REGISTRY/capa-vpc-peering-operator:$TAG
crane cp ghcr.io/appscode/capi-ops-manager:v0.0.1 $IMAGE_REGISTRY/capi-ops-manager:$TAG
crane cp ghcr.io/appscode/catalog-manager:v0.0.1 $IMAGE_REGISTRY/catalog-manager:$TAG
crane cp ghcr.io/appscode/cluster-presets:v0.0.3 $IMAGE_REGISTRY/cluster-presets:$TAG
crane cp ghcr.io/appscode/cluster-ui:0.9.7 $IMAGE_REGISTRY/cluster-ui:$TAG
crane cp ghcr.io/appscode/config-syncer:v0.15.2-ent $IMAGE_REGISTRY/config-syncer:$TAG
crane cp ghcr.io/appscode/csi-driver-cacerts:v0.0.4 $IMAGE_REGISTRY/csi-driver-cacerts:$TAG
crane cp ghcr.io/appscode/docker-machine-operator:v0.0.4 $IMAGE_REGISTRY/docker-machine-operator:$TAG
crane cp ghcr.io/appscode/external-dns-operator:v0.0.8 $IMAGE_REGISTRY/external-dns-operator:$TAG
crane cp ghcr.io/appscode/falco-ui-server:v0.0.4 $IMAGE_REGISTRY/falco-ui-server:$TAG
crane cp ghcr.io/appscode/fileserver:v0.0.1 $IMAGE_REGISTRY/fileserver:$TAG
crane cp ghcr.io/appscode/flux-cli:v2.3.0 $IMAGE_REGISTRY/flux-cli:$TAG
crane cp ghcr.io/appscode/grafana-tools:v0.0.12 $IMAGE_REGISTRY/grafana-tools:$TAG
crane cp ghcr.io/appscode/grafana:v2024.7.7 $IMAGE_REGISTRY/grafana:$TAG
crane cp ghcr.io/appscode/inbox-agent:v0.0.1 $IMAGE_REGISTRY/inbox-agent:$TAG
crane cp ghcr.io/appscode/inbox-server:latest $IMAGE_REGISTRY/inbox-server:$TAG
crane cp ghcr.io/appscode/inbox-ui:0.0.2 $IMAGE_REGISTRY/inbox-ui:$TAG
crane cp ghcr.io/appscode/k8s-wait-for:v2.0 $IMAGE_REGISTRY/k8s-wait-for:$TAG
crane cp ghcr.io/appscode/kube-rbac-proxy:v0.11.0 $IMAGE_REGISTRY/kube-rbac-proxy:$TAG
crane cp ghcr.io/appscode/kube-rbac-proxy:v0.13.0 $IMAGE_REGISTRY/kube-rbac-proxy:$TAG
crane cp ghcr.io/appscode/kube-rbac-proxy:v0.15.0 $IMAGE_REGISTRY/kube-rbac-proxy:$TAG
crane cp ghcr.io/appscode/kube-ui-server:v0.0.46 $IMAGE_REGISTRY/kube-ui-server:$TAG
crane cp ghcr.io/appscode/kubedb-ui:0.7.6 $IMAGE_REGISTRY/kubedb-ui:$TAG
crane cp ghcr.io/appscode/license-proxyserver:v0.0.17 $IMAGE_REGISTRY/license-proxyserver:$TAG
crane cp ghcr.io/appscode/maxmind-geoip:city-mmdb-latest $IMAGE_REGISTRY/maxmind-geoip:$TAG
crane cp ghcr.io/appscode/openfga:v1.6.0 $IMAGE_REGISTRY/openfga:$TAG
crane cp ghcr.io/appscode/panopticon:v0.0.14 $IMAGE_REGISTRY/panopticon:$TAG
crane cp ghcr.io/appscode/petset:v0.0.7 $IMAGE_REGISTRY/petset:$TAG
crane cp ghcr.io/appscode/platform-ui:0.8.5 $IMAGE_REGISTRY/platform-ui:$TAG
crane cp ghcr.io/appscode/prom-authproxy:v0.0.1 $IMAGE_REGISTRY/prom-authproxy:$TAG
crane cp ghcr.io/appscode/reloader:v1.0.79 $IMAGE_REGISTRY/reloader:$TAG
crane cp ghcr.io/appscode/s3proxy:sha-a82ca68 $IMAGE_REGISTRY/s3proxy:$TAG
crane cp ghcr.io/appscode/scanner:v0.0.19 $IMAGE_REGISTRY/scanner:$TAG
crane cp ghcr.io/appscode/service-provider:v0.0.1 $IMAGE_REGISTRY/service-provider:$TAG
crane cp ghcr.io/appscode/sidekick:v0.0.8 $IMAGE_REGISTRY/sidekick:$TAG
crane cp ghcr.io/appscode/supervisor:v0.0.6 $IMAGE_REGISTRY/supervisor:$TAG
crane cp ghcr.io/appscode/trickster:v2.0.0-beta3 $IMAGE_REGISTRY/trickster:$TAG
crane cp ghcr.io/appscode/vcluster-plugin:v0.0.2 $IMAGE_REGISTRY/vcluster-plugin:$TAG
crane cp ghcr.io/external-secrets/external-secrets:v0.9.12 $IMAGE_REGISTRY/external-secrets:$TAG
crane cp ghcr.io/fluxcd/helm-controller:v1.0.1 $IMAGE_REGISTRY/flux-helm-controller:$TAG
crane cp ghcr.io/fluxcd/kustomize-controller:v1.3.0 $IMAGE_REGISTRY/kustomize-controller:$TAG
crane cp ghcr.io/fluxcd/notification-controller:v1.3.0 $IMAGE_REGISTRY/notification-controller:$TAG
crane cp ghcr.io/fluxcd/source-controller:v1.3.0 $IMAGE_REGISTRY/flux-source-controller:$TAG
crane cp ghcr.io/kedacore/http-add-on-interceptor:0.8.0 $IMAGE_REGISTRY/keda-http-add-on-interceptor:$TAG
crane cp ghcr.io/kedacore/http-add-on-operator:0.8.0 $IMAGE_REGISTRY/keda-http-add-on-operator:$TAG
crane cp ghcr.io/kedacore/http-add-on-scaler:0.8.0 $IMAGE_REGISTRY/keda-http-add-on-scaler:$TAG
crane cp ghcr.io/kedacore/keda-admission-webhooks:2.15.1 $IMAGE_REGISTRY/keda-admission-webhooks:$TAG
crane cp ghcr.io/kedacore/keda-metrics-apiserver:2.15.1 $IMAGE_REGISTRY/keda-metrics-apiserver:$TAG
crane cp ghcr.io/kedacore/keda:2.15.1 $IMAGE_REGISTRY/keda:$TAG
crane cp ghcr.io/kluster-manager/addon-manager:v0.14.0 $IMAGE_REGISTRY/addon-manager:$TAG
crane cp ghcr.io/kluster-manager/cluster-auth:v0.0.5 $IMAGE_REGISTRY/cluster-auth:$TAG
crane cp ghcr.io/kluster-manager/cluster-gateway-manager:v1.9.1 $IMAGE_REGISTRY/cluster-gateway-manager:$TAG
crane cp ghcr.io/kluster-manager/cluster-gateway:v1.9.1 $IMAGE_REGISTRY/cluster-gateway:$TAG
crane cp ghcr.io/kluster-manager/cluster-proxy:v0.5.0 $IMAGE_REGISTRY/cluster-proxy:$TAG
crane cp ghcr.io/kluster-manager/clusteradm:v0.9.0 $IMAGE_REGISTRY/clusteradm:$TAG
crane cp ghcr.io/kluster-manager/fluxcd-addon:v0.0.4 $IMAGE_REGISTRY/fluxcd-addon:$TAG
crane cp ghcr.io/kluster-manager/managed-serviceaccount:v0.6.0 $IMAGE_REGISTRY/managed-serviceaccount:$TAG
crane cp ghcr.io/kluster-manager/placement:v0.14.0 $IMAGE_REGISTRY/placement:$TAG
crane cp ghcr.io/kluster-manager/registration-operator:v0.14.0 $IMAGE_REGISTRY/registration-operator:$TAG
crane cp ghcr.io/kluster-manager/registration:v0.14.0 $IMAGE_REGISTRY/registration:$TAG
crane cp ghcr.io/kluster-manager/work:v0.14.0 $IMAGE_REGISTRY/work:$TAG
crane cp ghcr.io/kubedb/kubedb-autoscaler:v0.33.0 $IMAGE_REGISTRY/kubedb-autoscaler:$TAG
crane cp ghcr.io/kubedb/kubedb-ops-manager:v0.35.0 $IMAGE_REGISTRY/kubedb-ops-manager:$TAG
crane cp ghcr.io/kubedb/kubedb-provisioner:v0.48.0 $IMAGE_REGISTRY/kubedb-provisioner:$TAG
crane cp ghcr.io/kubedb/kubedb-ui-server:v0.24.0 $IMAGE_REGISTRY/kubedb-ui-server:$TAG
crane cp ghcr.io/kubedb/kubedb-webhook-server:v0.24.0 $IMAGE_REGISTRY/kubedb-webhook-server:$TAG
crane cp ghcr.io/kubedb/pg-coordinator:v0.32.0 $IMAGE_REGISTRY/pg-coordinator:$TAG
crane cp ghcr.io/kubedb/postgres-init:0.15.0 $IMAGE_REGISTRY/postgres-init:$TAG
crane cp ghcr.io/kubedb/postgres-restic-plugin:v0.11.0_16.1 $IMAGE_REGISTRY/postgres-restic-plugin:$TAG
crane cp ghcr.io/kubedb/redis-init:0.9.0 $IMAGE_REGISTRY/redis-init:$TAG
crane cp ghcr.io/kubedb/redis-restic-plugin:v0.11.0 $IMAGE_REGISTRY/redis-restic-plugin:$TAG
crane cp ghcr.io/kubedb/redis_exporter:1.58.0 $IMAGE_REGISTRY/redis_exporter:$TAG
crane cp ghcr.io/kubestash/kubedump:v0.12.0 $IMAGE_REGISTRY/kubedump:$TAG
crane cp ghcr.io/kubestash/kubestash:v0.13.0 $IMAGE_REGISTRY/kubestash:$TAG
crane cp ghcr.io/kubevault/vault-operator:v0.19.0 $IMAGE_REGISTRY/vault-operator:$TAG
crane cp ghcr.io/kyverno/background-controller:v1.12.5 $IMAGE_REGISTRY/background-controller:$TAG
crane cp ghcr.io/kyverno/cleanup-controller:v1.12.5 $IMAGE_REGISTRY/cleanup-controller:$TAG
crane cp ghcr.io/kyverno/kyverno:v1.12.5 $IMAGE_REGISTRY/kyverno:$TAG
crane cp ghcr.io/kyverno/kyvernopre:v1.12.5 $IMAGE_REGISTRY/kyvernopre:$TAG
crane cp ghcr.io/kyverno/reports-controller:v1.12.5 $IMAGE_REGISTRY/reports-controller:$TAG
crane cp ghcr.io/loft-sh/vcluster-oss:0.20.0 $IMAGE_REGISTRY/vcluster-oss:$TAG
crane cp ghcr.io/voyagermesh/echoserver:v20221109 $IMAGE_REGISTRY/echoserver:$TAG
crane cp ghcr.io/voyagermesh/envoy:v1.29.9-ac $IMAGE_REGISTRY/envoy:$TAG
crane cp ghcr.io/voyagermesh/gateway-converter:v0.0.1 $IMAGE_REGISTRY/gateway-converter:$TAG
crane cp ghcr.io/voyagermesh/gateway:v1.1.1 $IMAGE_REGISTRY/gateway:$TAG
crane cp hashicorp/vault-csi-provider:1.4.1 $IMAGE_REGISTRY/vault-csi-provider:$TAG
crane cp hashicorp/vault-secrets-operator:0.4.3 $IMAGE_REGISTRY/vault-secrets-operator:$TAG
crane cp hashicorp/vault:1.15.2 $IMAGE_REGISTRY/vault:$TAG
crane cp k0sproject/k0s:v1.30.2-k0s.0 $IMAGE_REGISTRY/k0s:$TAG
crane cp natsio/nats-server-config-reloader:0.15.0 $IMAGE_REGISTRY/nats-server-config-reloader:$TAG
crane cp natsio/prometheus-nats-exporter:0.15.0 $IMAGE_REGISTRY/prometheus-nats-exporter:$TAG
crane cp openpolicyagent/gatekeeper:v3.13.3 $IMAGE_REGISTRY/gatekeeper:$TAG
crane cp opensearchproject/opensearch:2.1.0 $IMAGE_REGISTRY/opensearch:$TAG
crane cp prometheuscommunity/postgres-exporter:v0.15.0 $IMAGE_REGISTRY/postgres-exporter:$TAG
crane cp quay.io/jetstack/cert-manager-cainjector:v1.15.2 $IMAGE_REGISTRY/cert-manager-cainjector:$TAG
crane cp quay.io/jetstack/cert-manager-controller:v1.15.2 $IMAGE_REGISTRY/cert-manager-controller:$TAG
crane cp quay.io/jetstack/cert-manager-webhook:v1.15.2 $IMAGE_REGISTRY/cert-manager-webhook:$TAG
crane cp quay.io/prometheus-operator/prometheus-config-reloader:v0.75.2 $IMAGE_REGISTRY/prometheus-config-reloader:$TAG
crane cp quay.io/prometheus-operator/prometheus-operator:v0.75.2 crane cp quay.io/prometheus/alertmanager:v0.27.0 $IMAGE_REGISTRY/alertmanager:$TAG
crane cp quay.io/prometheus/node-exporter:v1.8.2 $IMAGE_REGISTRY/node-exporter:$TAG
crane cp quay.io/prometheus/prometheus:v2.54.0 $IMAGE_REGISTRY/prometheus:$TAG
crane cp rabbitmq:3.12.1-management $IMAGE_REGISTRY/rabbitmq:$TAG
crane cp rancher/k3s:v1.30.2-k3s1 $IMAGE_REGISTRY/k3s:$TAG
crane cp rancher/kine:v0.11.4 $IMAGE_REGISTRY/kine:$TAG
crane cp registry.k8s.io/autoscaling/cluster-autoscaler:v1.27.1 $IMAGE_REGISTRY/cluster-autoscaler:$TAG
crane cp registry.k8s.io/csi-secrets-store/driver:v1.4.1 $IMAGE_REGISTRY/driver:$TAG
crane cp registry.k8s.io/ingress-nginx/controller:v1.11.1 $IMAGE_REGISTRY/ingress-nginx-controller:$TAG
crane cp registry.k8s.io/kube-apiserver:v1.30.2 $IMAGE_REGISTRY/kube-apiserver:$TAG
crane cp registry.k8s.io/kube-controller-manager:v1.30.2 $IMAGE_REGISTRY/kube-controller-manager:$TAG
crane cp registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.13.0 $IMAGE_REGISTRY/kube-state-metrics:$TAG
crane cp registry.k8s.io/prometheus-adapter/prometheus-adapter:v0.11.2 $IMAGE_REGISTRY/prometheus-adapter:$TAG
crane cp registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.10.0 $IMAGE_REGISTRY/csi-node-driver-registrar:$TAG
crane cp registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.11.1 $IMAGE_REGISTRY/csi-node-driver-registrar:$TAG
crane cp registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.8.0 $IMAGE_REGISTRY/csi-node-driver-registrar:$TAG
crane cp registry.k8s.io/sig-storage/csi-provisioner:v4.0.0 $IMAGE_REGISTRY/csi-provisioner:$TAG
crane cp registry.k8s.io/sig-storage/csi-snapshotter:v6.3.3 $IMAGE_REGISTRY/csi-snapshotter:$TAG
crane cp registry.k8s.io/sig-storage/livenessprobe:v2.10.0 $IMAGE_REGISTRY/csi-driver-livenessprobe:$TAG
crane cp registry.k8s.io/sig-storage/livenessprobe:v2.12.0 $IMAGE_REGISTRY/csi-driver-livenessprobe:$TAG
crane cp registry.k8s.io/sig-storage/livenessprobe:v2.13.1 $IMAGE_REGISTRY/csi-driver-livenessprobe:$TAG
crane cp registry.k8s.io/sig-storage/nfsplugin:v4.7.0 $IMAGE_REGISTRY/nfsplugin:$TAG
crane cp registry.k8s.io/sig-storage/snapshot-controller:v8.0.1 $IMAGE_REGISTRY/snapshot-controller:$TAG
crane cp registry.k8s.io/sig-storage/snapshot-validation-webhook:v8.0.1 $IMAGE_REGISTRY/snapshot-validation-webhook:$TAG
