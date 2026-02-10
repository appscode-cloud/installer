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

EXPECTED_COUNT=$(grep -cE '^export_(chart|image) ' "${BASH_SOURCE[0]}")

mkdir -p images

OS=$(uname -o)
if [ "${OS}" = "GNU/Linux" ]; then
    OS=Linux
fi
ARCH=$(uname -m)
if [ "${ARCH}" = "aarch64" ]; then
    ARCH=arm64
fi

echo "Downloading Crane for ${OS}/${ARCH}..."
curl -sL "https://github.com/google/go-containerregistry/releases/latest/download/go-containerregistry_${OS}_${ARCH}.tar.gz" >/tmp/go-containerregistry.tar.gz
tar -zxvf /tmp/go-containerregistry.tar.gz -C /tmp/
mv /tmp/crane images

CMD="./images/crane"

export_image() {
    local ref="$1" output="$2"
    run_async "$ref" "$CMD" pull --allow-nondistributable-artifacts --insecure "$ref" "images/$output"
}

export_chart() {
    local ref="$1" output="$2"
    local name="${output%.tar}"
    run_async "$ref" bash -c "
        '$CMD' pull --allow-nondistributable-artifacts --insecure --format=oci '$ref' 'images/$name' &&
        tar -C images -cf 'images/$output' '$name' &&
        rm -rf 'images/$name'
    "
}

echo "Exporting charts and images to ./images directory..."

# ========================
# Helm Charts (OCI format)
# ========================

