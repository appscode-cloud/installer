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

mkdir -p images

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
mv /tmp/crane images

CMD="./images/crane"

$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/ace-installer:v2026.2.16 images/appscode-charts-ace-installer-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/ace:v2026.2.16 images/appscode-charts-ace-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/aceshifter:v2026.2.16 images/appscode-charts-aceshifter-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-cassandraautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-cassandraautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-clickhouseautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-clickhouseautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-druidautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-druidautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-elasticsearchautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-elasticsearchautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-etcdautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-etcdautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-ferretdbautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-ferretdbautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-kafkaautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-kafkaautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-mariadbautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-mariadbautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-memcachedautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-memcachedautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-mongodbautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-mongodbautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-mssqlserverautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-mssqlserverautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-mysqlautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-mysqlautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-perconaxtradbautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-perconaxtradbautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-pgbouncerautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-pgbouncerautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-pgpoolautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-pgpoolautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-postgresautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-postgresautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-proxysqlautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-proxysqlautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-rabbitmqautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-rabbitmqautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-redisautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-redisautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-redissentinelautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-redissentinelautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-singlestoreautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-singlestoreautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-solrautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-solrautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/autoscalingkubedbcom-zookeeperautoscaler-editor:v0.29.0 images/appscode-charts-autoscalingkubedbcom-zookeeperautoscaler-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/aws-credential-manager:v2025.4.30 images/appscode-charts-aws-credential-manager-v2025.4.30.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/aws-ebs-csi-driver:2.23.0 images/appscode-charts-aws-ebs-csi-driver-2.23.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/aws-load-balancer-controller:1.11.0 images/appscode-charts-aws-load-balancer-controller-1.11.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/capa-vpc-peering-operator:v2023.12.11 images/appscode-charts-capa-vpc-peering-operator-v2023.12.11.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/capi-catalog:v2024.10.24 images/appscode-charts-capi-catalog-v2024.10.24.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/capi-ops-manager:v2024.8.14 images/appscode-charts-capi-ops-manager-v2024.8.14.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/catalog-manager:v2026.2.16 images/appscode-charts-catalog-manager-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cert-manager-csi-driver-cacerts:v2026.1.15 images/appscode-charts-cert-manager-csi-driver-cacerts-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cert-manager:v1.19.3 images/appscode-charts-cert-manager-v1.19.3.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/chartsxhelmdev-chartpreset-editor:v0.29.0 images/appscode-charts-chartsxhelmdev-chartpreset-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/chartsxhelmdev-clusterchartpreset-editor-options:v0.29.0 images/appscode-charts-chartsxhelmdev-clusterchartpreset-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/chartsxhelmdev-clusterchartpreset-editor:v0.29.0 images/appscode-charts-chartsxhelmdev-clusterchartpreset-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cluster-auth-manager:v2026.2.16 images/appscode-charts-cluster-auth-manager-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cluster-autoscaler:9.29.0 images/appscode-charts-cluster-autoscaler-9.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cluster-gateway-manager:v2026.2.16 images/appscode-charts-cluster-gateway-manager-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cluster-manager-hub:v2026.2.16 images/appscode-charts-cluster-manager-hub-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cluster-manager-spoke:v2026.2.16 images/appscode-charts-cluster-manager-spoke-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cluster-presets:v2026.2.16 images/appscode-charts-cluster-presets-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cluster-profile-manager:v2026.2.16 images/appscode-charts-cluster-profile-manager-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/cluster-proxy-manager:v2026.2.16 images/appscode-charts-cluster-proxy-manager-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/config-syncer:v0.15.4 images/appscode-charts-config-syncer-v0.15.4.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-backupbatch-editor:v0.29.0 images/appscode-charts-corekubestashcom-backupbatch-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-backupblueprint-editor:v0.29.0 images/appscode-charts-corekubestashcom-backupblueprint-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-backupconfiguration-editor-options:v0.29.0 images/appscode-charts-corekubestashcom-backupconfiguration-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-backupconfiguration-editor:v0.29.0 images/appscode-charts-corekubestashcom-backupconfiguration-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-backupsession-editor-options:v0.29.0 images/appscode-charts-corekubestashcom-backupsession-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-backupsession-editor:v0.29.0 images/appscode-charts-corekubestashcom-backupsession-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-backupverificationsession-editor:v0.29.0 images/appscode-charts-corekubestashcom-backupverificationsession-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-backupverifier-editor:v0.29.0 images/appscode-charts-corekubestashcom-backupverifier-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-hooktemplate-editor:v0.29.0 images/appscode-charts-corekubestashcom-hooktemplate-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-restoresession-editor-options:v0.29.0 images/appscode-charts-corekubestashcom-restoresession-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/corekubestashcom-restoresession-editor:v0.29.0 images/appscode-charts-corekubestashcom-restoresession-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/crossplane:1.14.0 images/appscode-charts-crossplane-1.14.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/csi-driver-nfs:v4.7.0 images/appscode-charts-csi-driver-nfs-v4.7.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/csi-secrets-store-provider-azure:1.5.2 images/appscode-charts-csi-secrets-store-provider-azure-1.5.2.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/external-dns-operator:v2026.1.15 images/appscode-charts-external-dns-operator-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/external-secrets:0.9.12 images/appscode-charts-external-secrets-0.9.12.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/falco-ui-server:v2026.1.15 images/appscode-charts-falco-ui-server-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/falco:4.0.0 images/appscode-charts-falco-4.0.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/flux2:2.17.0 images/appscode-charts-flux2-2.17.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/fluxcd-manager:v2026.2.16 images/appscode-charts-fluxcd-manager-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/gatekeeper-grafana-dashboards:v2023.10.1 images/appscode-charts-gatekeeper-grafana-dashboards-v2023.10.1.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/gatekeeper-library:v2023.10.1 images/appscode-charts-gatekeeper-library-v2023.10.1.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/gatekeeper:3.13.3 images/appscode-charts-gatekeeper-3.13.3.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/gateway-api:v2025.3.14 images/appscode-charts-gateway-api-v2025.3.14.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/grafana-operator:v2026.1.15 images/appscode-charts-grafana-operator-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/hub-cluster-robot:v2026.2.16 images/appscode-charts-hub-cluster-robot-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/inbox-agent:v2024.12.30 images/appscode-charts-inbox-agent-v2024.12.30.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/inbox-server:v2025.2.28 images/appscode-charts-inbox-server-v2025.2.28.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/inbox-ui:v2026.2.16 images/appscode-charts-inbox-ui-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/keda-add-ons-http:0.10.0 images/appscode-charts-keda-add-ons-http-0.10.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/keda:2.17.2 images/appscode-charts-keda-2.17.2.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kube-grafana-dashboards:v2023.10.1 images/appscode-charts-kube-grafana-dashboards-v2023.10.1.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kube-prometheus-stack:69.2.2 images/appscode-charts-kube-prometheus-stack-69.2.2.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kube-ui-server:v2026.2.16 images/appscode-charts-kube-ui-server-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedb-opscenter:v2026.2.21-rc.1 images/appscode-charts-kubedb-opscenter-v2026.2.21-rc.1.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedb-provider-aws:v2024.1.31 images/appscode-charts-kubedb-provider-aws-v2024.1.31.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedb-provider-azure:v2024.1.31 images/appscode-charts-kubedb-provider-azure-v2024.1.31.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedb-provider-gcp:v2024.1.31 images/appscode-charts-kubedb-provider-gcp-v2024.1.31.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedb-ui-presets:v2026.2.16 images/appscode-charts-kubedb-ui-presets-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedb:v2026.2.21-rc.1 images/appscode-charts-kubedb-v2026.2.21-rc.1.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-cassandra-editor-options:v0.29.0 images/appscode-charts-kubedbcom-cassandra-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-cassandra-editor:v0.29.0 images/appscode-charts-kubedbcom-cassandra-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-clickhouse-editor-options:v0.29.0 images/appscode-charts-kubedbcom-clickhouse-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-clickhouse-editor:v0.29.0 images/appscode-charts-kubedbcom-clickhouse-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-druid-editor-options:v0.29.0 images/appscode-charts-kubedbcom-druid-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-druid-editor:v0.29.0 images/appscode-charts-kubedbcom-druid-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-elasticsearch-editor-options:v0.29.0 images/appscode-charts-kubedbcom-elasticsearch-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-elasticsearch-editor:v0.29.0 images/appscode-charts-kubedbcom-elasticsearch-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-etcd-editor:v0.29.0 images/appscode-charts-kubedbcom-etcd-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-ferretdb-editor-options:v0.29.0 images/appscode-charts-kubedbcom-ferretdb-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-ferretdb-editor:v0.29.0 images/appscode-charts-kubedbcom-ferretdb-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-hazelcast-editor-options:v0.29.0 images/appscode-charts-kubedbcom-hazelcast-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-hazelcast-editor:v0.29.0 images/appscode-charts-kubedbcom-hazelcast-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-ignite-editor-options:v0.29.0 images/appscode-charts-kubedbcom-ignite-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-ignite-editor:v0.29.0 images/appscode-charts-kubedbcom-ignite-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-kafka-editor-options:v0.29.0 images/appscode-charts-kubedbcom-kafka-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-kafka-editor:v0.29.0 images/appscode-charts-kubedbcom-kafka-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-mariadb-editor-options:v0.29.0 images/appscode-charts-kubedbcom-mariadb-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-mariadb-editor:v0.29.0 images/appscode-charts-kubedbcom-mariadb-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-memcached-editor-options:v0.29.0 images/appscode-charts-kubedbcom-memcached-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-memcached-editor:v0.29.0 images/appscode-charts-kubedbcom-memcached-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-mongodb-editor-options:v0.29.0 images/appscode-charts-kubedbcom-mongodb-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-mongodb-editor:v0.29.0 images/appscode-charts-kubedbcom-mongodb-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-mssqlserver-editor-options:v0.29.0 images/appscode-charts-kubedbcom-mssqlserver-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-mssqlserver-editor:v0.29.0 images/appscode-charts-kubedbcom-mssqlserver-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-mysql-editor-options:v0.29.0 images/appscode-charts-kubedbcom-mysql-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-mysql-editor:v0.29.0 images/appscode-charts-kubedbcom-mysql-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-oracle-editor-options:v0.29.0 images/appscode-charts-kubedbcom-oracle-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-oracle-editor:v0.29.0 images/appscode-charts-kubedbcom-oracle-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-perconaxtradb-editor-options:v0.29.0 images/appscode-charts-kubedbcom-perconaxtradb-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-perconaxtradb-editor:v0.29.0 images/appscode-charts-kubedbcom-perconaxtradb-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-pgbouncer-editor-options:v0.29.0 images/appscode-charts-kubedbcom-pgbouncer-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-pgbouncer-editor:v0.29.0 images/appscode-charts-kubedbcom-pgbouncer-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-pgpool-editor-options:v0.29.0 images/appscode-charts-kubedbcom-pgpool-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-pgpool-editor:v0.29.0 images/appscode-charts-kubedbcom-pgpool-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-postgres-editor-options:v0.29.0 images/appscode-charts-kubedbcom-postgres-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-postgres-editor:v0.29.0 images/appscode-charts-kubedbcom-postgres-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-proxysql-editor-options:v0.29.0 images/appscode-charts-kubedbcom-proxysql-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-proxysql-editor:v0.29.0 images/appscode-charts-kubedbcom-proxysql-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-rabbitmq-editor-options:v0.29.0 images/appscode-charts-kubedbcom-rabbitmq-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-rabbitmq-editor:v0.29.0 images/appscode-charts-kubedbcom-rabbitmq-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-redis-editor-options:v0.29.0 images/appscode-charts-kubedbcom-redis-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-redis-editor:v0.29.0 images/appscode-charts-kubedbcom-redis-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-redissentinel-editor:v0.29.0 images/appscode-charts-kubedbcom-redissentinel-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-singlestore-editor-options:v0.29.0 images/appscode-charts-kubedbcom-singlestore-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-singlestore-editor:v0.29.0 images/appscode-charts-kubedbcom-singlestore-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-solr-editor-options:v0.29.0 images/appscode-charts-kubedbcom-solr-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-solr-editor:v0.29.0 images/appscode-charts-kubedbcom-solr-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-zookeeper-editor-options:v0.29.0 images/appscode-charts-kubedbcom-zookeeper-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubedbcom-zookeeper-editor:v0.29.0 images/appscode-charts-kubedbcom-zookeeper-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubestash:v2026.2.16-rc.0 images/appscode-charts-kubestash-v2026.2.16-rc.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubevault-opscenter:v2025.11.21 images/appscode-charts-kubevault-opscenter-v2025.11.21.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kubevault:v2025.11.21 images/appscode-charts-kubevault-v2025.11.21.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kyverno-policies:3.2.5 images/appscode-charts-kyverno-policies-3.2.5.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/kyverno:3.2.6 images/appscode-charts-kyverno-3.2.6.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/license-proxyserver-manager:v2026.2.16 images/appscode-charts-license-proxyserver-manager-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/license-proxyserver:v2026.1.15 images/appscode-charts-license-proxyserver-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/longhorn:1.7.2 images/appscode-charts-longhorn-1.7.2.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/managed-serviceaccount-manager:v2026.2.16 images/appscode-charts-managed-serviceaccount-manager-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/metrics-server:3.11.0 images/appscode-charts-metrics-server-3.11.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/monitoring-operator:v2026.1.15 images/appscode-charts-monitoring-operator-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opencost-grafana-dashboards:v2023.10.1 images/appscode-charts-opencost-grafana-dashboards-v2023.10.1.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opencost:1.18.1 images/appscode-charts-opencost-1.18.1.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/operator-shard-manager:v2026.1.15 images/appscode-charts-operator-shard-manager-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opscenter-features:v2026.2.16 images/appscode-charts-opscenter-features-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-cassandraopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-cassandraopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-clickhouseopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-clickhouseopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-druidopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-druidopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-elasticsearchopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-elasticsearchopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-etcdopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-etcdopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-ferretdbopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-ferretdbopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-hazelcastopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-hazelcastopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-igniteopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-igniteopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-kafkaopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-kafkaopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-mariadbopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-mariadbopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-memcachedopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-memcachedopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-mongodbopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-mongodbopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-mssqlserveropsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-mssqlserveropsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-mysqlopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-mysqlopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-oracleopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-oracleopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-perconaxtradbopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-perconaxtradbopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-pgbounceropsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-pgbounceropsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-pgpoolopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-pgpoolopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-postgresopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-postgresopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-proxysqlopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-proxysqlopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-rabbitmqopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-rabbitmqopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-redisopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-redisopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-redissentinelopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-redissentinelopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-singlestoreopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-singlestoreopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-solropsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-solropsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/opskubedbcom-zookeeperopsrequest-editor:v0.29.0 images/appscode-charts-opskubedbcom-zookeeperopsrequest-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/panopticon:v2026.1.15 images/appscode-charts-panopticon-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/prepare-cluster:v2023.12.21 images/appscode-charts-prepare-cluster-v2023.12.21.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/prometheus-adapter:4.9.0 images/appscode-charts-prometheus-adapter-4.9.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/reloader:1.0.79 images/appscode-charts-reloader-1.0.79.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/scanner:v2026.1.15 images/appscode-charts-scanner-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/sealed-secrets:2.14.2 images/appscode-charts-sealed-secrets-2.14.2.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/secrets-store-csi-driver-provider-aws:0.3.6 images/appscode-charts-secrets-store-csi-driver-provider-aws-0.3.6.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/secrets-store-csi-driver-provider-gcp:0.1.0 images/appscode-charts-secrets-store-csi-driver-provider-gcp-0.1.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/secrets-store-csi-driver-provider-virtual-secrets:v2025.3.14 images/appscode-charts-secrets-store-csi-driver-provider-virtual-secrets-v2025.3.14.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/secrets-store-csi-driver:1.4.1 images/appscode-charts-secrets-store-csi-driver-1.4.1.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/service-backend:v2026.2.16 images/appscode-charts-service-backend-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/service-gateway-presets:v2026.2.16 images/appscode-charts-service-gateway-presets-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/service-gateway:v2026.2.16 images/appscode-charts-service-gateway-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/service-provider:v2026.2.16 images/appscode-charts-service-provider-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/sidekick:v2026.1.15 images/appscode-charts-sidekick-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/snapshot-controller:3.0.6 images/appscode-charts-snapshot-controller-3.0.6.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/stash-opscenter:v2025.7.31 images/appscode-charts-stash-opscenter-v2025.7.31.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/stash-presets:v2026.2.16 images/appscode-charts-stash-presets-v2026.2.16.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/stash:v2025.7.31 images/appscode-charts-stash-v2025.7.31.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/storagekubestashcom-backupstorage-editor-options:v0.29.0 images/appscode-charts-storagekubestashcom-backupstorage-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/storagekubestashcom-backupstorage-editor:v0.29.0 images/appscode-charts-storagekubestashcom-backupstorage-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/storagekubestashcom-repository-editor-options:v0.29.0 images/appscode-charts-storagekubestashcom-repository-editor-options-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/storagekubestashcom-repository-editor:v0.29.0 images/appscode-charts-storagekubestashcom-repository-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/storagekubestashcom-retentionpolicy-editor:v0.29.0 images/appscode-charts-storagekubestashcom-retentionpolicy-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/storagekubestashcom-snapshot-editor:v0.29.0 images/appscode-charts-storagekubestashcom-snapshot-editor-v0.29.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/supervisor:v2026.1.15 images/appscode-charts-supervisor-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/topolvm:15.0.0 images/appscode-charts-topolvm-15.0.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-alert:v0.12.0 images/appscode-charts-uibytebuildersdev-component-alert-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-backup-option:v0.12.0 images/appscode-charts-uibytebuildersdev-component-backup-option-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-backupconfiguration:v0.12.0 images/appscode-charts-uibytebuildersdev-component-backupconfiguration-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-certificates:v0.12.0 images/appscode-charts-uibytebuildersdev-component-certificates-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-data-sources-items:v0.12.0 images/appscode-charts-uibytebuildersdev-component-data-sources-items-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-database-runtime-settings:v0.12.0 images/appscode-charts-uibytebuildersdev-component-database-runtime-settings-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-env-from:v0.12.0 images/appscode-charts-uibytebuildersdev-component-env-from-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-env:v0.12.0 images/appscode-charts-uibytebuildersdev-component-env-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-health-checker:v0.12.0 images/appscode-charts-uibytebuildersdev-component-health-checker-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-initialization:v0.12.0 images/appscode-charts-uibytebuildersdev-component-initialization-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-jwtoidc-config:v0.12.0 images/appscode-charts-uibytebuildersdev-component-jwtoidc-config-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-kubedb-ui-presets:v0.12.0 images/appscode-charts-uibytebuildersdev-component-kubedb-ui-presets-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-match-expressions:v0.12.0 images/appscode-charts-uibytebuildersdev-component-match-expressions-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-match-fields:v0.12.0 images/appscode-charts-uibytebuildersdev-component-match-fields-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-monitoring-option:v0.12.0 images/appscode-charts-uibytebuildersdev-component-monitoring-option-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-pod-template:v0.12.0 images/appscode-charts-uibytebuildersdev-component-pod-template-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-repository-create:v0.12.0 images/appscode-charts-uibytebuildersdev-component-repository-create-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-resources:v0.12.0 images/appscode-charts-uibytebuildersdev-component-resources-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-runtime-settings:v0.12.0 images/appscode-charts-uibytebuildersdev-component-runtime-settings-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-se-linux-options:v0.12.0 images/appscode-charts-uibytebuildersdev-component-se-linux-options-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-selector:v0.12.0 images/appscode-charts-uibytebuildersdev-component-selector-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-service-templates:v0.12.0 images/appscode-charts-uibytebuildersdev-component-service-templates-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uibytebuildersdev-component-stash-presets:v0.12.0 images/appscode-charts-uibytebuildersdev-component-stash-presets-v0.12.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-capi-capa-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-capi-capa-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-capi-core-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-capi-core-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-crossplane-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-crossplane-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-ocm-hub-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-ocm-hub-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-ocm-spoke-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-ocm-spoke-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-backup-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-backup-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-core-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-core-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-cost-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-cost-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-datastore-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-datastore-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-networking-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-networking-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-observability-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-observability-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-policy-management-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-policy-management-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-secret-management-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-secret-management-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-security-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-security-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-storage-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-storage-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-opscenter-tools-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-opscenter-tools-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/uik8sappscodecom-featureset-saas-core-editor:v0.30.0 images/appscode-charts-uik8sappscodecom-featureset-saas-core-editor-v0.30.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/vault-secrets-operator:0.4.3 images/appscode-charts-vault-secrets-operator-0.4.3.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/vault:0.27.0 images/appscode-charts-vault-0.27.0.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/virtual-secrets-server:v2025.3.14 images/appscode-charts-virtual-secrets-server-v2025.3.14.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/voyager-gateway:v2026.1.15 images/appscode-charts-voyager-gateway-v2026.1.15.tar
$CMD pull --allow-nondistributable-artifacts --insecure ghcr.io/appscode-charts/voyager:v2025.9.19 images/appscode-charts-voyager-v2025.9.19.tar

tar -czvf images.tar.gz images
