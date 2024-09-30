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

OS=$(uname -o)
if [ "${OS}" = "GNU/Linux" ]; then
    OS=Linux
fi
ARCH=$(uname -m)
if [ "${ARCH}" = "aarch64" ]; then
    ARCH=arm64
fi
curl -sL "https://github.com/google/go-containerregistry/releases/latest/download/go-containerregistry_${OS}_${ARCH}.tar.gz" >/tmp/go-containerregistry.tar.gz
tar -zxvf /tmp/go-containerregistry.tar.gz -C /tmp/
mv /tmp/crane .

CMD="./crane"

$CMD cp bitnami/kubectl:1.28.5 $IMAGE_REGISTRY/bitnami/kubectl:1.28.5
$CMD cp bitnami/sealed-secrets-controller:0.25.0 $IMAGE_REGISTRY/bitnami/sealed-secrets-controller:0.25.0
$CMD cp cassandra:4.1.3 $IMAGE_REGISTRY/cassandra:4.1.3
$CMD cp falcosecurity/falco-no-driver:0.37.0 $IMAGE_REGISTRY/falcosecurity/falco-no-driver:0.37.0
$CMD cp falcosecurity/falcoctl:0.7.1 $IMAGE_REGISTRY/falcosecurity/falcoctl:0.7.1
$CMD cp ghcr.io/appscode-charts/ace-ocm-addons:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/ace-ocm-addons:v2024.9.30
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-elasticsearchautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-elasticsearchautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-kafkaautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-kafkaautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-mariadbautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-mariadbautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-mongodbautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-mongodbautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-mysqlautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-mysqlautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-perconaxtradbautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-perconaxtradbautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-pgbouncerautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-pgbouncerautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-pgpoolautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-pgpoolautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-postgresautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-postgresautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-proxysqlautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-proxysqlautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-redisautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-redisautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-redissentinelautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-redissentinelautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/autoscalingkubedbcom-singlestoreautoscaler-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/autoscalingkubedbcom-singlestoreautoscaler-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/aws-ebs-csi-driver:2.23.0 $IMAGE_REGISTRY/appscode-charts/aws-ebs-csi-driver:2.23.0
$CMD cp ghcr.io/appscode-charts/capa-vpc-peering-operator:v2023.12.11 $IMAGE_REGISTRY/appscode-charts/capa-vpc-peering-operator:v2023.12.11
$CMD cp ghcr.io/appscode-charts/capi-catalog:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/capi-catalog:v2024.9.30
$CMD cp ghcr.io/appscode-charts/capi-ops-manager:v2024.5.14 $IMAGE_REGISTRY/appscode-charts/capi-ops-manager:v2024.5.14
$CMD cp ghcr.io/appscode-charts/catalog-manager:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/catalog-manager:v2024.9.30
$CMD cp ghcr.io/appscode-charts/cert-manager-csi-driver-cacerts:v2024.7.28 $IMAGE_REGISTRY/appscode-charts/cert-manager-csi-driver-cacerts:v2024.7.28
$CMD cp ghcr.io/appscode-charts/cert-manager:v1.15.2 $IMAGE_REGISTRY/appscode-charts/cert-manager:v1.15.2
$CMD cp ghcr.io/appscode-charts/cluster-auth-manager:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/cluster-auth-manager:v2024.9.30
$CMD cp ghcr.io/appscode-charts/cluster-autoscaler:9.29.0 $IMAGE_REGISTRY/appscode-charts/cluster-autoscaler:9.29.0
$CMD cp ghcr.io/appscode-charts/cluster-gateway-manager:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/cluster-gateway-manager:v2024.9.30
$CMD cp ghcr.io/appscode-charts/cluster-manager-hub:v2024.7.10 $IMAGE_REGISTRY/appscode-charts/cluster-manager-hub:v2024.7.10
$CMD cp ghcr.io/appscode-charts/cluster-manager-spoke:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/cluster-manager-spoke:v2024.9.30
$CMD cp ghcr.io/appscode-charts/cluster-presets:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/cluster-presets:v2024.9.30
$CMD cp ghcr.io/appscode-charts/cluster-proxy-manager:v2024.7.10 $IMAGE_REGISTRY/appscode-charts/cluster-proxy-manager:v2024.7.10
$CMD cp ghcr.io/appscode-charts/config-syncer:v0.15.2 $IMAGE_REGISTRY/appscode-charts/config-syncer:v0.15.2
$CMD cp ghcr.io/appscode-charts/corekubestashcom-backupbatch-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/corekubestashcom-backupbatch-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/corekubestashcom-backupblueprint-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/corekubestashcom-backupblueprint-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/corekubestashcom-backupconfiguration-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/corekubestashcom-backupconfiguration-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/corekubestashcom-backupsession-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/corekubestashcom-backupsession-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/corekubestashcom-hooktemplate-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/corekubestashcom-hooktemplate-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/corekubestashcom-restoresession-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/corekubestashcom-restoresession-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/corekubestashcom-restoresession-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/corekubestashcom-restoresession-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/crossplane:1.14.0 $IMAGE_REGISTRY/appscode-charts/crossplane:1.14.0
$CMD cp ghcr.io/appscode-charts/csi-driver-nfs:v4.7.0 $IMAGE_REGISTRY/appscode-charts/csi-driver-nfs:v4.7.0
$CMD cp ghcr.io/appscode-charts/csi-secrets-store-provider-azure:1.5.2 $IMAGE_REGISTRY/appscode-charts/csi-secrets-store-provider-azure:1.5.2
$CMD cp ghcr.io/appscode-charts/external-dns-operator:v2024.4.19 $IMAGE_REGISTRY/appscode-charts/external-dns-operator:v2024.4.19
$CMD cp ghcr.io/appscode-charts/external-secrets:0.9.12 $IMAGE_REGISTRY/appscode-charts/external-secrets:0.9.12
$CMD cp ghcr.io/appscode-charts/falco-ui-server:v2024.5.17 $IMAGE_REGISTRY/appscode-charts/falco-ui-server:v2024.5.17
$CMD cp ghcr.io/appscode-charts/falco:4.0.0 $IMAGE_REGISTRY/appscode-charts/falco:4.0.0
$CMD cp ghcr.io/appscode-charts/flux2:2.13.0 $IMAGE_REGISTRY/appscode-charts/flux2:2.13.0
$CMD cp ghcr.io/appscode-charts/fluxcd-manager:v2024.7.10 $IMAGE_REGISTRY/appscode-charts/fluxcd-manager:v2024.7.10
$CMD cp ghcr.io/appscode-charts/gatekeeper-grafana-dashboards:v2023.10.1 $IMAGE_REGISTRY/appscode-charts/gatekeeper-grafana-dashboards:v2023.10.1
$CMD cp ghcr.io/appscode-charts/gatekeeper-library:v2023.10.1 $IMAGE_REGISTRY/appscode-charts/gatekeeper-library:v2023.10.1
$CMD cp ghcr.io/appscode-charts/gatekeeper:3.13.3 $IMAGE_REGISTRY/appscode-charts/gatekeeper:3.13.3
$CMD cp ghcr.io/appscode-charts/gateway-api:v1.1.0 $IMAGE_REGISTRY/appscode-charts/gateway-api:v1.1.0
$CMD cp ghcr.io/appscode-charts/grafana-operator:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/grafana-operator:v2024.9.30
$CMD cp ghcr.io/appscode-charts/hub-cluster-robot:v2024.8.9 $IMAGE_REGISTRY/appscode-charts/hub-cluster-robot:v2024.8.9
$CMD cp ghcr.io/appscode-charts/inbox-agent:v2024.5.3 $IMAGE_REGISTRY/appscode-charts/inbox-agent:v2024.5.3
$CMD cp ghcr.io/appscode-charts/inbox-server:v2024.5.3 $IMAGE_REGISTRY/appscode-charts/inbox-server:v2024.5.3
$CMD cp ghcr.io/appscode-charts/inbox-ui:v2024.5.3 $IMAGE_REGISTRY/appscode-charts/inbox-ui:v2024.5.3
$CMD cp ghcr.io/appscode-charts/ingress-nginx:4.11.1 $IMAGE_REGISTRY/appscode-charts/ingress-nginx:4.11.1
$CMD cp ghcr.io/appscode-charts/keda-add-ons-http:0.8.0 $IMAGE_REGISTRY/appscode-charts/keda-add-ons-http:0.8.0
$CMD cp ghcr.io/appscode-charts/keda:2.15.1 $IMAGE_REGISTRY/appscode-charts/keda:2.15.1
$CMD cp ghcr.io/appscode-charts/kube-grafana-dashboards:v2023.10.1 $IMAGE_REGISTRY/appscode-charts/kube-grafana-dashboards:v2023.10.1
$CMD cp ghcr.io/appscode-charts/kube-prometheus-stack:61.8.0 $IMAGE_REGISTRY/appscode-charts/kube-prometheus-stack:61.8.0
$CMD cp ghcr.io/appscode-charts/kube-ui-server:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/kube-ui-server:v2024.9.30
$CMD cp ghcr.io/appscode-charts/kubedb-opscenter:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/kubedb-opscenter:v2024.9.30
$CMD cp ghcr.io/appscode-charts/kubedb-provider-aws:v2024.1.31 $IMAGE_REGISTRY/appscode-charts/kubedb-provider-aws:v2024.1.31
$CMD cp ghcr.io/appscode-charts/kubedb-provider-azure:v2024.1.31 $IMAGE_REGISTRY/appscode-charts/kubedb-provider-azure:v2024.1.31
$CMD cp ghcr.io/appscode-charts/kubedb-provider-gcp:v2024.1.31 $IMAGE_REGISTRY/appscode-charts/kubedb-provider-gcp:v2024.1.31
$CMD cp ghcr.io/appscode-charts/kubedb-ui-presets:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/kubedb-ui-presets:v2024.9.30
$CMD cp ghcr.io/appscode-charts/kubedb:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/kubedb:v2024.9.30
$CMD cp ghcr.io/appscode-charts/kubedbcom-cassandra-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-cassandra-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-clickhouse-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-clickhouse-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-clickhouse-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-clickhouse-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-druid-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-druid-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-druid-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-druid-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-elasticsearch-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-elasticsearch-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-elasticsearch-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-elasticsearch-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-ferretdb-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-ferretdb-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-ferretdb-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-ferretdb-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-kafka-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-kafka-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-kafka-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-kafka-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-mariadb-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-mariadb-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-mariadb-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-mariadb-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-memcached-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-memcached-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-memcached-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-memcached-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-mongodb-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-mongodb-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-mongodb-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-mongodb-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-mssqlserver-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-mssqlserver-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-mssqlserver-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-mssqlserver-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-mysql-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-mysql-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-mysql-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-mysql-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-perconaxtradb-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-perconaxtradb-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-perconaxtradb-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-perconaxtradb-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-pgbouncer-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-pgbouncer-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-pgbouncer-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-pgbouncer-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-pgpool-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-pgpool-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-pgpool-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-pgpool-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-postgres-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-postgres-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-postgres-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-postgres-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-proxysql-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-proxysql-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-proxysql-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-proxysql-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-rabbitmq-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-rabbitmq-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-rabbitmq-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-rabbitmq-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-redis-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-redis-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-redis-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-redis-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-redissentinel-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-redissentinel-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-singlestore-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-singlestore-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-singlestore-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-singlestore-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-solr-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-solr-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-solr-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-solr-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-zookeeper-editor-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-zookeeper-editor-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubedbcom-zookeeper-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/kubedbcom-zookeeper-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/kubestash:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/kubestash:v2024.9.30
$CMD cp ghcr.io/appscode-charts/kubevault-opscenter:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/kubevault-opscenter:v2024.9.30
$CMD cp ghcr.io/appscode-charts/kubevault:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/kubevault:v2024.9.30
$CMD cp ghcr.io/appscode-charts/kyverno-policies:3.2.5 $IMAGE_REGISTRY/appscode-charts/kyverno-policies:3.2.5
$CMD cp ghcr.io/appscode-charts/kyverno:3.2.6 $IMAGE_REGISTRY/appscode-charts/kyverno:3.2.6
$CMD cp ghcr.io/appscode-charts/license-proxyserver-manager:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/license-proxyserver-manager:v2024.9.30
$CMD cp ghcr.io/appscode-charts/license-proxyserver:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/license-proxyserver:v2024.9.30
$CMD cp ghcr.io/appscode-charts/longhorn:1.6.2 $IMAGE_REGISTRY/appscode-charts/longhorn:1.6.2
$CMD cp ghcr.io/appscode-charts/managed-serviceaccount-manager:v2024.7.10 $IMAGE_REGISTRY/appscode-charts/managed-serviceaccount-manager:v2024.7.10
$CMD cp ghcr.io/appscode-charts/metrics-server:3.11.0 $IMAGE_REGISTRY/appscode-charts/metrics-server:3.11.0
$CMD cp ghcr.io/appscode-charts/monitoring-operator:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/monitoring-operator:v2024.9.30
$CMD cp ghcr.io/appscode-charts/multicluster-controlplane:v2024.7.10 $IMAGE_REGISTRY/appscode-charts/multicluster-controlplane:v2024.7.10
$CMD cp ghcr.io/appscode-charts/multicluster-ingress-reader:v2024.7.10 $IMAGE_REGISTRY/appscode-charts/multicluster-ingress-reader:v2024.7.10
$CMD cp ghcr.io/appscode-charts/opencost-grafana-dashboards:v2023.10.1 $IMAGE_REGISTRY/appscode-charts/opencost-grafana-dashboards:v2023.10.1
$CMD cp ghcr.io/appscode-charts/opencost:1.18.1 $IMAGE_REGISTRY/appscode-charts/opencost:1.18.1
$CMD cp ghcr.io/appscode-charts/opscenter-features:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/opscenter-features:v2024.9.30
$CMD cp ghcr.io/appscode-charts/opskubedbcom-elasticsearchopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-elasticsearchopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-kafkaopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-kafkaopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-mariadbopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-mariadbopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-memcachedopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-memcachedopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-mongodbopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-mongodbopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-mssqlserveropsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-mssqlserveropsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-mysqlopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-mysqlopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-perconaxtradbopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-perconaxtradbopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-pgbounceropsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-pgbounceropsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-pgpoolopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-pgpoolopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-postgresopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-postgresopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-proxysqlopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-proxysqlopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-redisopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-redisopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-redissentinelopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-redissentinelopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-singlestoreopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-singlestoreopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-solropsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-solropsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/opskubedbcom-zookeeperopsrequest-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/opskubedbcom-zookeeperopsrequest-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/panopticon:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/panopticon:v2024.9.30
$CMD cp ghcr.io/appscode-charts/prepare-cluster:v2023.12.21 $IMAGE_REGISTRY/appscode-charts/prepare-cluster:v2023.12.21
$CMD cp ghcr.io/appscode-charts/prometheus-adapter:4.9.0 $IMAGE_REGISTRY/appscode-charts/prometheus-adapter:4.9.0
$CMD cp ghcr.io/appscode-charts/reloader:1.0.79 $IMAGE_REGISTRY/appscode-charts/reloader:1.0.79
$CMD cp ghcr.io/appscode-charts/scanner:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/scanner:v2024.9.30
$CMD cp ghcr.io/appscode-charts/sealed-secrets:2.14.2 $IMAGE_REGISTRY/appscode-charts/sealed-secrets:2.14.2
$CMD cp ghcr.io/appscode-charts/secrets-store-csi-driver-provider-aws:0.3.6 $IMAGE_REGISTRY/appscode-charts/secrets-store-csi-driver-provider-aws:0.3.6
$CMD cp ghcr.io/appscode-charts/secrets-store-csi-driver-provider-gcp:0.1.0 $IMAGE_REGISTRY/appscode-charts/secrets-store-csi-driver-provider-gcp:0.1.0
$CMD cp ghcr.io/appscode-charts/secrets-store-csi-driver:1.4.1 $IMAGE_REGISTRY/appscode-charts/secrets-store-csi-driver:1.4.1
$CMD cp ghcr.io/appscode-charts/service-backend:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/service-backend:v2024.9.30
$CMD cp ghcr.io/appscode-charts/service-gateway-presets:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/service-gateway-presets:v2024.9.30
$CMD cp ghcr.io/appscode-charts/service-provider:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/service-provider:v2024.9.30
$CMD cp ghcr.io/appscode-charts/sidekick:v2024.8.21 $IMAGE_REGISTRY/appscode-charts/sidekick:v2024.8.21
$CMD cp ghcr.io/appscode-charts/snapshot-controller:3.0.5 $IMAGE_REGISTRY/appscode-charts/snapshot-controller:3.0.5
$CMD cp ghcr.io/appscode-charts/stash-opscenter:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/stash-opscenter:v2024.9.30
$CMD cp ghcr.io/appscode-charts/stash-presets:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/stash-presets:v2024.9.30
$CMD cp ghcr.io/appscode-charts/stash:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/stash:v2024.9.30
$CMD cp ghcr.io/appscode-charts/supervisor:v2024.9.30 $IMAGE_REGISTRY/appscode-charts/supervisor:v2024.9.30
$CMD cp ghcr.io/appscode-charts/topolvm:15.0.0 $IMAGE_REGISTRY/appscode-charts/topolvm:15.0.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-alert:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-alert:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-backup-option:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-backup-option:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-backupconfiguration:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-backupconfiguration:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-certificates:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-certificates:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-data-sources-items:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-data-sources-items:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-database-runtime-settings:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-database-runtime-settings:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-env-from:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-env-from:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-env:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-env:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-health-checker:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-health-checker:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-initialization:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-initialization:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-jwtoidc-config:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-jwtoidc-config:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-kubedb-ui-presets:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-kubedb-ui-presets:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-match-expressions:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-match-expressions:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-match-fields:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-match-fields:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-monitoring-option:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-monitoring-option:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-pod-template:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-pod-template:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-repository-create:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-repository-create:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-resources:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-resources:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-runtime-settings:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-runtime-settings:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-se-linux-options:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-se-linux-options:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-selector:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-selector:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-service-templates:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-service-templates:v0.6.0
$CMD cp ghcr.io/appscode-charts/uibytebuildersdev-component-stash-presets:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uibytebuildersdev-component-stash-presets:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-capi-capa-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-capi-capa-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-capi-core-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-capi-core-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-crossplane-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-crossplane-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-ocm-hub-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-ocm-hub-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-ocm-mc-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-ocm-mc-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-ocm-spoke-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-ocm-spoke-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-backup-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-backup-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-core-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-core-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-cost-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-cost-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-datastore-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-datastore-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-networking-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-networking-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-observability-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-observability-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-policy-management-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-policy-management-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-secret-management-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-secret-management-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-security-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-security-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-storage-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-storage-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-tools-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-opscenter-tools-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/uik8sappscodecom-featureset-saas-core-editor:v0.6.0 $IMAGE_REGISTRY/appscode-charts/uik8sappscodecom-featureset-saas-core-editor:v0.6.0
$CMD cp ghcr.io/appscode-charts/vault-secrets-operator:0.4.3 $IMAGE_REGISTRY/appscode-charts/vault-secrets-operator:0.4.3
$CMD cp ghcr.io/appscode-charts/vault:0.27.0 $IMAGE_REGISTRY/appscode-charts/vault:0.27.0
$CMD cp ghcr.io/appscode-charts/voyager-gateway:v2024.8.30 $IMAGE_REGISTRY/appscode-charts/voyager-gateway:v2024.8.30
$CMD cp ghcr.io/appscode-charts/voyager:v2024.8.30 $IMAGE_REGISTRY/appscode-charts/voyager:v2024.8.30
$CMD cp ghcr.io/appscode-images/nats:2.10.18-alpine $IMAGE_REGISTRY/appscode-images/nats:2.10.18-alpine
$CMD cp ghcr.io/appscode-images/postgres:15.5-alpine $IMAGE_REGISTRY/appscode-images/postgres:15.5-alpine
$CMD cp ghcr.io/appscode-images/redis:7.2.4-bookworm $IMAGE_REGISTRY/appscode-images/redis:7.2.4-bookworm
$CMD cp ghcr.io/appscode/b3:v2024.9.30 $IMAGE_REGISTRY/appscode/b3:v2024.9.30
$CMD cp ghcr.io/appscode/capa-vpc-peering-operator:v0.0.4 $IMAGE_REGISTRY/appscode/capa-vpc-peering-operator:v0.0.4
$CMD cp ghcr.io/appscode/capi-ops-manager:v0.0.1 $IMAGE_REGISTRY/appscode/capi-ops-manager:v0.0.1
$CMD cp ghcr.io/appscode/catalog-manager:v0.0.1 $IMAGE_REGISTRY/appscode/catalog-manager:v0.0.1
$CMD cp ghcr.io/appscode/cluster-presets:v0.0.3 $IMAGE_REGISTRY/appscode/cluster-presets:v0.0.3
$CMD cp ghcr.io/appscode/cluster-ui:0.9.7 $IMAGE_REGISTRY/appscode/cluster-ui:0.9.7
$CMD cp ghcr.io/appscode/config-syncer:v0.15.2-ent $IMAGE_REGISTRY/appscode/config-syncer:v0.15.2-ent
$CMD cp ghcr.io/appscode/csi-driver-cacerts:v0.0.4 $IMAGE_REGISTRY/appscode/csi-driver-cacerts:v0.0.4
$CMD cp ghcr.io/appscode/docker-machine-operator:v0.0.4 $IMAGE_REGISTRY/appscode/docker-machine-operator:v0.0.4
$CMD cp ghcr.io/appscode/external-dns-operator:v0.0.8 $IMAGE_REGISTRY/appscode/external-dns-operator:v0.0.8
$CMD cp ghcr.io/appscode/falco-ui-server:v0.0.4 $IMAGE_REGISTRY/appscode/falco-ui-server:v0.0.4
$CMD cp ghcr.io/appscode/fileserver:v0.0.1 $IMAGE_REGISTRY/appscode/fileserver:v0.0.1
$CMD cp ghcr.io/appscode/flux-cli:v2.3.0 $IMAGE_REGISTRY/appscode/flux-cli:v2.3.0
$CMD cp ghcr.io/appscode/grafana-tools:v0.0.12 $IMAGE_REGISTRY/appscode/grafana-tools:v0.0.12
$CMD cp ghcr.io/appscode/grafana:v2024.7.7 $IMAGE_REGISTRY/appscode/grafana:v2024.7.7
$CMD cp ghcr.io/appscode/inbox-agent:v0.0.1 $IMAGE_REGISTRY/appscode/inbox-agent:v0.0.1
$CMD cp ghcr.io/appscode/inbox-server:latest $IMAGE_REGISTRY/appscode/inbox-server:latest
$CMD cp ghcr.io/appscode/inbox-ui:0.0.2 $IMAGE_REGISTRY/appscode/inbox-ui:0.0.2
$CMD cp ghcr.io/appscode/k8s-wait-for:v2.0 $IMAGE_REGISTRY/appscode/k8s-wait-for:v2.0
$CMD cp ghcr.io/appscode/kube-rbac-proxy:v0.11.0 $IMAGE_REGISTRY/appscode/kube-rbac-proxy:v0.11.0
$CMD cp ghcr.io/appscode/kube-rbac-proxy:v0.13.0 $IMAGE_REGISTRY/appscode/kube-rbac-proxy:v0.13.0
$CMD cp ghcr.io/appscode/kube-rbac-proxy:v0.15.0 $IMAGE_REGISTRY/appscode/kube-rbac-proxy:v0.15.0
$CMD cp ghcr.io/appscode/kube-ui-server:v0.0.46 $IMAGE_REGISTRY/appscode/kube-ui-server:v0.0.46
$CMD cp ghcr.io/appscode/kubedb-ui:0.7.6 $IMAGE_REGISTRY/appscode/kubedb-ui:0.7.6
$CMD cp ghcr.io/appscode/license-proxyserver:v0.0.17 $IMAGE_REGISTRY/appscode/license-proxyserver:v0.0.17
$CMD cp ghcr.io/appscode/maxmind-geoip:city-mmdb-latest $IMAGE_REGISTRY/appscode/maxmind-geoip:city-mmdb-latest
$CMD cp ghcr.io/appscode/openfga:v1.6.0 $IMAGE_REGISTRY/appscode/openfga:v1.6.0
$CMD cp ghcr.io/appscode/panopticon:v0.0.14 $IMAGE_REGISTRY/appscode/panopticon:v0.0.14
$CMD cp ghcr.io/appscode/petset:v0.0.7 $IMAGE_REGISTRY/appscode/petset:v0.0.7
$CMD cp ghcr.io/appscode/platform-ui:0.8.5 $IMAGE_REGISTRY/appscode/platform-ui:0.8.5
$CMD cp ghcr.io/appscode/prom-authproxy:v0.0.1 $IMAGE_REGISTRY/appscode/prom-authproxy:v0.0.1
$CMD cp ghcr.io/appscode/reloader:v1.0.79 $IMAGE_REGISTRY/appscode/reloader:v1.0.79
$CMD cp ghcr.io/appscode/s3proxy:sha-a82ca68 $IMAGE_REGISTRY/appscode/s3proxy:sha-a82ca68
$CMD cp ghcr.io/appscode/scanner:v0.0.19 $IMAGE_REGISTRY/appscode/scanner:v0.0.19
$CMD cp ghcr.io/appscode/service-provider:v0.0.1 $IMAGE_REGISTRY/appscode/service-provider:v0.0.1
$CMD cp ghcr.io/appscode/sidekick:v0.0.8 $IMAGE_REGISTRY/appscode/sidekick:v0.0.8
$CMD cp ghcr.io/appscode/supervisor:v0.0.6 $IMAGE_REGISTRY/appscode/supervisor:v0.0.6
$CMD cp ghcr.io/appscode/trickster:v2.0.0-beta3 $IMAGE_REGISTRY/appscode/trickster:v2.0.0-beta3
$CMD cp ghcr.io/external-secrets/external-secrets:v0.9.12 $IMAGE_REGISTRY/external-secrets/external-secrets:v0.9.12
$CMD cp ghcr.io/fluxcd/helm-controller:v1.0.1 $IMAGE_REGISTRY/fluxcd/helm-controller:v1.0.1
$CMD cp ghcr.io/fluxcd/kustomize-controller:v1.3.0 $IMAGE_REGISTRY/fluxcd/kustomize-controller:v1.3.0
$CMD cp ghcr.io/fluxcd/notification-controller:v1.3.0 $IMAGE_REGISTRY/fluxcd/notification-controller:v1.3.0
$CMD cp ghcr.io/fluxcd/source-controller:v1.3.0 $IMAGE_REGISTRY/fluxcd/source-controller:v1.3.0
$CMD cp ghcr.io/kedacore/http-add-on-interceptor:0.8.0 $IMAGE_REGISTRY/kedacore/http-add-on-interceptor:0.8.0
$CMD cp ghcr.io/kedacore/http-add-on-operator:0.8.0 $IMAGE_REGISTRY/kedacore/http-add-on-operator:0.8.0
$CMD cp ghcr.io/kedacore/http-add-on-scaler:0.8.0 $IMAGE_REGISTRY/kedacore/http-add-on-scaler:0.8.0
$CMD cp ghcr.io/kedacore/keda-admission-webhooks:2.15.1 $IMAGE_REGISTRY/kedacore/keda-admission-webhooks:2.15.1
$CMD cp ghcr.io/kedacore/keda-metrics-apiserver:2.15.1 $IMAGE_REGISTRY/kedacore/keda-metrics-apiserver:2.15.1
$CMD cp ghcr.io/kedacore/keda:2.15.1 $IMAGE_REGISTRY/kedacore/keda:2.15.1
$CMD cp ghcr.io/kluster-manager/addon-manager:v0.14.0 $IMAGE_REGISTRY/kluster-manager/addon-manager:v0.14.0
$CMD cp ghcr.io/kluster-manager/cluster-auth:v0.0.5 $IMAGE_REGISTRY/kluster-manager/cluster-auth:v0.0.5
$CMD cp ghcr.io/kluster-manager/cluster-gateway-manager:v1.9.1 $IMAGE_REGISTRY/kluster-manager/cluster-gateway-manager:v1.9.1
$CMD cp ghcr.io/kluster-manager/cluster-gateway:v1.9.1 $IMAGE_REGISTRY/kluster-manager/cluster-gateway:v1.9.1
$CMD cp ghcr.io/kluster-manager/cluster-proxy:v0.5.0 $IMAGE_REGISTRY/kluster-manager/cluster-proxy:v0.5.0
$CMD cp ghcr.io/kluster-manager/clusteradm:v0.9.0 $IMAGE_REGISTRY/kluster-manager/clusteradm:v0.9.0
$CMD cp ghcr.io/kluster-manager/fluxcd-addon:v0.0.4 $IMAGE_REGISTRY/kluster-manager/fluxcd-addon:v0.0.4
$CMD cp ghcr.io/kluster-manager/managed-serviceaccount:v0.6.0 $IMAGE_REGISTRY/kluster-manager/managed-serviceaccount:v0.6.0
$CMD cp ghcr.io/kluster-manager/placement:v0.14.0 $IMAGE_REGISTRY/kluster-manager/placement:v0.14.0
$CMD cp ghcr.io/kluster-manager/registration-operator:v0.14.0 $IMAGE_REGISTRY/kluster-manager/registration-operator:v0.14.0
$CMD cp ghcr.io/kluster-manager/registration:v0.14.0 $IMAGE_REGISTRY/kluster-manager/registration:v0.14.0
$CMD cp ghcr.io/kluster-manager/work:v0.14.0 $IMAGE_REGISTRY/kluster-manager/work:v0.14.0
$CMD cp ghcr.io/kubedb/kubedb-autoscaler:v0.33.0 $IMAGE_REGISTRY/kubedb/kubedb-autoscaler:v0.33.0
$CMD cp ghcr.io/kubedb/kubedb-ops-manager:v0.35.0 $IMAGE_REGISTRY/kubedb/kubedb-ops-manager:v0.35.0
$CMD cp ghcr.io/kubedb/kubedb-provisioner:v0.48.0 $IMAGE_REGISTRY/kubedb/kubedb-provisioner:v0.48.0
$CMD cp ghcr.io/kubedb/kubedb-ui-server:v0.24.0 $IMAGE_REGISTRY/kubedb/kubedb-ui-server:v0.24.0
$CMD cp ghcr.io/kubedb/kubedb-webhook-server:v0.24.0 $IMAGE_REGISTRY/kubedb/kubedb-webhook-server:v0.24.0
$CMD cp ghcr.io/kubedb/pg-coordinator:v0.32.0 $IMAGE_REGISTRY/kubedb/pg-coordinator:v0.32.0
$CMD cp ghcr.io/kubedb/postgres-init:0.15.0 $IMAGE_REGISTRY/kubedb/postgres-init:0.15.0
$CMD cp ghcr.io/kubedb/postgres-restic-plugin:v0.11.0_16.1 $IMAGE_REGISTRY/kubedb/postgres-restic-plugin:v0.11.0_16.1
$CMD cp ghcr.io/kubedb/redis-init:0.9.0 $IMAGE_REGISTRY/kubedb/redis-init:0.9.0
$CMD cp ghcr.io/kubedb/redis-restic-plugin:v0.11.0 $IMAGE_REGISTRY/kubedb/redis-restic-plugin:v0.11.0
$CMD cp ghcr.io/kubedb/redis_exporter:1.58.0 $IMAGE_REGISTRY/kubedb/redis_exporter:1.58.0
$CMD cp ghcr.io/kubestash/kubedump:v0.12.0 $IMAGE_REGISTRY/kubestash/kubedump:v0.12.0
$CMD cp ghcr.io/kubestash/kubestash:v0.13.0 $IMAGE_REGISTRY/kubestash/kubestash:v0.13.0
$CMD cp ghcr.io/kubevault/vault-operator:v0.19.0 $IMAGE_REGISTRY/kubevault/vault-operator:v0.19.0
$CMD cp ghcr.io/kyverno/background-controller:v1.12.5 $IMAGE_REGISTRY/kyverno/background-controller:v1.12.5
$CMD cp ghcr.io/kyverno/cleanup-controller:v1.12.5 $IMAGE_REGISTRY/kyverno/cleanup-controller:v1.12.5
$CMD cp ghcr.io/kyverno/kyverno:v1.12.5 $IMAGE_REGISTRY/kyverno/kyverno:v1.12.5
$CMD cp ghcr.io/kyverno/kyvernopre:v1.12.5 $IMAGE_REGISTRY/kyverno/kyvernopre:v1.12.5
$CMD cp ghcr.io/kyverno/reports-controller:v1.12.5 $IMAGE_REGISTRY/kyverno/reports-controller:v1.12.5
$CMD cp ghcr.io/voyagermesh/echoserver:v20221109 $IMAGE_REGISTRY/voyagermesh/echoserver:v20221109
$CMD cp ghcr.io/voyagermesh/envoy:v1.29.9-ac $IMAGE_REGISTRY/voyagermesh/envoy:v1.29.9-ac
$CMD cp ghcr.io/voyagermesh/gateway-converter:v0.0.1 $IMAGE_REGISTRY/voyagermesh/gateway-converter:v0.0.1
$CMD cp ghcr.io/voyagermesh/gateway:v1.1.1 $IMAGE_REGISTRY/voyagermesh/gateway:v1.1.1
$CMD cp hashicorp/vault-csi-provider:1.4.1 $IMAGE_REGISTRY/hashicorp/vault-csi-provider:1.4.1
$CMD cp hashicorp/vault-secrets-operator:0.4.3 $IMAGE_REGISTRY/hashicorp/vault-secrets-operator:0.4.3
$CMD cp hashicorp/vault:1.15.2 $IMAGE_REGISTRY/hashicorp/vault:1.15.2
$CMD cp natsio/nats-server-config-reloader:0.15.0 $IMAGE_REGISTRY/natsio/nats-server-config-reloader:0.15.0
$CMD cp natsio/prometheus-nats-exporter:0.15.0 $IMAGE_REGISTRY/natsio/prometheus-nats-exporter:0.15.0
$CMD cp openpolicyagent/gatekeeper:v3.13.3 $IMAGE_REGISTRY/openpolicyagent/gatekeeper:v3.13.3
$CMD cp opensearchproject/opensearch:2.1.0 $IMAGE_REGISTRY/opensearchproject/opensearch:2.1.0
$CMD cp prometheuscommunity/postgres-exporter:v0.15.0 $IMAGE_REGISTRY/prometheuscommunity/postgres-exporter:v0.15.0
$CMD cp quay.io/jetstack/cert-manager-cainjector:v1.15.2 $IMAGE_REGISTRY/jetstack/cert-manager-cainjector:v1.15.2
$CMD cp quay.io/jetstack/cert-manager-controller:v1.15.2 $IMAGE_REGISTRY/jetstack/cert-manager-controller:v1.15.2
$CMD cp quay.io/jetstack/cert-manager-webhook:v1.15.2 $IMAGE_REGISTRY/jetstack/cert-manager-webhook:v1.15.2
$CMD cp quay.io/prometheus-operator/prometheus-config-reloader:v0.75.2 $IMAGE_REGISTRY/prometheus-operator/prometheus-config-reloader:v0.75.2
$CMD cp quay.io/prometheus-operator/prometheus-operator:v0.75.2 $IMAGE_REGISTRY/prometheus-operator/prometheus-operator:v0.75.2
$CMD cp quay.io/prometheus/alertmanager:v0.27.0 $IMAGE_REGISTRY/prometheus/alertmanager:v0.27.0
$CMD cp quay.io/prometheus/node-exporter:v1.8.2 $IMAGE_REGISTRY/prometheus/node-exporter:v1.8.2
$CMD cp quay.io/prometheus/prometheus:v2.54.0 $IMAGE_REGISTRY/prometheus/prometheus:v2.54.0
$CMD cp rabbitmq:3.12.1-management $IMAGE_REGISTRY/rabbitmq:3.12.1-management
$CMD cp rancher/kine:v0.11.4 $IMAGE_REGISTRY/rancher/kine:v0.11.4
$CMD cp registry.k8s.io/autoscaling/cluster-autoscaler:v1.27.1 $IMAGE_REGISTRY/autoscaling/cluster-autoscaler:v1.27.1
$CMD cp registry.k8s.io/csi-secrets-store/driver:v1.4.1 $IMAGE_REGISTRY/csi-secrets-store/driver:v1.4.1
$CMD cp registry.k8s.io/ingress-nginx/controller:v1.11.1 $IMAGE_REGISTRY/ingress-nginx/controller:v1.11.1
$CMD cp registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.13.0 $IMAGE_REGISTRY/kube-state-metrics/kube-state-metrics:v2.13.0
$CMD cp registry.k8s.io/prometheus-adapter/prometheus-adapter:v0.11.2 $IMAGE_REGISTRY/prometheus-adapter/prometheus-adapter:v0.11.2
$CMD cp registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.10.0 $IMAGE_REGISTRY/sig-storage/csi-node-driver-registrar:v2.10.0
$CMD cp registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.11.1 $IMAGE_REGISTRY/sig-storage/csi-node-driver-registrar:v2.11.1
$CMD cp registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.8.0 $IMAGE_REGISTRY/sig-storage/csi-node-driver-registrar:v2.8.0
$CMD cp registry.k8s.io/sig-storage/csi-provisioner:v4.0.0 $IMAGE_REGISTRY/sig-storage/csi-provisioner:v4.0.0
$CMD cp registry.k8s.io/sig-storage/csi-snapshotter:v6.3.3 $IMAGE_REGISTRY/sig-storage/csi-snapshotter:v6.3.3
$CMD cp registry.k8s.io/sig-storage/livenessprobe:v2.10.0 $IMAGE_REGISTRY/sig-storage/livenessprobe:v2.10.0
$CMD cp registry.k8s.io/sig-storage/livenessprobe:v2.12.0 $IMAGE_REGISTRY/sig-storage/livenessprobe:v2.12.0
$CMD cp registry.k8s.io/sig-storage/livenessprobe:v2.13.1 $IMAGE_REGISTRY/sig-storage/livenessprobe:v2.13.1
$CMD cp registry.k8s.io/sig-storage/nfsplugin:v4.7.0 $IMAGE_REGISTRY/sig-storage/nfsplugin:v4.7.0
$CMD cp registry.k8s.io/sig-storage/snapshot-controller:v8.0.1 $IMAGE_REGISTRY/sig-storage/snapshot-controller:v8.0.1
$CMD cp registry.k8s.io/sig-storage/snapshot-validation-webhook:v8.0.1 $IMAGE_REGISTRY/sig-storage/snapshot-validation-webhook:v8.0.1