export_chart ghcr.io/appscode-charts/ace-installer:v2026.1.15 appscode-charts-ace-installer-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/ace:v2026.1.15 appscode-charts-ace-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/aceshifter:v2026.1.15 appscode-charts-aceshifter-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/appscode-otel-stack:v2025.2.28 appscode-charts-appscode-otel-stack-v2025.2.28.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-cassandraautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-cassandraautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-clickhouseautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-clickhouseautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-druidautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-druidautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-elasticsearchautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-elasticsearchautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-etcdautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-etcdautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-ferretdbautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-ferretdbautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-kafkaautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-kafkaautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-mariadbautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-mariadbautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-memcachedautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-memcachedautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-mongodbautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-mongodbautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-mssqlserverautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-mssqlserverautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-mysqlautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-mysqlautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-perconaxtradbautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-perconaxtradbautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-pgbouncerautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-pgbouncerautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-pgpoolautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-pgpoolautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-postgresautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-postgresautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-proxysqlautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-proxysqlautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-rabbitmqautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-rabbitmqautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-redisautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-redisautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-redissentinelautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-redissentinelautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-singlestoreautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-singlestoreautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-solrautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-solrautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/autoscalingkubedbcom-zookeeperautoscaler-editor:v0.29.0 appscode-charts-autoscalingkubedbcom-zookeeperautoscaler-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/aws-credential-manager:v2025.4.30 appscode-charts-aws-credential-manager-v2025.4.30.tar
export_chart ghcr.io/appscode-charts/aws-ebs-csi-driver:2.23.0 appscode-charts-aws-ebs-csi-driver-2.23.0.tar
export_chart ghcr.io/appscode-charts/aws-load-balancer-controller:1.11.0 appscode-charts-aws-load-balancer-controller-1.11.0.tar
export_chart ghcr.io/appscode-charts/capa-vpc-peering-operator:v2023.12.11 appscode-charts-capa-vpc-peering-operator-v2023.12.11.tar
export_chart ghcr.io/appscode-charts/capi-catalog:v2024.10.24 appscode-charts-capi-catalog-v2024.10.24.tar
export_chart ghcr.io/appscode-charts/capi-ops-manager:v2024.8.14 appscode-charts-capi-ops-manager-v2024.8.14.tar
export_chart ghcr.io/appscode-charts/catalog-manager:v2026.1.15 appscode-charts-catalog-manager-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/cert-manager-csi-driver-cacerts:v2026.1.15 appscode-charts-cert-manager-csi-driver-cacerts-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/cert-manager:v1.19.2 appscode-charts-cert-manager-v1.19.2.tar
export_chart ghcr.io/appscode-charts/chartsxhelmdev-chartpreset-editor:v0.29.0 appscode-charts-chartsxhelmdev-chartpreset-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/chartsxhelmdev-clusterchartpreset-editor-options:v0.29.0 appscode-charts-chartsxhelmdev-clusterchartpreset-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/chartsxhelmdev-clusterchartpreset-editor:v0.29.0 appscode-charts-chartsxhelmdev-clusterchartpreset-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/cluster-auth-manager:v2025.5.16 appscode-charts-cluster-auth-manager-v2025.5.16.tar
export_chart ghcr.io/appscode-charts/cluster-autoscaler:9.29.0 appscode-charts-cluster-autoscaler-9.29.0.tar
export_chart ghcr.io/appscode-charts/cluster-gateway-manager:v2025.4.30 appscode-charts-cluster-gateway-manager-v2025.4.30.tar
export_chart ghcr.io/appscode-charts/cluster-manager-hub:v2025.7.31 appscode-charts-cluster-manager-hub-v2025.7.31.tar
export_chart ghcr.io/appscode-charts/cluster-manager-spoke:v2025.10.17 appscode-charts-cluster-manager-spoke-v2025.10.17.tar
export_chart ghcr.io/appscode-charts/cluster-presets:v2026.1.15 appscode-charts-cluster-presets-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/cluster-profile-manager:v2025.5.16 appscode-charts-cluster-profile-manager-v2025.5.16.tar
export_chart ghcr.io/appscode-charts/cluster-proxy-manager:v2025.4.30 appscode-charts-cluster-proxy-manager-v2025.4.30.tar
export_chart ghcr.io/appscode-charts/config-syncer:v0.15.4 appscode-charts-config-syncer-v0.15.4.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-backupbatch-editor:v0.29.0 appscode-charts-corekubestashcom-backupbatch-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-backupblueprint-editor:v0.29.0 appscode-charts-corekubestashcom-backupblueprint-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-backupconfiguration-editor-options:v0.29.0 appscode-charts-corekubestashcom-backupconfiguration-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-backupconfiguration-editor:v0.29.0 appscode-charts-corekubestashcom-backupconfiguration-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-backupsession-editor-options:v0.29.0 appscode-charts-corekubestashcom-backupsession-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-backupsession-editor:v0.29.0 appscode-charts-corekubestashcom-backupsession-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-backupverificationsession-editor:v0.29.0 appscode-charts-corekubestashcom-backupverificationsession-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-backupverifier-editor:v0.29.0 appscode-charts-corekubestashcom-backupverifier-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-hooktemplate-editor:v0.29.0 appscode-charts-corekubestashcom-hooktemplate-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-restoresession-editor-options:v0.29.0 appscode-charts-corekubestashcom-restoresession-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/corekubestashcom-restoresession-editor:v0.29.0 appscode-charts-corekubestashcom-restoresession-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/crossplane:1.14.0 appscode-charts-crossplane-1.14.0.tar
export_chart ghcr.io/appscode-charts/csi-driver-nfs:v4.7.0 appscode-charts-csi-driver-nfs-v4.7.0.tar
export_chart ghcr.io/appscode-charts/csi-secrets-store-provider-azure:1.5.2 appscode-charts-csi-secrets-store-provider-azure-1.5.2.tar
export_chart ghcr.io/appscode-charts/external-dns-operator:v2026.1.15 appscode-charts-external-dns-operator-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/external-secrets:0.9.12 appscode-charts-external-secrets-0.9.12.tar
export_chart ghcr.io/appscode-charts/falco-ui-server:v2026.1.15 appscode-charts-falco-ui-server-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/falco:4.0.0 appscode-charts-falco-4.0.0.tar
export_chart ghcr.io/appscode-charts/flux2:2.17.0 appscode-charts-flux2-2.17.0.tar
export_chart ghcr.io/appscode-charts/fluxcd-manager:v2025.7.31 appscode-charts-fluxcd-manager-v2025.7.31.tar
export_chart ghcr.io/appscode-charts/gatekeeper-grafana-dashboards:v2023.10.1 appscode-charts-gatekeeper-grafana-dashboards-v2023.10.1.tar
export_chart ghcr.io/appscode-charts/gatekeeper-library:v2023.10.1 appscode-charts-gatekeeper-library-v2023.10.1.tar
export_chart ghcr.io/appscode-charts/gatekeeper:3.13.3 appscode-charts-gatekeeper-3.13.3.tar
export_chart ghcr.io/appscode-charts/gateway-api:v2025.3.14 appscode-charts-gateway-api-v2025.3.14.tar
export_chart ghcr.io/appscode-charts/grafana-operator:v2026.1.15 appscode-charts-grafana-operator-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/hub-cluster-robot:v2024.8.9 appscode-charts-hub-cluster-robot-v2024.8.9.tar
export_chart ghcr.io/appscode-charts/inbox-agent:v2024.12.30 appscode-charts-inbox-agent-v2024.12.30.tar
export_chart ghcr.io/appscode-charts/inbox-server:v2025.2.28 appscode-charts-inbox-server-v2025.2.28.tar
export_chart ghcr.io/appscode-charts/inbox-ui:v2026.1.15 appscode-charts-inbox-ui-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/ingress-nginx:4.12.1 appscode-charts-ingress-nginx-4.12.1.tar
export_chart ghcr.io/appscode-charts/keda-add-ons-http:0.10.0 appscode-charts-keda-add-ons-http-0.10.0.tar
export_chart ghcr.io/appscode-charts/keda:2.17.2 appscode-charts-keda-2.17.2.tar
export_chart ghcr.io/appscode-charts/kube-grafana-dashboards:v2023.10.1 appscode-charts-kube-grafana-dashboards-v2023.10.1.tar
export_chart ghcr.io/appscode-charts/kube-prometheus-stack:69.2.2 appscode-charts-kube-prometheus-stack-69.2.2.tar
export_chart ghcr.io/appscode-charts/kube-ui-server:v2026.1.15 appscode-charts-kube-ui-server-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/kubedb-opscenter:v2026.1.19 appscode-charts-kubedb-opscenter-v2026.1.19.tar
export_chart ghcr.io/appscode-charts/kubedb-provider-aws:v2024.1.31 appscode-charts-kubedb-provider-aws-v2024.1.31.tar
export_chart ghcr.io/appscode-charts/kubedb-provider-azure:v2024.1.31 appscode-charts-kubedb-provider-azure-v2024.1.31.tar
export_chart ghcr.io/appscode-charts/kubedb-provider-gcp:v2024.1.31 appscode-charts-kubedb-provider-gcp-v2024.1.31.tar
export_chart ghcr.io/appscode-charts/kubedb-ui-presets:v2026.1.15 appscode-charts-kubedb-ui-presets-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/kubedb:v2026.1.19 appscode-charts-kubedb-v2026.1.19.tar
export_chart ghcr.io/appscode-charts/kubedbcom-cassandra-editor-options:v0.29.0 appscode-charts-kubedbcom-cassandra-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-cassandra-editor:v0.29.0 appscode-charts-kubedbcom-cassandra-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-clickhouse-editor-options:v0.29.0 appscode-charts-kubedbcom-clickhouse-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-clickhouse-editor:v0.29.0 appscode-charts-kubedbcom-clickhouse-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-druid-editor-options:v0.29.0 appscode-charts-kubedbcom-druid-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-druid-editor:v0.29.0 appscode-charts-kubedbcom-druid-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-elasticsearch-editor-options:v0.29.0 appscode-charts-kubedbcom-elasticsearch-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-elasticsearch-editor:v0.29.0 appscode-charts-kubedbcom-elasticsearch-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-etcd-editor:v0.29.0 appscode-charts-kubedbcom-etcd-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-ferretdb-editor-options:v0.29.0 appscode-charts-kubedbcom-ferretdb-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-ferretdb-editor:v0.29.0 appscode-charts-kubedbcom-ferretdb-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-hazelcast-editor-options:v0.29.0 appscode-charts-kubedbcom-hazelcast-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-hazelcast-editor:v0.29.0 appscode-charts-kubedbcom-hazelcast-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-ignite-editor-options:v0.29.0 appscode-charts-kubedbcom-ignite-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-ignite-editor:v0.29.0 appscode-charts-kubedbcom-ignite-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-kafka-editor-options:v0.29.0 appscode-charts-kubedbcom-kafka-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-kafka-editor:v0.29.0 appscode-charts-kubedbcom-kafka-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-mariadb-editor-options:v0.29.0 appscode-charts-kubedbcom-mariadb-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-mariadb-editor:v0.29.0 appscode-charts-kubedbcom-mariadb-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-memcached-editor-options:v0.29.0 appscode-charts-kubedbcom-memcached-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-memcached-editor:v0.29.0 appscode-charts-kubedbcom-memcached-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-mongodb-editor-options:v0.29.0 appscode-charts-kubedbcom-mongodb-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-mongodb-editor:v0.29.0 appscode-charts-kubedbcom-mongodb-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-mssqlserver-editor-options:v0.29.0 appscode-charts-kubedbcom-mssqlserver-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-mssqlserver-editor:v0.29.0 appscode-charts-kubedbcom-mssqlserver-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-mysql-editor-options:v0.29.0 appscode-charts-kubedbcom-mysql-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-mysql-editor:v0.29.0 appscode-charts-kubedbcom-mysql-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-oracle-editor-options:v0.29.0 appscode-charts-kubedbcom-oracle-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-oracle-editor:v0.29.0 appscode-charts-kubedbcom-oracle-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-perconaxtradb-editor-options:v0.29.0 appscode-charts-kubedbcom-perconaxtradb-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-perconaxtradb-editor:v0.29.0 appscode-charts-kubedbcom-perconaxtradb-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-pgbouncer-editor-options:v0.29.0 appscode-charts-kubedbcom-pgbouncer-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-pgbouncer-editor:v0.29.0 appscode-charts-kubedbcom-pgbouncer-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-pgpool-editor-options:v0.29.0 appscode-charts-kubedbcom-pgpool-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-pgpool-editor:v0.29.0 appscode-charts-kubedbcom-pgpool-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-postgres-editor-options:v0.29.0 appscode-charts-kubedbcom-postgres-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-postgres-editor:v0.29.0 appscode-charts-kubedbcom-postgres-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-proxysql-editor-options:v0.29.0 appscode-charts-kubedbcom-proxysql-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-proxysql-editor:v0.29.0 appscode-charts-kubedbcom-proxysql-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-rabbitmq-editor-options:v0.29.0 appscode-charts-kubedbcom-rabbitmq-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-rabbitmq-editor:v0.29.0 appscode-charts-kubedbcom-rabbitmq-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-redis-editor-options:v0.29.0 appscode-charts-kubedbcom-redis-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-redis-editor:v0.29.0 appscode-charts-kubedbcom-redis-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-redissentinel-editor:v0.29.0 appscode-charts-kubedbcom-redissentinel-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-singlestore-editor-options:v0.29.0 appscode-charts-kubedbcom-singlestore-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-singlestore-editor:v0.29.0 appscode-charts-kubedbcom-singlestore-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-solr-editor-options:v0.29.0 appscode-charts-kubedbcom-solr-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-solr-editor:v0.29.0 appscode-charts-kubedbcom-solr-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-zookeeper-editor-options:v0.29.0 appscode-charts-kubedbcom-zookeeper-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubedbcom-zookeeper-editor:v0.29.0 appscode-charts-kubedbcom-zookeeper-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/kubestash:v2026.1.19 appscode-charts-kubestash-v2026.1.19.tar
export_chart ghcr.io/appscode-charts/kubevault-opscenter:v2025.11.21 appscode-charts-kubevault-opscenter-v2025.11.21.tar
export_chart ghcr.io/appscode-charts/kubevault:v2025.11.21 appscode-charts-kubevault-v2025.11.21.tar
export_chart ghcr.io/appscode-charts/kyverno-policies:3.2.5 appscode-charts-kyverno-policies-3.2.5.tar
export_chart ghcr.io/appscode-charts/kyverno:3.2.6 appscode-charts-kyverno-3.2.6.tar
export_chart ghcr.io/appscode-charts/license-proxyserver-manager:v2026.1.15 appscode-charts-license-proxyserver-manager-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/license-proxyserver:v2026.1.15 appscode-charts-license-proxyserver-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/longhorn:1.7.2 appscode-charts-longhorn-1.7.2.tar
export_chart ghcr.io/appscode-charts/managed-serviceaccount-manager:v2025.5.16 appscode-charts-managed-serviceaccount-manager-v2025.5.16.tar
export_chart ghcr.io/appscode-charts/metrics-server:3.11.0 appscode-charts-metrics-server-3.11.0.tar
export_chart ghcr.io/appscode-charts/monitoring-operator:v2026.1.15 appscode-charts-monitoring-operator-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/multicluster-controlplane:v2025.4.30 appscode-charts-multicluster-controlplane-v2025.4.30.tar
export_chart ghcr.io/appscode-charts/multicluster-ingress-reader:v2024.7.10 appscode-charts-multicluster-ingress-reader-v2024.7.10.tar
export_chart ghcr.io/appscode-charts/opencost-grafana-dashboards:v2023.10.1 appscode-charts-opencost-grafana-dashboards-v2023.10.1.tar
export_chart ghcr.io/appscode-charts/opencost:1.18.1 appscode-charts-opencost-1.18.1.tar
export_chart ghcr.io/appscode-charts/operator-shard-manager:v2026.1.15 appscode-charts-operator-shard-manager-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/opscenter-features:v2026.1.15 appscode-charts-opscenter-features-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-cassandraopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-cassandraopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-clickhouseopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-clickhouseopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-druidopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-druidopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-elasticsearchopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-elasticsearchopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-etcdopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-etcdopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-ferretdbopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-ferretdbopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-hazelcastopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-hazelcastopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-igniteopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-igniteopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-kafkaopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-kafkaopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-mariadbopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-mariadbopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-memcachedopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-memcachedopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-mongodbopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-mongodbopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-mssqlserveropsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-mssqlserveropsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-mysqlopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-mysqlopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-oracleopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-oracleopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-perconaxtradbopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-perconaxtradbopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-pgbounceropsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-pgbounceropsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-pgpoolopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-pgpoolopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-postgresopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-postgresopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-proxysqlopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-proxysqlopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-rabbitmqopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-rabbitmqopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-redisopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-redisopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-redissentinelopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-redissentinelopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-singlestoreopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-singlestoreopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-solropsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-solropsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/opskubedbcom-zookeeperopsrequest-editor:v0.29.0 appscode-charts-opskubedbcom-zookeeperopsrequest-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/panopticon:v2026.1.15 appscode-charts-panopticon-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/prepare-cluster:v2023.12.21 appscode-charts-prepare-cluster-v2023.12.21.tar
export_chart ghcr.io/appscode-charts/prometheus-adapter:4.9.0 appscode-charts-prometheus-adapter-4.9.0.tar
export_chart ghcr.io/appscode-charts/reloader:1.0.79 appscode-charts-reloader-1.0.79.tar
export_chart ghcr.io/appscode-charts/scanner:v2026.1.15 appscode-charts-scanner-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/sealed-secrets:2.14.2 appscode-charts-sealed-secrets-2.14.2.tar
export_chart ghcr.io/appscode-charts/secrets-store-csi-driver-provider-aws:0.3.6 appscode-charts-secrets-store-csi-driver-provider-aws-0.3.6.tar
export_chart ghcr.io/appscode-charts/secrets-store-csi-driver-provider-gcp:0.1.0 appscode-charts-secrets-store-csi-driver-provider-gcp-0.1.0.tar
export_chart ghcr.io/appscode-charts/secrets-store-csi-driver-provider-virtual-secrets:v2025.3.14 appscode-charts-secrets-store-csi-driver-provider-virtual-secrets-v2025.3.14.tar
export_chart ghcr.io/appscode-charts/secrets-store-csi-driver:1.4.1 appscode-charts-secrets-store-csi-driver-1.4.1.tar
export_chart ghcr.io/appscode-charts/service-backend:v2026.1.15 appscode-charts-service-backend-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/service-gateway-presets:v2026.1.15 appscode-charts-service-gateway-presets-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/service-gateway:v2026.1.15 appscode-charts-service-gateway-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/service-provider:v2026.1.15 appscode-charts-service-provider-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/sidekick:v2026.1.15 appscode-charts-sidekick-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/snapshot-controller:3.0.6 appscode-charts-snapshot-controller-3.0.6.tar
export_chart ghcr.io/appscode-charts/spoke-cluster-addons:v2024.7.10 appscode-charts-spoke-cluster-addons-v2024.7.10.tar
export_chart ghcr.io/appscode-charts/stash-opscenter:v2025.7.31 appscode-charts-stash-opscenter-v2025.7.31.tar
export_chart ghcr.io/appscode-charts/stash-presets:v2026.1.15 appscode-charts-stash-presets-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/stash:v2025.7.31 appscode-charts-stash-v2025.7.31.tar
export_chart ghcr.io/appscode-charts/storagekubestashcom-backupstorage-editor-options:v0.29.0 appscode-charts-storagekubestashcom-backupstorage-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/storagekubestashcom-backupstorage-editor:v0.29.0 appscode-charts-storagekubestashcom-backupstorage-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/storagekubestashcom-repository-editor-options:v0.29.0 appscode-charts-storagekubestashcom-repository-editor-options-v0.29.0.tar
export_chart ghcr.io/appscode-charts/storagekubestashcom-repository-editor:v0.29.0 appscode-charts-storagekubestashcom-repository-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/storagekubestashcom-retentionpolicy-editor:v0.29.0 appscode-charts-storagekubestashcom-retentionpolicy-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/storagekubestashcom-snapshot-editor:v0.29.0 appscode-charts-storagekubestashcom-snapshot-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/supervisor:v2026.1.15 appscode-charts-supervisor-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/topolvm:15.0.0 appscode-charts-topolvm-15.0.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-alert:v0.12.0 appscode-charts-uibytebuildersdev-component-alert-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-backup-option:v0.12.0 appscode-charts-uibytebuildersdev-component-backup-option-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-backupconfiguration:v0.12.0 appscode-charts-uibytebuildersdev-component-backupconfiguration-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-certificates:v0.12.0 appscode-charts-uibytebuildersdev-component-certificates-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-data-sources-items:v0.12.0 appscode-charts-uibytebuildersdev-component-data-sources-items-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-database-runtime-settings:v0.12.0 appscode-charts-uibytebuildersdev-component-database-runtime-settings-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-env-from:v0.12.0 appscode-charts-uibytebuildersdev-component-env-from-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-env:v0.12.0 appscode-charts-uibytebuildersdev-component-env-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-health-checker:v0.12.0 appscode-charts-uibytebuildersdev-component-health-checker-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-initialization:v0.12.0 appscode-charts-uibytebuildersdev-component-initialization-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-jwtoidc-config:v0.12.0 appscode-charts-uibytebuildersdev-component-jwtoidc-config-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-kubedb-ui-presets:v0.12.0 appscode-charts-uibytebuildersdev-component-kubedb-ui-presets-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-match-expressions:v0.12.0 appscode-charts-uibytebuildersdev-component-match-expressions-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-match-fields:v0.12.0 appscode-charts-uibytebuildersdev-component-match-fields-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-monitoring-option:v0.12.0 appscode-charts-uibytebuildersdev-component-monitoring-option-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-pod-template:v0.12.0 appscode-charts-uibytebuildersdev-component-pod-template-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-repository-create:v0.12.0 appscode-charts-uibytebuildersdev-component-repository-create-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-resources:v0.12.0 appscode-charts-uibytebuildersdev-component-resources-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-runtime-settings:v0.12.0 appscode-charts-uibytebuildersdev-component-runtime-settings-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-se-linux-options:v0.12.0 appscode-charts-uibytebuildersdev-component-se-linux-options-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-selector:v0.12.0 appscode-charts-uibytebuildersdev-component-selector-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-service-templates:v0.12.0 appscode-charts-uibytebuildersdev-component-service-templates-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uibytebuildersdev-component-stash-presets:v0.12.0 appscode-charts-uibytebuildersdev-component-stash-presets-v0.12.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-capi-capa-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-capi-capa-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-capi-core-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-capi-core-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-crossplane-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-crossplane-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-ocm-hub-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-ocm-hub-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-ocm-mc-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-ocm-mc-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-ocm-spoke-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-ocm-spoke-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-backup-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-backup-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-core-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-core-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-cost-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-cost-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-datastore-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-datastore-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-networking-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-networking-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-observability-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-observability-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-policy-management-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-policy-management-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-secret-management-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-secret-management-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-security-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-security-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-storage-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-storage-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-tools-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-opscenter-tools-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/uik8sappscodecom-featureset-saas-core-editor:v0.29.0 appscode-charts-uik8sappscodecom-featureset-saas-core-editor-v0.29.0.tar
export_chart ghcr.io/appscode-charts/vault-secrets-operator:0.4.3 appscode-charts-vault-secrets-operator-0.4.3.tar
export_chart ghcr.io/appscode-charts/vault:0.27.0 appscode-charts-vault-0.27.0.tar
export_chart ghcr.io/appscode-charts/virtual-secrets-server:v2025.3.14 appscode-charts-virtual-secrets-server-v2025.3.14.tar
export_chart ghcr.io/appscode-charts/voyager-gateway:v2026.1.15 appscode-charts-voyager-gateway-v2026.1.15.tar
export_chart ghcr.io/appscode-charts/voyager:v2025.9.19 appscode-charts-voyager-v2025.9.19.tar

