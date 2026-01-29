#!/usr/bin/env bash

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

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/concurrency_utils.sh"

if [ -z "${IMAGE_REGISTRY:-}" ]; then
    echo "IMAGE_REGISTRY is not set"
    exit 1
fi

TARBALL=${1:-}
if [ -z "$TARBALL" ] || [ ! -f "$TARBALL" ]; then
    echo "Usage: $0 <images.tar.gz>"
    echo "Error: Tarball not provided or does not exist"
    exit 1
fi

echo "Extracting $TARBALL..."
tar -zxf "$TARBALL"

CMD="./images/crane"

import_image() {
    local tarfile="$1" target="$2"
    run_async "$target" "$CMD" push --allow-nondistributable-artifacts --insecure "images/${tarfile}.tar" "$IMAGE_REGISTRY/${target}"
}

import_chart() {
    local tarfile="$1" target="$2"
    run_async "$target" bash -c "
        tar -C images -xf 'images/${tarfile}.tar' &&
        '$CMD' push --allow-nondistributable-artifacts --insecure 'images/$tarfile' '$IMAGE_REGISTRY/${target}' &&
        rm -rf 'images/$tarfile'
    "
}

# Note: For imports, we don't need a progress reporter since
# the operation is pushing to registry, not creating local files

# ========================
# Helm Charts (OCI format)
# ========================