export_image ghcr.io/appscode-images/ingress-nginx-controller:v1.14.3 appscode-images-ingress-nginx-controller-v1.14.3.tar
export_image ghcr.io/appscode-images/nats:2.10.29-alpine appscode-images-nats-2.10.29-alpine.tar
export_image ghcr.io/appscode-images/postgres:16.4-alpine appscode-images-postgres-16.4-alpine.tar
export_image ghcr.io/appscode-images/redis:7.2.4-bookworm appscode-images-redis-7.2.4-bookworm.tar
export_image ghcr.io/appscode/aceshifter:v0.0.2 appscode-aceshifter-v0.0.2.tar
export_image ghcr.io/appscode/b3:v2026.1.15 appscode-b3-v2026.1.15.tar
export_image ghcr.io/appscode/capa-vpc-peering-operator:v0.0.4 appscode-capa-vpc-peering-operator-v0.0.4.tar
export_image ghcr.io/appscode/capi-ops-manager:v0.0.2 appscode-capi-ops-manager-v0.0.2.tar
export_image ghcr.io/appscode/catalog-manager:v0.10.0 appscode-catalog-manager-v0.10.0.tar
export_image ghcr.io/appscode/cluster-presets:v0.0.10 appscode-cluster-presets-v0.0.10.tar
export_image ghcr.io/appscode/cluster-ui:2.0.0 appscode-cluster-ui-2.0.0.tar
export_image ghcr.io/appscode/config-syncer:v0.15.2-ent appscode-config-syncer-v0.15.2-ent.tar
export_image ghcr.io/appscode/csi-driver-cacerts:v0.5.0 appscode-csi-driver-cacerts-v0.5.0.tar
export_image ghcr.io/appscode/external-dns-operator:v0.3.0 appscode-external-dns-operator-v0.3.0.tar
export_image ghcr.io/appscode/falco-ui-server:v0.0.4 appscode-falco-ui-server-v0.0.4.tar
export_image ghcr.io/appscode/fileserver:v0.0.1 appscode-fileserver-v0.0.1.tar
export_image ghcr.io/appscode/flux-cli:v2.7.2 appscode-flux-cli-v2.7.2.tar
export_image ghcr.io/appscode/gotenberg:8.25 appscode-gotenberg-8.25.tar
export_image ghcr.io/appscode/grafana-tools:v0.5.0 appscode-grafana-tools-v0.5.0.tar
export_image ghcr.io/appscode/grafana:v2025.2.3 appscode-grafana-v2025.2.3.tar
export_image ghcr.io/appscode/inbox-agent:v0.0.2 appscode-inbox-agent-v0.0.2.tar
export_image ghcr.io/appscode/inbox-server:postgres-latest appscode-inbox-server-postgres-latest.tar
export_image ghcr.io/appscode/inbox-ui:0.0.5 appscode-inbox-ui-0.0.5.tar
export_image ghcr.io/appscode/k8s-wait-for:v2.0 appscode-k8s-wait-for-v2.0.tar
export_image ghcr.io/appscode/kube-rbac-proxy:v0.11.0 appscode-kube-rbac-proxy-v0.11.0.tar
export_image ghcr.io/appscode/kube-rbac-proxy:v0.13.0 appscode-kube-rbac-proxy-v0.13.0.tar
export_image ghcr.io/appscode/kube-rbac-proxy:v0.15.0 appscode-kube-rbac-proxy-v0.15.0.tar
export_image ghcr.io/appscode/kube-rbac-proxy:v0.18.2 appscode-kube-rbac-proxy-v0.18.2.tar
export_image ghcr.io/appscode/kube-ui-server:v0.0.69 appscode-kube-ui-server-v0.0.69.tar
export_image ghcr.io/appscode/kubectl-nonroot:1.34 appscode-kubectl-nonroot-1.34.tar
export_image ghcr.io/appscode/kubedb-ui:2.0.0 appscode-kubedb-ui-2.0.0.tar
export_image ghcr.io/appscode/license-proxyserver:v0.0.26 appscode-license-proxyserver-v0.0.26.tar
export_image ghcr.io/appscode/maxmind-geoip:city-mmdb-latest appscode-maxmind-geoip-city-mmdb-latest.tar
export_image ghcr.io/appscode/openfga:v1.11.3 appscode-openfga-v1.11.3.tar
export_image ghcr.io/appscode/operator-shard-manager:v0.0.1 appscode-operator-shard-manager-v0.0.1.tar
export_image ghcr.io/appscode/outboxsyncer:v0.2.0 appscode-outboxsyncer-v0.2.0.tar
export_image ghcr.io/appscode/panopticon:v0.0.21 appscode-panopticon-v0.0.21.tar
export_image ghcr.io/appscode/petset:v0.0.16 appscode-petset-v0.0.16.tar
export_image ghcr.io/appscode/pgoutbox:v0.0.3 appscode-pgoutbox-v0.0.3.tar
export_image ghcr.io/appscode/platform-ui:2.0.0 appscode-platform-ui-2.0.0.tar
export_image ghcr.io/appscode/prom-authproxy:v0.0.2 appscode-prom-authproxy-v0.0.2.tar
export_image ghcr.io/appscode/reloader:v1.0.79 appscode-reloader-v1.0.79.tar
export_image ghcr.io/appscode/s3proxy:sha-a82ca68 appscode-s3proxy-sha-a82ca68.tar
export_image ghcr.io/appscode/scanner:v0.0.19 appscode-scanner-v0.0.19.tar
export_image ghcr.io/appscode/service-provider:v0.0.2 appscode-service-provider-v0.0.2.tar
export_image ghcr.io/appscode/sidekick:v0.0.13 appscode-sidekick-v0.0.13.tar
export_image ghcr.io/appscode/supervisor:v0.0.12 appscode-supervisor-v0.0.12.tar
export_image ghcr.io/appscode/trickster:v2.0.0-beta3 appscode-trickster-v2.0.0-beta3.tar
export_image ghcr.io/appscode/vcluster-plugin-ace:v0.0.3 appscode-vcluster-plugin-ace-v0.0.3.tar
export_image ghcr.io/external-secrets/external-secrets:v0.9.12 external-secrets-external-secrets-v0.9.12.tar
export_image ghcr.io/fluxcd/helm-controller:v1.4.2 fluxcd-helm-controller-v1.4.2.tar
export_image ghcr.io/fluxcd/kustomize-controller:v1.7.1 fluxcd-kustomize-controller-v1.7.1.tar
export_image ghcr.io/fluxcd/notification-controller:v1.7.3 fluxcd-notification-controller-v1.7.3.tar
export_image ghcr.io/fluxcd/source-controller:v1.7.2 fluxcd-source-controller-v1.7.2.tar
export_image ghcr.io/kedacore/http-add-on-interceptor:0.8.0 kedacore-http-add-on-interceptor-0.8.0.tar
export_image ghcr.io/kedacore/http-add-on-operator:0.8.0 kedacore-http-add-on-operator-0.8.0.tar
export_image ghcr.io/kedacore/http-add-on-scaler:0.8.0 kedacore-http-add-on-scaler-0.8.0.tar
export_image ghcr.io/kedacore/keda-admission-webhooks:2.15.1 kedacore-keda-admission-webhooks-2.15.1.tar
export_image ghcr.io/kedacore/keda-metrics-apiserver:2.15.1 kedacore-keda-metrics-apiserver-2.15.1.tar
export_image ghcr.io/kedacore/keda:2.15.1 kedacore-keda-2.15.1.tar
export_image ghcr.io/kluster-manager/addon-manager:v1.0.0 kluster-manager-addon-manager-v1.0.0.tar
export_image ghcr.io/kluster-manager/cluster-auth:v0.4.1 kluster-manager-cluster-auth-v0.4.1.tar
export_image ghcr.io/kluster-manager/cluster-gateway-manager:v1.11.0 kluster-manager-cluster-gateway-manager-v1.11.0.tar
export_image ghcr.io/kluster-manager/cluster-gateway:v1.11.0 kluster-manager-cluster-gateway-v1.11.0.tar
export_image ghcr.io/kluster-manager/cluster-profile:v0.10.0 kluster-manager-cluster-profile-v0.10.0.tar
export_image ghcr.io/kluster-manager/cluster-proxy:v0.7.0 kluster-manager-cluster-proxy-v0.7.0.tar
export_image ghcr.io/kluster-manager/clusteradm:v1.0.0 kluster-manager-clusteradm-v1.0.0.tar
export_image ghcr.io/kluster-manager/fluxcd-addon:v0.0.9 kluster-manager-fluxcd-addon-v0.0.9.tar
export_image ghcr.io/kluster-manager/managed-serviceaccount:v0.8.1 kluster-manager-managed-serviceaccount-v0.8.1.tar
export_image ghcr.io/kluster-manager/placement:v1.0.0 kluster-manager-placement-v1.0.0.tar
export_image ghcr.io/kluster-manager/registration-operator:v1.0.0 kluster-manager-registration-operator-v1.0.0.tar
export_image ghcr.io/kluster-manager/registration:v1.0.0 kluster-manager-registration-v1.0.0.tar
export_image ghcr.io/kluster-manager/work:v1.0.0 kluster-manager-work-v1.0.0.tar
export_image ghcr.io/kubedb/kubedb-autoscaler:v0.45.0 kubedb-kubedb-autoscaler-v0.45.0.tar
export_image ghcr.io/kubedb/kubedb-crd-manager:v0.15.0 kubedb-kubedb-crd-manager-v0.15.0.tar
export_image ghcr.io/kubedb/kubedb-ops-manager:v0.47.0 kubedb-kubedb-ops-manager-v0.47.0.tar
export_image ghcr.io/kubedb/kubedb-provisioner:v0.60.0 kubedb-kubedb-provisioner-v0.60.0.tar
export_image ghcr.io/kubedb/kubedb-schema-manager:v0.36.0 kubedb-kubedb-schema-manager-v0.36.0.tar
export_image ghcr.io/kubedb/kubedb-ui-server:v0.36.0 kubedb-kubedb-ui-server-v0.36.0.tar
export_image ghcr.io/kubedb/kubedb-webhook-server:v0.36.0 kubedb-kubedb-webhook-server-v0.36.0.tar
export_image ghcr.io/kubedb/pg-coordinator:v0.44.0 kubedb-pg-coordinator-v0.44.0.tar
export_image ghcr.io/kubedb/postgres-archiver:v0.21.0_16.1-alpine kubedb-postgres-archiver-v0.21.0_16.1-alpine.tar
export_image ghcr.io/kubedb/postgres-init:0.18.0 kubedb-postgres-init-0.18.0.tar
export_image ghcr.io/kubedb/postgres-restic-plugin:v0.23.0_16.1 kubedb-postgres-restic-plugin-v0.23.0_16.1.tar
export_image ghcr.io/kubedb/redis-coordinator:v0.39.0 kubedb-redis-coordinator-v0.39.0.tar
export_image ghcr.io/kubedb/redis-init:0.12.1 kubedb-redis-init-0.12.1.tar
export_image ghcr.io/kubedb/redis-restic-plugin:v0.23.0 kubedb-redis-restic-plugin-v0.23.0.tar
export_image ghcr.io/kubedb/redis_exporter:1.66.0 kubedb-redis_exporter-1.66.0.tar
export_image ghcr.io/kubedb/vcluster-plugin-kubedb:v0.0.1 kubedb-vcluster-plugin-kubedb-v0.0.1.tar
export_image ghcr.io/kubestash/kubedump:v0.22.0 kubestash-kubedump-v0.22.0.tar
export_image ghcr.io/kubestash/kubestash:v0.23.0 kubestash-kubestash-v0.23.0.tar
export_image ghcr.io/kubevault/vault-operator:v0.19.0 kubevault-vault-operator-v0.19.0.tar
export_image ghcr.io/kyverno/background-controller:v1.12.5 kyverno-background-controller-v1.12.5.tar
export_image ghcr.io/kyverno/cleanup-controller:v1.12.5 kyverno-cleanup-controller-v1.12.5.tar
export_image ghcr.io/kyverno/kyverno:v1.12.5 kyverno-kyverno-v1.12.5.tar
export_image ghcr.io/kyverno/kyvernopre:v1.12.5 kyverno-kyvernopre-v1.12.5.tar
export_image ghcr.io/kyverno/reports-controller:v1.12.5 kyverno-reports-controller-v1.12.5.tar
export_image ghcr.io/loft-sh/vcluster-oss:0.22.4 loft-sh-vcluster-oss-0.22.4.tar
export_image ghcr.io/voyagermesh/echoserver:v20221109 voyagermesh-echoserver-v20221109.tar
export_image ghcr.io/voyagermesh/envoy:v1.36.4-ac voyagermesh-envoy-v1.36.4-ac.tar
export_image ghcr.io/voyagermesh/gateway-converter:v0.0.1 voyagermesh-gateway-converter-v0.0.1.tar
export_image ghcr.io/voyagermesh/gateway:v1.6.2 voyagermesh-gateway-v1.6.2.tar
export_image hashicorp/vault-csi-provider:1.4.1 hashicorp-vault-csi-provider-1.4.1.tar
export_image hashicorp/vault-secrets-operator:0.4.3 hashicorp-vault-secrets-operator-0.4.3.tar
export_image hashicorp/vault:1.15.2 hashicorp-vault-1.15.2.tar
export_image natsio/nats-boot-config:0.16.1 natsio-nats-boot-config-0.16.1.tar
export_image natsio/nats-server-config-reloader:0.17.1 natsio-nats-server-config-reloader-0.17.1.tar
export_image natsio/prometheus-nats-exporter:0.16.0 natsio-prometheus-nats-exporter-0.16.0.tar
export_image openpolicyagent/gatekeeper:v3.13.3 openpolicyagent-gatekeeper-v3.13.3.tar
export_image opensearchproject/opensearch:2.1.0 opensearchproject-opensearch-2.1.0.tar
export_image prometheuscommunity/postgres-exporter:v0.18.1 prometheuscommunity-postgres-exporter-v0.18.1.tar
export_image quay.io/jetstack/cert-manager-acmesolver:v1.19.2 jetstack-cert-manager-acmesolver-v1.19.2.tar
export_image quay.io/jetstack/cert-manager-cainjector:v1.19.2 jetstack-cert-manager-cainjector-v1.19.2.tar
export_image quay.io/jetstack/cert-manager-controller:v1.19.2 jetstack-cert-manager-controller-v1.19.2.tar
export_image quay.io/jetstack/cert-manager-startupapicheck:v1.19.2 jetstack-cert-manager-startupapicheck-v1.19.2.tar
export_image quay.io/jetstack/cert-manager-webhook:v1.19.2 jetstack-cert-manager-webhook-v1.19.2.tar
export_image quay.io/prometheus-operator/prometheus-config-reloader:v0.80.0 prometheus-operator-prometheus-config-reloader-v0.80.0.tar
export_image quay.io/prometheus-operator/prometheus-operator:v0.80.0 prometheus-operator-prometheus-operator-v0.80.0.tar
export_image quay.io/prometheus/alertmanager:v0.28.0 prometheus-alertmanager-v0.28.0.tar
export_image quay.io/prometheus/node-exporter:v1.8.2 prometheus-node-exporter-v1.8.2.tar
export_image quay.io/prometheus/prometheus:v3.1.0 prometheus-prometheus-v3.1.0.tar
export_image quay.io/thanos/thanos:v0.32.5 thanos-thanos-v0.32.5.tar
export_image rabbitmq:3.12.1-management library-rabbitmq-3.12.1-management.tar
export_image rancher/kine:v0.11.4 rancher-kine-v0.11.4.tar
export_image rancher/klipper-lb:v0.4.13 rancher-klipper-lb-v0.4.13.tar
export_image rancher/local-path-provisioner:v0.0.32 rancher-local-path-provisioner-v0.0.32.tar
export_image rancher/mirrored-coredns-coredns:1.13.1 rancher-mirrored-coredns-coredns-1.13.1.tar
export_image rancher/mirrored-library-busybox:1.37.0 rancher-mirrored-library-busybox-1.37.0.tar
export_image rancher/mirrored-pause:3.6 rancher-mirrored-pause-3.6.tar
export_image registry.k8s.io/autoscaling/cluster-autoscaler:v1.27.1 autoscaling-cluster-autoscaler-v1.27.1.tar
export_image registry.k8s.io/csi-secrets-store/driver:v1.4.1 csi-secrets-store-driver-v1.4.1.tar
export_image registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.1 ingress-nginx-kube-webhook-certgen-v1.5.1.tar
export_image registry.k8s.io/kube-apiserver:v1.34.0 kube-apiserver-v1.34.0.tar
export_image registry.k8s.io/kube-controller-manager:v1.34.0 kube-controller-manager-v1.34.0.tar
export_image registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.14.0 kube-state-metrics-kube-state-metrics-v2.14.0.tar
export_image registry.k8s.io/metrics-server/metrics-server:v0.7.2 metrics-server-metrics-server-v0.7.2.tar
export_image registry.k8s.io/prometheus-adapter/prometheus-adapter:v0.11.2 prometheus-adapter-prometheus-adapter-v0.11.2.tar
export_image registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.10.0 sig-storage-csi-node-driver-registrar-v2.10.0.tar
export_image registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.11.1 sig-storage-csi-node-driver-registrar-v2.11.1.tar
export_image registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.14.0 sig-storage-csi-node-driver-registrar-v2.14.0.tar
export_image registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.8.0 sig-storage-csi-node-driver-registrar-v2.8.0.tar
export_image registry.k8s.io/sig-storage/csi-provisioner:v4.0.0 sig-storage-csi-provisioner-v4.0.0.tar
export_image registry.k8s.io/sig-storage/csi-snapshotter:v6.3.3 sig-storage-csi-snapshotter-v6.3.3.tar
export_image registry.k8s.io/sig-storage/livenessprobe:v2.10.0 sig-storage-livenessprobe-v2.10.0.tar
export_image registry.k8s.io/sig-storage/livenessprobe:v2.12.0 sig-storage-livenessprobe-v2.12.0.tar
export_image registry.k8s.io/sig-storage/livenessprobe:v2.16.0 sig-storage-livenessprobe-v2.16.0.tar
export_image registry.k8s.io/sig-storage/nfsplugin:v4.7.0 sig-storage-nfsplugin-v4.7.0.tar
export_image registry.k8s.io/sig-storage/snapshot-controller:v8.0.1 sig-storage-snapshot-controller-v8.0.1.tar
export_image registry.k8s.io/sig-storage/snapshot-validation-webhook:v8.0.1 sig-storage-snapshot-validation-webhook-v8.0.1.tar
export_image alpine:3.20 library-alpine-3.20.tar
export_image bitnami/kubectl:latest bitnami-kubectl-latest.tar
export_image bitnami/sealed-secrets-controller:0.25.0 bitnami-sealed-secrets-controller-0.25.0.tar
export_image cassandra:4.1.3 library-cassandra-4.1.3.tar
export_image coredns/coredns:1.11.3 coredns-coredns-1.11.3.tar
export_image falcosecurity/falco-no-driver:0.37.0 falcosecurity-falco-no-driver-0.37.0.tar
export_image falcosecurity/falcoctl:0.7.1 falcosecurity-falcoctl-0.7.1.tar

wait_all

# Validate expected count
actual=$(find images -name '*.tar' | wc -l)
if [[ "$actual" -ne "$EXPECTED_COUNT" ]]; then
    printf '\033[31mValidation failed: expected %d files, got %d\033[0m\n' "$EXPECTED_COUNT" "$actual" >&2
    exit 1
fi
printf '\033[32mValidation passed: %d files\033[0m\n' "$actual" >&2

tar -czvf images.tar.gz images