import_chart appscode-charts-ace-installer-v2026.1.15 appscode-charts/ace-installer:v2026.1.15
import_chart appscode-charts-ace-v2026.1.15 appscode-charts/ace:v2026.1.15
import_chart appscode-charts-aceshifter-v2026.1.15 appscode-charts/aceshifter:v2026.1.15
import_chart appscode-charts-appscode-otel-stack-v2025.2.28 appscode-charts/appscode-otel-stack:v2025.2.28
import_chart appscode-charts-autoscalingkubedbcom-cassandraautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-cassandraautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-clickhouseautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-clickhouseautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-druidautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-druidautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-elasticsearchautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-elasticsearchautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-etcdautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-etcdautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-ferretdbautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-ferretdbautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-kafkaautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-kafkaautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-mariadbautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-mariadbautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-memcachedautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-memcachedautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-mongodbautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-mongodbautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-mssqlserverautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-mssqlserverautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-mysqlautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-mysqlautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-perconaxtradbautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-perconaxtradbautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-pgbouncerautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-pgbouncerautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-pgpoolautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-pgpoolautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-postgresautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-postgresautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-proxysqlautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-proxysqlautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-rabbitmqautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-rabbitmqautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-redisautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-redisautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-redissentinelautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-redissentinelautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-singlestoreautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-singlestoreautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-solrautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-solrautoscaler-editor:v0.29.0
import_chart appscode-charts-autoscalingkubedbcom-zookeeperautoscaler-editor-v0.29.0 appscode-charts/autoscalingkubedbcom-zookeeperautoscaler-editor:v0.29.0
import_chart appscode-charts-aws-credential-manager-v2025.4.30 appscode-charts/aws-credential-manager:v2025.4.30
import_chart appscode-charts-aws-ebs-csi-driver-2.23.0 appscode-charts/aws-ebs-csi-driver:2.23.0
import_chart appscode-charts-aws-load-balancer-controller-1.11.0 appscode-charts/aws-load-balancer-controller:1.11.0
import_chart appscode-charts-capa-vpc-peering-operator-v2023.12.11 appscode-charts/capa-vpc-peering-operator:v2023.12.11
import_chart appscode-charts-capi-catalog-v2024.10.24 appscode-charts/capi-catalog:v2024.10.24
import_chart appscode-charts-capi-ops-manager-v2024.8.14 appscode-charts/capi-ops-manager:v2024.8.14
import_chart appscode-charts-catalog-manager-v2026.1.15 appscode-charts/catalog-manager:v2026.1.15
import_chart appscode-charts-cert-manager-csi-driver-cacerts-v2026.1.15 appscode-charts/cert-manager-csi-driver-cacerts:v2026.1.15
import_chart appscode-charts-cert-manager-v1.19.2 appscode-charts/cert-manager:v1.19.2
import_chart appscode-charts-chartsxhelmdev-chartpreset-editor-v0.29.0 appscode-charts/chartsxhelmdev-chartpreset-editor:v0.29.0
import_chart appscode-charts-chartsxhelmdev-clusterchartpreset-editor-options-v0.29.0 appscode-charts/chartsxhelmdev-clusterchartpreset-editor-options:v0.29.0
import_chart appscode-charts-chartsxhelmdev-clusterchartpreset-editor-v0.29.0 appscode-charts/chartsxhelmdev-clusterchartpreset-editor:v0.29.0
import_chart appscode-charts-cluster-auth-manager-v2025.5.16 appscode-charts/cluster-auth-manager:v2025.5.16
import_chart appscode-charts-cluster-autoscaler-9.29.0 appscode-charts/cluster-autoscaler:9.29.0
import_chart appscode-charts-cluster-gateway-manager-v2025.4.30 appscode-charts/cluster-gateway-manager:v2025.4.30
import_chart appscode-charts-cluster-manager-hub-v2025.7.31 appscode-charts/cluster-manager-hub:v2025.7.31
import_chart appscode-charts-cluster-manager-spoke-v2025.10.17 appscode-charts/cluster-manager-spoke:v2025.10.17
import_chart appscode-charts-cluster-presets-v2026.1.15 appscode-charts/cluster-presets:v2026.1.15
import_chart appscode-charts-cluster-profile-manager-v2025.5.16 appscode-charts/cluster-profile-manager:v2025.5.16
import_chart appscode-charts-cluster-proxy-manager-v2025.4.30 appscode-charts/cluster-proxy-manager:v2025.4.30
import_chart appscode-charts-config-syncer-v0.15.4 appscode-charts/config-syncer:v0.15.4
import_chart appscode-charts-corekubestashcom-backupbatch-editor-v0.29.0 appscode-charts/corekubestashcom-backupbatch-editor:v0.29.0
import_chart appscode-charts-corekubestashcom-backupblueprint-editor-v0.29.0 appscode-charts/corekubestashcom-backupblueprint-editor:v0.29.0
import_chart appscode-charts-corekubestashcom-backupconfiguration-editor-options-v0.29.0 appscode-charts/corekubestashcom-backupconfiguration-editor-options:v0.29.0
import_chart appscode-charts-corekubestashcom-backupconfiguration-editor-v0.29.0 appscode-charts/corekubestashcom-backupconfiguration-editor:v0.29.0
import_chart appscode-charts-corekubestashcom-backupsession-editor-options-v0.29.0 appscode-charts/corekubestashcom-backupsession-editor-options:v0.29.0
import_chart appscode-charts-corekubestashcom-backupsession-editor-v0.29.0 appscode-charts/corekubestashcom-backupsession-editor:v0.29.0
import_chart appscode-charts-corekubestashcom-backupverificationsession-editor-v0.29.0 appscode-charts/corekubestashcom-backupverificationsession-editor:v0.29.0
import_chart appscode-charts-corekubestashcom-backupverifier-editor-v0.29.0 appscode-charts/corekubestashcom-backupverifier-editor:v0.29.0
import_chart appscode-charts-corekubestashcom-hooktemplate-editor-v0.29.0 appscode-charts/corekubestashcom-hooktemplate-editor:v0.29.0
import_chart appscode-charts-corekubestashcom-restoresession-editor-options-v0.29.0 appscode-charts/corekubestashcom-restoresession-editor-options:v0.29.0
import_chart appscode-charts-corekubestashcom-restoresession-editor-v0.29.0 appscode-charts/corekubestashcom-restoresession-editor:v0.29.0
import_chart appscode-charts-crossplane-1.14.0 appscode-charts/crossplane:1.14.0
import_chart appscode-charts-csi-driver-nfs-v4.7.0 appscode-charts/csi-driver-nfs:v4.7.0
import_chart appscode-charts-csi-secrets-store-provider-azure-1.5.2 appscode-charts/csi-secrets-store-provider-azure:1.5.2
import_chart appscode-charts-external-dns-operator-v2026.1.15 appscode-charts/external-dns-operator:v2026.1.15
import_chart appscode-charts-external-secrets-0.9.12 appscode-charts/external-secrets:0.9.12
import_chart appscode-charts-falco-ui-server-v2026.1.15 appscode-charts/falco-ui-server:v2026.1.15
import_chart appscode-charts-falco-4.0.0 appscode-charts/falco:4.0.0
import_chart appscode-charts-flux2-2.17.0 appscode-charts/flux2:2.17.0
import_chart appscode-charts-fluxcd-manager-v2025.7.31 appscode-charts/fluxcd-manager:v2025.7.31
import_chart appscode-charts-gatekeeper-grafana-dashboards-v2023.10.1 appscode-charts/gatekeeper-grafana-dashboards:v2023.10.1
import_chart appscode-charts-gatekeeper-library-v2023.10.1 appscode-charts/gatekeeper-library:v2023.10.1
import_chart appscode-charts-gatekeeper-3.13.3 appscode-charts/gatekeeper:3.13.3
import_chart appscode-charts-gateway-api-v2025.3.14 appscode-charts/gateway-api:v2025.3.14
import_chart appscode-charts-grafana-operator-v2026.1.15 appscode-charts/grafana-operator:v2026.1.15
import_chart appscode-charts-hub-cluster-robot-v2024.8.9 appscode-charts/hub-cluster-robot:v2024.8.9
import_chart appscode-charts-inbox-agent-v2024.12.30 appscode-charts/inbox-agent:v2024.12.30
import_chart appscode-charts-inbox-server-v2025.2.28 appscode-charts/inbox-server:v2025.2.28
import_chart appscode-charts-inbox-ui-v2026.1.15 appscode-charts/inbox-ui:v2026.1.15
import_chart appscode-charts-ingress-nginx-4.12.1 appscode-charts/ingress-nginx:4.12.1
import_chart appscode-charts-keda-add-ons-http-0.10.0 appscode-charts/keda-add-ons-http:0.10.0
import_chart appscode-charts-keda-2.17.2 appscode-charts/keda:2.17.2
import_chart appscode-charts-kube-grafana-dashboards-v2023.10.1 appscode-charts/kube-grafana-dashboards:v2023.10.1
import_chart appscode-charts-kube-prometheus-stack-69.2.2 appscode-charts/kube-prometheus-stack:69.2.2
import_chart appscode-charts-kube-ui-server-v2026.1.15 appscode-charts/kube-ui-server:v2026.1.15
import_chart appscode-charts-kubedb-opscenter-v2026.1.19 appscode-charts/kubedb-opscenter:v2026.1.19
import_chart appscode-charts-kubedb-provider-aws-v2024.1.31 appscode-charts/kubedb-provider-aws:v2024.1.31
import_chart appscode-charts-kubedb-provider-azure-v2024.1.31 appscode-charts/kubedb-provider-azure:v2024.1.31
import_chart appscode-charts-kubedb-provider-gcp-v2024.1.31 appscode-charts/kubedb-provider-gcp:v2024.1.31
import_chart appscode-charts-kubedb-ui-presets-v2026.1.15 appscode-charts/kubedb-ui-presets:v2026.1.15
import_chart appscode-charts-kubedb-v2026.1.19 appscode-charts/kubedb:v2026.1.19
import_chart appscode-charts-kubedbcom-cassandra-editor-options-v0.29.0 appscode-charts/kubedbcom-cassandra-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-cassandra-editor-v0.29.0 appscode-charts/kubedbcom-cassandra-editor:v0.29.0
import_chart appscode-charts-kubedbcom-clickhouse-editor-options-v0.29.0 appscode-charts/kubedbcom-clickhouse-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-clickhouse-editor-v0.29.0 appscode-charts/kubedbcom-clickhouse-editor:v0.29.0
import_chart appscode-charts-kubedbcom-druid-editor-options-v0.29.0 appscode-charts/kubedbcom-druid-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-druid-editor-v0.29.0 appscode-charts/kubedbcom-druid-editor:v0.29.0
import_chart appscode-charts-kubedbcom-elasticsearch-editor-options-v0.29.0 appscode-charts/kubedbcom-elasticsearch-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-elasticsearch-editor-v0.29.0 appscode-charts/kubedbcom-elasticsearch-editor:v0.29.0
import_chart appscode-charts-kubedbcom-etcd-editor-v0.29.0 appscode-charts/kubedbcom-etcd-editor:v0.29.0
import_chart appscode-charts-kubedbcom-ferretdb-editor-options-v0.29.0 appscode-charts/kubedbcom-ferretdb-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-ferretdb-editor-v0.29.0 appscode-charts/kubedbcom-ferretdb-editor:v0.29.0
import_chart appscode-charts-kubedbcom-hazelcast-editor-options-v0.29.0 appscode-charts/kubedbcom-hazelcast-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-hazelcast-editor-v0.29.0 appscode-charts/kubedbcom-hazelcast-editor:v0.29.0
import_chart appscode-charts-kubedbcom-ignite-editor-options-v0.29.0 appscode-charts/kubedbcom-ignite-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-ignite-editor-v0.29.0 appscode-charts/kubedbcom-ignite-editor:v0.29.0
import_chart appscode-charts-kubedbcom-kafka-editor-options-v0.29.0 appscode-charts/kubedbcom-kafka-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-kafka-editor-v0.29.0 appscode-charts/kubedbcom-kafka-editor:v0.29.0
import_chart appscode-charts-kubedbcom-mariadb-editor-options-v0.29.0 appscode-charts/kubedbcom-mariadb-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-mariadb-editor-v0.29.0 appscode-charts/kubedbcom-mariadb-editor:v0.29.0
import_chart appscode-charts-kubedbcom-memcached-editor-options-v0.29.0 appscode-charts/kubedbcom-memcached-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-memcached-editor-v0.29.0 appscode-charts/kubedbcom-memcached-editor:v0.29.0
import_chart appscode-charts-kubedbcom-mongodb-editor-options-v0.29.0 appscode-charts/kubedbcom-mongodb-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-mongodb-editor-v0.29.0 appscode-charts/kubedbcom-mongodb-editor:v0.29.0
import_chart appscode-charts-kubedbcom-mssqlserver-editor-options-v0.29.0 appscode-charts/kubedbcom-mssqlserver-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-mssqlserver-editor-v0.29.0 appscode-charts/kubedbcom-mssqlserver-editor:v0.29.0
import_chart appscode-charts-kubedbcom-mysql-editor-options-v0.29.0 appscode-charts/kubedbcom-mysql-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-mysql-editor-v0.29.0 appscode-charts/kubedbcom-mysql-editor:v0.29.0
import_chart appscode-charts-kubedbcom-oracle-editor-options-v0.29.0 appscode-charts/kubedbcom-oracle-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-oracle-editor-v0.29.0 appscode-charts/kubedbcom-oracle-editor:v0.29.0
import_chart appscode-charts-kubedbcom-perconaxtradb-editor-options-v0.29.0 appscode-charts/kubedbcom-perconaxtradb-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-perconaxtradb-editor-v0.29.0 appscode-charts/kubedbcom-perconaxtradb-editor:v0.29.0
import_chart appscode-charts-kubedbcom-pgbouncer-editor-options-v0.29.0 appscode-charts/kubedbcom-pgbouncer-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-pgbouncer-editor-v0.29.0 appscode-charts/kubedbcom-pgbouncer-editor:v0.29.0
import_chart appscode-charts-kubedbcom-pgpool-editor-options-v0.29.0 appscode-charts/kubedbcom-pgpool-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-pgpool-editor-v0.29.0 appscode-charts/kubedbcom-pgpool-editor:v0.29.0
import_chart appscode-charts-kubedbcom-postgres-editor-options-v0.29.0 appscode-charts/kubedbcom-postgres-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-postgres-editor-v0.29.0 appscode-charts/kubedbcom-postgres-editor:v0.29.0
import_chart appscode-charts-kubedbcom-proxysql-editor-options-v0.29.0 appscode-charts/kubedbcom-proxysql-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-proxysql-editor-v0.29.0 appscode-charts/kubedbcom-proxysql-editor:v0.29.0
import_chart appscode-charts-kubedbcom-rabbitmq-editor-options-v0.29.0 appscode-charts/kubedbcom-rabbitmq-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-rabbitmq-editor-v0.29.0 appscode-charts/kubedbcom-rabbitmq-editor:v0.29.0
import_chart appscode-charts-kubedbcom-redis-editor-options-v0.29.0 appscode-charts/kubedbcom-redis-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-redis-editor-v0.29.0 appscode-charts/kubedbcom-redis-editor:v0.29.0
import_chart appscode-charts-kubedbcom-redissentinel-editor-v0.29.0 appscode-charts/kubedbcom-redissentinel-editor:v0.29.0
import_chart appscode-charts-kubedbcom-singlestore-editor-options-v0.29.0 appscode-charts/kubedbcom-singlestore-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-singlestore-editor-v0.29.0 appscode-charts/kubedbcom-singlestore-editor:v0.29.0
import_chart appscode-charts-kubedbcom-solr-editor-options-v0.29.0 appscode-charts/kubedbcom-solr-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-solr-editor-v0.29.0 appscode-charts/kubedbcom-solr-editor:v0.29.0
import_chart appscode-charts-kubedbcom-zookeeper-editor-options-v0.29.0 appscode-charts/kubedbcom-zookeeper-editor-options:v0.29.0
import_chart appscode-charts-kubedbcom-zookeeper-editor-v0.29.0 appscode-charts/kubedbcom-zookeeper-editor:v0.29.0
import_chart appscode-charts-kubestash-v2026.1.19 appscode-charts/kubestash:v2026.1.19
import_chart appscode-charts-kubevault-opscenter-v2025.11.21 appscode-charts/kubevault-opscenter:v2025.11.21
import_chart appscode-charts-kubevault-v2025.11.21 appscode-charts/kubevault:v2025.11.21
import_chart appscode-charts-kyverno-policies-3.2.5 appscode-charts/kyverno-policies:3.2.5
import_chart appscode-charts-kyverno-3.2.6 appscode-charts/kyverno:3.2.6
import_chart appscode-charts-license-proxyserver-manager-v2026.1.15 appscode-charts/license-proxyserver-manager:v2026.1.15
import_chart appscode-charts-license-proxyserver-v2026.1.15 appscode-charts/license-proxyserver:v2026.1.15
import_chart appscode-charts-longhorn-1.7.2 appscode-charts/longhorn:1.7.2
import_chart appscode-charts-managed-serviceaccount-manager-v2025.5.16 appscode-charts/managed-serviceaccount-manager:v2025.5.16
import_chart appscode-charts-metrics-server-3.11.0 appscode-charts/metrics-server:3.11.0
import_chart appscode-charts-monitoring-operator-v2026.1.15 appscode-charts/monitoring-operator:v2026.1.15
import_chart appscode-charts-multicluster-controlplane-v2025.4.30 appscode-charts/multicluster-controlplane:v2025.4.30
import_chart appscode-charts-multicluster-ingress-reader-v2024.7.10 appscode-charts/multicluster-ingress-reader:v2024.7.10
import_chart appscode-charts-opencost-grafana-dashboards-v2023.10.1 appscode-charts/opencost-grafana-dashboards:v2023.10.1
import_chart appscode-charts-opencost-1.18.1 appscode-charts/opencost:1.18.1
import_chart appscode-charts-operator-shard-manager-v2026.1.15 appscode-charts/operator-shard-manager:v2026.1.15
import_chart appscode-charts-opscenter-features-v2026.1.15 appscode-charts/opscenter-features:v2026.1.15
import_chart appscode-charts-opskubedbcom-cassandraopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-cassandraopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-clickhouseopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-clickhouseopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-druidopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-druidopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-elasticsearchopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-elasticsearchopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-etcdopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-etcdopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-ferretdbopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-ferretdbopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-hazelcastopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-hazelcastopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-igniteopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-igniteopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-kafkaopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-kafkaopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-mariadbopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-mariadbopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-memcachedopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-memcachedopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-mongodbopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-mongodbopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-mssqlserveropsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-mssqlserveropsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-mysqlopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-mysqlopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-oracleopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-oracleopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-perconaxtradbopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-perconaxtradbopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-pgbounceropsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-pgbounceropsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-pgpoolopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-pgpoolopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-postgresopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-postgresopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-proxysqlopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-proxysqlopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-rabbitmqopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-rabbitmqopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-redisopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-redisopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-redissentinelopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-redissentinelopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-singlestoreopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-singlestoreopsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-solropsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-solropsrequest-editor:v0.29.0
import_chart appscode-charts-opskubedbcom-zookeeperopsrequest-editor-v0.29.0 appscode-charts/opskubedbcom-zookeeperopsrequest-editor:v0.29.0
import_chart appscode-charts-panopticon-v2026.1.15 appscode-charts/panopticon:v2026.1.15
import_chart appscode-charts-prepare-cluster-v2023.12.21 appscode-charts/prepare-cluster:v2023.12.21
import_chart appscode-charts-prometheus-adapter-4.9.0 appscode-charts/prometheus-adapter:4.9.0
import_chart appscode-charts-reloader-1.0.79 appscode-charts/reloader:1.0.79
import_chart appscode-charts-scanner-v2026.1.15 appscode-charts/scanner:v2026.1.15
import_chart appscode-charts-sealed-secrets-2.14.2 appscode-charts/sealed-secrets:2.14.2
import_chart appscode-charts-secrets-store-csi-driver-provider-aws-0.3.6 appscode-charts/secrets-store-csi-driver-provider-aws:0.3.6
import_chart appscode-charts-secrets-store-csi-driver-provider-gcp-0.1.0 appscode-charts/secrets-store-csi-driver-provider-gcp:0.1.0
import_chart appscode-charts-secrets-store-csi-driver-provider-virtual-secrets-v2025.3.14 appscode-charts/secrets-store-csi-driver-provider-virtual-secrets:v2025.3.14
import_chart appscode-charts-secrets-store-csi-driver-1.4.1 appscode-charts/secrets-store-csi-driver:1.4.1
import_chart appscode-charts-service-backend-v2026.1.15 appscode-charts/service-backend:v2026.1.15
import_chart appscode-charts-service-gateway-presets-v2026.1.15 appscode-charts/service-gateway-presets:v2026.1.15
import_chart appscode-charts-service-gateway-v2026.1.15 appscode-charts/service-gateway:v2026.1.15
import_chart appscode-charts-service-provider-v2026.1.15 appscode-charts/service-provider:v2026.1.15
import_chart appscode-charts-sidekick-v2026.1.15 appscode-charts/sidekick:v2026.1.15
import_chart appscode-charts-snapshot-controller-3.0.6 appscode-charts/snapshot-controller:3.0.6
import_chart appscode-charts-spoke-cluster-addons-v2024.7.10 appscode-charts/spoke-cluster-addons:v2024.7.10
import_chart appscode-charts-stash-opscenter-v2025.7.31 appscode-charts/stash-opscenter:v2025.7.31
import_chart appscode-charts-stash-presets-v2026.1.15 appscode-charts/stash-presets:v2026.1.15
import_chart appscode-charts-stash-v2025.7.31 appscode-charts/stash:v2025.7.31
import_chart appscode-charts-storagekubestashcom-backupstorage-editor-options-v0.29.0 appscode-charts/storagekubestashcom-backupstorage-editor-options:v0.29.0
import_chart appscode-charts-storagekubestashcom-backupstorage-editor-v0.29.0 appscode-charts/storagekubestashcom-backupstorage-editor:v0.29.0
import_chart appscode-charts-storagekubestashcom-repository-editor-options-v0.29.0 appscode-charts/storagekubestashcom-repository-editor-options:v0.29.0
import_chart appscode-charts-storagekubestashcom-repository-editor-v0.29.0 appscode-charts/storagekubestashcom-repository-editor:v0.29.0
import_chart appscode-charts-storagekubestashcom-retentionpolicy-editor-v0.29.0 appscode-charts/storagekubestashcom-retentionpolicy-editor:v0.29.0
import_chart appscode-charts-storagekubestashcom-snapshot-editor-v0.29.0 appscode-charts/storagekubestashcom-snapshot-editor:v0.29.0
import_chart appscode-charts-supervisor-v2026.1.15 appscode-charts/supervisor:v2026.1.15
import_chart appscode-charts-topolvm-15.0.0 appscode-charts/topolvm:15.0.0
import_chart appscode-charts-uibytebuildersdev-component-alert-v0.12.0 appscode-charts/uibytebuildersdev-component-alert:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-backup-option-v0.12.0 appscode-charts/uibytebuildersdev-component-backup-option:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-backupconfiguration-v0.12.0 appscode-charts/uibytebuildersdev-component-backupconfiguration:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-certificates-v0.12.0 appscode-charts/uibytebuildersdev-component-certificates:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-data-sources-items-v0.12.0 appscode-charts/uibytebuildersdev-component-data-sources-items:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-database-runtime-settings-v0.12.0 appscode-charts/uibytebuildersdev-component-database-runtime-settings:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-env-from-v0.12.0 appscode-charts/uibytebuildersdev-component-env-from:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-env-v0.12.0 appscode-charts/uibytebuildersdev-component-env:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-health-checker-v0.12.0 appscode-charts/uibytebuildersdev-component-health-checker:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-initialization-v0.12.0 appscode-charts/uibytebuildersdev-component-initialization:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-jwtoidc-config-v0.12.0 appscode-charts/uibytebuildersdev-component-jwtoidc-config:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-kubedb-ui-presets-v0.12.0 appscode-charts/uibytebuildersdev-component-kubedb-ui-presets:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-match-expressions-v0.12.0 appscode-charts/uibytebuildersdev-component-match-expressions:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-match-fields-v0.12.0 appscode-charts/uibytebuildersdev-component-match-fields:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-monitoring-option-v0.12.0 appscode-charts/uibytebuildersdev-component-monitoring-option:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-pod-template-v0.12.0 appscode-charts/uibytebuildersdev-component-pod-template:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-repository-create-v0.12.0 appscode-charts/uibytebuildersdev-component-repository-create:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-resources-v0.12.0 appscode-charts/uibytebuildersdev-component-resources:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-runtime-settings-v0.12.0 appscode-charts/uibytebuildersdev-component-runtime-settings:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-se-linux-options-v0.12.0 appscode-charts/uibytebuildersdev-component-se-linux-options:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-selector-v0.12.0 appscode-charts/uibytebuildersdev-component-selector:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-service-templates-v0.12.0 appscode-charts/uibytebuildersdev-component-service-templates:v0.12.0
import_chart appscode-charts-uibytebuildersdev-component-stash-presets-v0.12.0 appscode-charts/uibytebuildersdev-component-stash-presets:v0.12.0
import_chart appscode-charts-uik8sappscodecom-featureset-capi-capa-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-capi-capa-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-capi-core-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-capi-core-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-crossplane-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-crossplane-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-ocm-hub-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-ocm-hub-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-ocm-mc-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-ocm-mc-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-ocm-spoke-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-ocm-spoke-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-backup-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-backup-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-core-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-core-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-cost-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-cost-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-datastore-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-datastore-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-networking-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-networking-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-observability-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-observability-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-policy-management-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-policy-management-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-secret-management-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-secret-management-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-security-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-security-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-storage-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-storage-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-opscenter-tools-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-opscenter-tools-editor:v0.29.0
import_chart appscode-charts-uik8sappscodecom-featureset-saas-core-editor-v0.29.0 appscode-charts/uik8sappscodecom-featureset-saas-core-editor:v0.29.0
import_chart appscode-charts-vault-secrets-operator-0.4.3 appscode-charts/vault-secrets-operator:0.4.3
import_chart appscode-charts-vault-0.27.0 appscode-charts/vault:0.27.0
import_chart appscode-charts-virtual-secrets-server-v2025.3.14 appscode-charts/virtual-secrets-server:v2025.3.14
import_chart appscode-charts-voyager-gateway-v2026.1.15 appscode-charts/voyager-gateway:v2026.1.15
import_chart appscode-charts-voyager-v2025.9.19 appscode-charts/voyager:v2025.9.19

# ========================
# Container Images
# ========================

import_image library-alpine-3.20 alpine:3.20
import_image bitnami-kubectl-latest bitnami/kubectl:latest
import_image bitnami-sealed-secrets-controller-0.25.0 bitnami/sealed-secrets-controller:0.25.0
import_image library-cassandra-4.1.3 cassandra:4.1.3
import_image coredns-coredns-1.11.3 coredns/coredns:1.11.3
import_image falcosecurity-falco-no-driver-0.37.0 falcosecurity/falco-no-driver:0.37.0
import_image falcosecurity-falcoctl-0.7.1 falcosecurity/falcoctl:0.7.1
import_image appscode-images-ingress-nginx-controller-v1.11.1 ghcr.io/appscode-images/ingress-nginx-controller:v1.11.1
import_image appscode-images-nats-2.10.24-alpine ghcr.io/appscode-images/nats:2.10.24-alpine
import_image appscode-images-postgres-16.4-alpine ghcr.io/appscode-images/postgres:16.4-alpine
import_image appscode-images-redis-7.2.4-bookworm ghcr.io/appscode-images/redis:7.2.4-bookworm
import_image appscode-aceshifter-v0.0.2 ghcr.io/appscode/aceshifter:v0.0.2
import_image appscode-b3-v2026.1.15 ghcr.io/appscode/b3:v2026.1.15
import_image appscode-capa-vpc-peering-operator-v0.0.4 ghcr.io/appscode/capa-vpc-peering-operator:v0.0.4
import_image appscode-capi-ops-manager-v0.0.2 ghcr.io/appscode/capi-ops-manager:v0.0.2
import_image appscode-catalog-manager-v0.10.0 ghcr.io/appscode/catalog-manager:v0.10.0
import_image appscode-cluster-presets-v0.0.10 ghcr.io/appscode/cluster-presets:v0.0.10
import_image appscode-cluster-ui-2.0.0 ghcr.io/appscode/cluster-ui:2.0.0
import_image appscode-config-syncer-v0.15.2-ent ghcr.io/appscode/config-syncer:v0.15.2-ent
import_image appscode-csi-driver-cacerts-v0.1.0 ghcr.io/appscode/csi-driver-cacerts:v0.1.0
import_image appscode-external-dns-operator-v0.0.8 ghcr.io/appscode/external-dns-operator:v0.0.8
import_image appscode-falco-ui-server-v0.0.4 ghcr.io/appscode/falco-ui-server:v0.0.4
import_image appscode-fileserver-v0.0.1 ghcr.io/appscode/fileserver:v0.0.1
import_image appscode-flux-cli-v2.3.0 ghcr.io/appscode/flux-cli:v2.3.0
import_image appscode-grafana-tools-v0.3.0 ghcr.io/appscode/grafana-tools:v0.3.0
import_image appscode-grafana-v2025.2.3 ghcr.io/appscode/grafana:v2025.2.3
import_image appscode-inbox-agent-v0.0.2 ghcr.io/appscode/inbox-agent:v0.0.2
import_image appscode-inbox-server-postgres-latest ghcr.io/appscode/inbox-server:postgres-latest
import_image appscode-inbox-ui-0.0.5 ghcr.io/appscode/inbox-ui:0.0.5
import_image appscode-k8s-wait-for-v2.0 ghcr.io/appscode/k8s-wait-for:v2.0
import_image appscode-kube-rbac-proxy-v0.11.0 ghcr.io/appscode/kube-rbac-proxy:v0.11.0
import_image appscode-kube-rbac-proxy-v0.13.0 ghcr.io/appscode/kube-rbac-proxy:v0.13.0
import_image appscode-kube-rbac-proxy-v0.15.0 ghcr.io/appscode/kube-rbac-proxy:v0.15.0
import_image appscode-kube-rbac-proxy-v0.18.2 ghcr.io/appscode/kube-rbac-proxy:v0.18.2
import_image appscode-kube-ui-server-v0.0.50 ghcr.io/appscode/kube-ui-server:v0.0.50
import_image appscode-kubectl-nonroot-1.34 ghcr.io/appscode/kubectl-nonroot:1.34
import_image appscode-kubedb-ui-2.0.0 ghcr.io/appscode/kubedb-ui:2.0.0
import_image appscode-license-proxyserver-v0.0.26 ghcr.io/appscode/license-proxyserver:v0.0.26
import_image appscode-maxmind-geoip-city-mmdb-latest ghcr.io/appscode/maxmind-geoip:city-mmdb-latest
import_image appscode-openfga-v1.9.5 ghcr.io/appscode/openfga:v1.9.5
import_image appscode-operator-shard-manager-v0.0.1 ghcr.io/appscode/operator-shard-manager:v0.0.1
import_image appscode-panopticon-v0.0.16 ghcr.io/appscode/panopticon:v0.0.16
import_image appscode-petset-v0.0.16 ghcr.io/appscode/petset:v0.0.16
import_image appscode-platform-ui-2.0.0 ghcr.io/appscode/platform-ui:2.0.0
import_image appscode-prom-authproxy-v0.0.1 ghcr.io/appscode/prom-authproxy:v0.0.1
import_image appscode-reloader-v1.0.79 ghcr.io/appscode/reloader:v1.0.79
import_image appscode-s3proxy-sha-a82ca68 ghcr.io/appscode/s3proxy:sha-a82ca68
import_image appscode-scanner-v0.0.19 ghcr.io/appscode/scanner:v0.0.19
import_image appscode-service-provider-v0.0.2 ghcr.io/appscode/service-provider:v0.0.2
import_image appscode-sidekick-v0.0.13 ghcr.io/appscode/sidekick:v0.0.13
import_image appscode-supervisor-v0.0.7 ghcr.io/appscode/supervisor:v0.0.7
import_image appscode-trickster-v2.0.0-beta3 ghcr.io/appscode/trickster:v2.0.0-beta3
import_image appscode-vcluster-plugin-ace-v0.0.3 ghcr.io/appscode/vcluster-plugin-ace:v0.0.3
import_image external-secrets-external-secrets-v0.9.12 ghcr.io/external-secrets/external-secrets:v0.9.12
import_image fluxcd-helm-controller-v1.0.1 ghcr.io/fluxcd/helm-controller:v1.0.1
import_image fluxcd-kustomize-controller-v1.3.0 ghcr.io/fluxcd/kustomize-controller:v1.3.0
import_image fluxcd-notification-controller-v1.3.0 ghcr.io/fluxcd/notification-controller:v1.3.0
import_image fluxcd-source-controller-v1.3.0 ghcr.io/fluxcd/source-controller:v1.3.0
import_image kedacore-http-add-on-interceptor-0.8.0 ghcr.io/kedacore/http-add-on-interceptor:0.8.0
import_image kedacore-http-add-on-operator-0.8.0 ghcr.io/kedacore/http-add-on-operator:0.8.0
import_image kedacore-http-add-on-scaler-0.8.0 ghcr.io/kedacore/http-add-on-scaler:0.8.0
import_image kedacore-keda-admission-webhooks-2.15.1 ghcr.io/kedacore/keda-admission-webhooks:2.15.1
import_image kedacore-keda-metrics-apiserver-2.15.1 ghcr.io/kedacore/keda-metrics-apiserver:2.15.1
import_image kedacore-keda-2.15.1 ghcr.io/kedacore/keda:2.15.1
import_image kluster-manager-addon-manager-v0.15.2 ghcr.io/kluster-manager/addon-manager:v0.15.2
import_image kluster-manager-cluster-auth-v0.4.1 ghcr.io/kluster-manager/cluster-auth:v0.4.1
import_image kluster-manager-cluster-gateway-manager-v1.11.0 ghcr.io/kluster-manager/cluster-gateway-manager:v1.11.0
import_image kluster-manager-cluster-gateway-v1.11.0 ghcr.io/kluster-manager/cluster-gateway:v1.11.0
import_image kluster-manager-cluster-profile-v0.10.0 ghcr.io/kluster-manager/cluster-profile:v0.10.0
import_image kluster-manager-cluster-proxy-v0.7.0 ghcr.io/kluster-manager/cluster-proxy:v0.7.0
import_image kluster-manager-clusteradm-v1.0.0 ghcr.io/kluster-manager/clusteradm:v1.0.0
import_image kluster-manager-fluxcd-addon-v0.0.9 ghcr.io/kluster-manager/fluxcd-addon:v0.0.9
import_image kluster-manager-managed-serviceaccount-v0.8.1 ghcr.io/kluster-manager/managed-serviceaccount:v0.8.1
import_image kluster-manager-placement-v0.15.2 ghcr.io/kluster-manager/placement:v0.15.2
import_image kluster-manager-registration-operator-v0.15.2 ghcr.io/kluster-manager/registration-operator:v0.15.2
import_image kluster-manager-registration-v0.15.2 ghcr.io/kluster-manager/registration:v0.15.2
import_image kluster-manager-work-v0.15.2 ghcr.io/kluster-manager/work:v0.15.2
import_image kubedb-kubedb-autoscaler-v0.45.0 ghcr.io/kubedb/kubedb-autoscaler:v0.45.0
import_image kubedb-kubedb-crd-manager-v0.15.0 ghcr.io/kubedb/kubedb-crd-manager:v0.15.0
import_image kubedb-kubedb-ops-manager-v0.47.0 ghcr.io/kubedb/kubedb-ops-manager:v0.47.0
import_image kubedb-kubedb-provisioner-v0.60.0 ghcr.io/kubedb/kubedb-provisioner:v0.60.0
import_image kubedb-kubedb-schema-manager-v0.36.0 ghcr.io/kubedb/kubedb-schema-manager:v0.36.0
import_image kubedb-kubedb-ui-server-v0.36.0 ghcr.io/kubedb/kubedb-ui-server:v0.36.0
import_image kubedb-kubedb-webhook-server-v0.36.0 ghcr.io/kubedb/kubedb-webhook-server:v0.36.0
import_image kubedb-pg-coordinator-v0.44.0 ghcr.io/kubedb/pg-coordinator:v0.44.0
import_image kubedb-postgres-archiver-v0.21.0_16.1-alpine ghcr.io/kubedb/postgres-archiver:v0.21.0_16.1-alpine
import_image kubedb-postgres-init-0.18.0 ghcr.io/kubedb/postgres-init:0.18.0
import_image kubedb-postgres-restic-plugin-v0.23.0_16.1 ghcr.io/kubedb/postgres-restic-plugin:v0.23.0_16.1
import_image kubedb-redis-coordinator-v0.39.0 ghcr.io/kubedb/redis-coordinator:v0.39.0
import_image kubedb-redis-init-0.12.1 ghcr.io/kubedb/redis-init:0.12.1
import_image kubedb-redis-restic-plugin-v0.23.0 ghcr.io/kubedb/redis-restic-plugin:v0.23.0
import_image kubedb-redis_exporter-1.66.0 ghcr.io/kubedb/redis_exporter:1.66.0
import_image kubedb-vcluster-plugin-kubedb-v0.0.1 ghcr.io/kubedb/vcluster-plugin-kubedb:v0.0.1
import_image kubestash-kubedump-v0.22.0 ghcr.io/kubestash/kubedump:v0.22.0
import_image kubestash-kubestash-v0.23.0 ghcr.io/kubestash/kubestash:v0.23.0
import_image kubevault-vault-operator-v0.19.0 ghcr.io/kubevault/vault-operator:v0.19.0
import_image kyverno-background-controller-v1.12.5 ghcr.io/kyverno/background-controller:v1.12.5
import_image kyverno-cleanup-controller-v1.12.5 ghcr.io/kyverno/cleanup-controller:v1.12.5
import_image kyverno-kyverno-v1.12.5 ghcr.io/kyverno/kyverno:v1.12.5
import_image kyverno-kyvernopre-v1.12.5 ghcr.io/kyverno/kyvernopre:v1.12.5
import_image kyverno-reports-controller-v1.12.5 ghcr.io/kyverno/reports-controller:v1.12.5
import_image loft-sh-vcluster-oss-0.22.4 ghcr.io/loft-sh/vcluster-oss:0.22.4
import_image voyagermesh-echoserver-v20221109 ghcr.io/voyagermesh/echoserver:v20221109
import_image voyagermesh-envoy-v1.36.4-ac ghcr.io/voyagermesh/envoy:v1.36.4-ac
import_image voyagermesh-gateway-converter-v0.0.1 ghcr.io/voyagermesh/gateway-converter:v0.0.1
import_image voyagermesh-gateway-v1.6.2 ghcr.io/voyagermesh/gateway:v1.6.2
import_image hashicorp-vault-csi-provider-1.4.1 hashicorp/vault-csi-provider:1.4.1
import_image hashicorp-vault-secrets-operator-0.4.3 hashicorp/vault-secrets-operator:0.4.3
import_image hashicorp-vault-1.15.2 hashicorp/vault:1.15.2
import_image natsio-nats-boot-config-0.16.1 natsio/nats-boot-config:0.16.1
import_image natsio-nats-server-config-reloader-0.16.1 natsio/nats-server-config-reloader:0.16.1
import_image natsio-prometheus-nats-exporter-0.16.0 natsio/prometheus-nats-exporter:0.16.0
import_image openpolicyagent-gatekeeper-v3.13.3 openpolicyagent/gatekeeper:v3.13.3
import_image opensearchproject-opensearch-2.1.0 opensearchproject/opensearch:2.1.0
import_image prometheuscommunity-postgres-exporter-v0.18.1 prometheuscommunity/postgres-exporter:v0.18.1
import_image jetstack-cert-manager-acmesolver-v1.15.4 quay.io/jetstack/cert-manager-acmesolver:v1.15.4
import_image jetstack-cert-manager-cainjector-v1.15.4 quay.io/jetstack/cert-manager-cainjector:v1.15.4
import_image jetstack-cert-manager-controller-v1.15.4 quay.io/jetstack/cert-manager-controller:v1.15.4
import_image jetstack-cert-manager-startupapicheck-v1.15.4 quay.io/jetstack/cert-manager-startupapicheck:v1.15.4
import_image jetstack-cert-manager-webhook-v1.15.4 quay.io/jetstack/cert-manager-webhook:v1.15.4
import_image prometheus-operator-prometheus-config-reloader-v0.75.2 quay.io/prometheus-operator/prometheus-config-reloader:v0.75.2
import_image prometheus-operator-prometheus-operator-v0.75.2 quay.io/prometheus-operator/prometheus-operator:v0.75.2
import_image prometheus-alertmanager-v0.27.0 quay.io/prometheus/alertmanager:v0.27.0
import_image prometheus-node-exporter-v1.8.2 quay.io/prometheus/node-exporter:v1.8.2
import_image prometheus-prometheus-v2.54.0 quay.io/prometheus/prometheus:v2.54.0
import_image thanos-thanos-v0.32.5 quay.io/thanos/thanos:v0.32.5
import_image library-rabbitmq-3.12.1-management rabbitmq:3.12.1-management
import_image rancher-kine-v0.11.4 rancher/kine:v0.11.4
import_image autoscaling-cluster-autoscaler-v1.27.1 registry.k8s.io/autoscaling/cluster-autoscaler:v1.27.1
import_image csi-secrets-store-driver-v1.4.1 registry.k8s.io/csi-secrets-store/driver:v1.4.1
import_image ingress-nginx-kube-webhook-certgen-v20221220-controller-v1.5.1-58-g787ea74b6 registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20221220-controller-v1.5.1-58-g787ea74b6
import_image kube-apiserver-v1.34.0 registry.k8s.io/kube-apiserver:v1.34.0
import_image kube-controller-manager-v1.34.0 registry.k8s.io/kube-controller-manager:v1.34.0
import_image kube-state-metrics-kube-state-metrics-v2.13.0 registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.13.0
import_image metrics-server-metrics-server-v0.7.2 registry.k8s.io/metrics-server/metrics-server:v0.7.2
import_image prometheus-adapter-prometheus-adapter-v0.11.2 registry.k8s.io/prometheus-adapter/prometheus-adapter:v0.11.2
import_image sig-storage-csi-node-driver-registrar-v2.10.0 registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.10.0
import_image sig-storage-csi-node-driver-registrar-v2.11.1 registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.11.1
import_image sig-storage-csi-node-driver-registrar-v2.8.0 registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.8.0
import_image sig-storage-csi-provisioner-v4.0.0 registry.k8s.io/sig-storage/csi-provisioner:v4.0.0
import_image sig-storage-csi-snapshotter-v6.3.3 registry.k8s.io/sig-storage/csi-snapshotter:v6.3.3
import_image sig-storage-livenessprobe-v2.10.0 registry.k8s.io/sig-storage/livenessprobe:v2.10.0
import_image sig-storage-livenessprobe-v2.12.0 registry.k8s.io/sig-storage/livenessprobe:v2.12.0
import_image sig-storage-livenessprobe-v2.13.1 registry.k8s.io/sig-storage/livenessprobe:v2.13.1
import_image sig-storage-nfsplugin-v4.7.0 registry.k8s.io/sig-storage/nfsplugin:v4.7.0
import_image sig-storage-snapshot-controller-v8.0.1 registry.k8s.io/sig-storage/snapshot-controller:v8.0.1
import_image sig-storage-snapshot-validation-webhook-v8.0.1 registry.k8s.io/sig-storage/snapshot-validation-webhook:v8.0.1

wait_all
