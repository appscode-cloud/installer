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

k3s ctr images import images/library-alpine-3.20.tar
k3s ctr images import images/bitnami-kubectl-1.28.5.tar
k3s ctr images import images/bitnami-sealed-secrets-controller-0.25.0.tar
k3s ctr images import images/library-cassandra-4.1.3.tar
k3s ctr images import images/coredns-coredns-1.11.3.tar
k3s ctr images import images/falcosecurity-falco-no-driver-0.37.0.tar
k3s ctr images import images/falcosecurity-falcoctl-0.7.1.tar
k3s ctr images import images/appscode-charts-ace-installer-v2025.3.14.tar
k3s ctr images import images/appscode-charts-ace-v2025.3.14.tar
k3s ctr images import images/appscode-charts-aceshifter-v2025.3.14.tar
k3s ctr images import images/appscode-charts-appscode-otel-stack-v2025.2.28.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-cassandraautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-clickhouseautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-druidautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-elasticsearchautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-etcdautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-ferretdbautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-kafkaautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-mariadbautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-memcachedautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-mongodbautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-mssqlserverautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-mysqlautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-perconaxtradbautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-pgbouncerautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-pgpoolautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-postgresautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-proxysqlautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-rabbitmqautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-redisautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-redissentinelautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-singlestoreautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-solrautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-autoscalingkubedbcom-zookeeperautoscaler-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-aws-credential-manager-v2025.3.14.tar
k3s ctr images import images/appscode-charts-aws-ebs-csi-driver-2.23.0.tar
k3s ctr images import images/appscode-charts-aws-load-balancer-controller-1.11.0.tar
k3s ctr images import images/appscode-charts-capa-vpc-peering-operator-v2023.12.11.tar
k3s ctr images import images/appscode-charts-capi-catalog-v2024.10.24.tar
k3s ctr images import images/appscode-charts-capi-ops-manager-v2024.8.14.tar
k3s ctr images import images/appscode-charts-catalog-manager-v2025.3.14.tar
k3s ctr images import images/appscode-charts-cert-manager-csi-driver-cacerts-v2024.10.17.tar
k3s ctr images import images/appscode-charts-cert-manager-v1.17.1.tar
k3s ctr images import images/appscode-charts-chartsxhelmdev-chartpreset-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-chartsxhelmdev-clusterchartpreset-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-chartsxhelmdev-clusterchartpreset-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-cluster-auth-manager-v2024.12.26.tar
k3s ctr images import images/appscode-charts-cluster-autoscaler-9.29.0.tar
k3s ctr images import images/appscode-charts-cluster-gateway-manager-v2024.12.26.tar
k3s ctr images import images/appscode-charts-cluster-manager-hub-v2024.12.26.tar
k3s ctr images import images/appscode-charts-cluster-manager-spoke-v2024.12.26.tar
k3s ctr images import images/appscode-charts-cluster-presets-v2025.3.14.tar
k3s ctr images import images/appscode-charts-cluster-profile-manager-v2025.3.6.tar
k3s ctr images import images/appscode-charts-cluster-proxy-manager-v2024.12.26.tar
k3s ctr images import images/appscode-charts-config-syncer-v0.15.2.tar
k3s ctr images import images/appscode-charts-corekubestashcom-backupbatch-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-backupblueprint-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-backupconfiguration-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-backupconfiguration-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-backupsession-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-backupsession-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-backupverificationsession-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-backupverifier-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-hooktemplate-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-restoresession-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-corekubestashcom-restoresession-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-crossplane-1.14.0.tar
k3s ctr images import images/appscode-charts-csi-driver-nfs-v4.7.0.tar
k3s ctr images import images/appscode-charts-csi-secrets-store-provider-azure-1.5.2.tar
k3s ctr images import images/appscode-charts-external-dns-operator-v2024.4.19.tar
k3s ctr images import images/appscode-charts-external-secrets-0.9.12.tar
k3s ctr images import images/appscode-charts-falco-ui-server-v2024.5.17.tar
k3s ctr images import images/appscode-charts-falco-4.0.0.tar
k3s ctr images import images/appscode-charts-flux2-2.15.0.tar
k3s ctr images import images/appscode-charts-fluxcd-manager-v2024.12.26.tar
k3s ctr images import images/appscode-charts-gatekeeper-grafana-dashboards-v2023.10.1.tar
k3s ctr images import images/appscode-charts-gatekeeper-library-v2023.10.1.tar
k3s ctr images import images/appscode-charts-gatekeeper-3.13.3.tar
k3s ctr images import images/appscode-charts-gateway-api-v1.1.0.tar
k3s ctr images import images/appscode-charts-grafana-operator-v2025.3.14.tar
k3s ctr images import images/appscode-charts-hub-cluster-robot-v2024.8.9.tar
k3s ctr images import images/appscode-charts-inbox-agent-v2024.12.30.tar
k3s ctr images import images/appscode-charts-inbox-server-v2025.2.28.tar
k3s ctr images import images/appscode-charts-inbox-ui-v2025.3.14.tar
k3s ctr images import images/appscode-charts-ingress-nginx-4.11.1.tar
k3s ctr images import images/appscode-charts-keda-add-ons-http-0.10.0.tar
k3s ctr images import images/appscode-charts-keda-2.16.1.tar
k3s ctr images import images/appscode-charts-kube-grafana-dashboards-v2023.10.1.tar
k3s ctr images import images/appscode-charts-kube-prometheus-stack-69.2.2.tar
k3s ctr images import images/appscode-charts-kube-ui-server-v2025.3.14.tar
k3s ctr images import images/appscode-charts-kubedb-opscenter-v2025.2.19.tar
k3s ctr images import images/appscode-charts-kubedb-provider-aws-v2024.1.31.tar
k3s ctr images import images/appscode-charts-kubedb-provider-azure-v2024.1.31.tar
k3s ctr images import images/appscode-charts-kubedb-provider-gcp-v2024.1.31.tar
k3s ctr images import images/appscode-charts-kubedb-ui-presets-v2025.3.14.tar
k3s ctr images import images/appscode-charts-kubedb-v2025.2.19.tar
k3s ctr images import images/appscode-charts-kubedbcom-cassandra-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-clickhouse-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-clickhouse-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-druid-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-druid-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-elasticsearch-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-elasticsearch-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-etcd-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-ferretdb-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-ferretdb-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-kafka-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-kafka-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-mariadb-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-mariadb-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-memcached-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-memcached-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-mongodb-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-mongodb-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-mssqlserver-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-mssqlserver-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-mysql-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-mysql-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-perconaxtradb-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-perconaxtradb-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-pgbouncer-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-pgbouncer-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-pgpool-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-pgpool-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-postgres-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-postgres-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-proxysql-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-proxysql-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-rabbitmq-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-rabbitmq-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-redis-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-redis-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-redissentinel-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-singlestore-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-singlestore-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-solr-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-solr-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-zookeeper-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubedbcom-zookeeper-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-kubestash-v2025.2.10.tar
k3s ctr images import images/appscode-charts-kubevault-opscenter-v2025.2.10.tar
k3s ctr images import images/appscode-charts-kubevault-v2025.2.10.tar
k3s ctr images import images/appscode-charts-kyverno-policies-3.2.5.tar
k3s ctr images import images/appscode-charts-kyverno-3.2.6.tar
k3s ctr images import images/appscode-charts-license-proxyserver-manager-v2025.1.17.tar
k3s ctr images import images/appscode-charts-license-proxyserver-v2025.1.17.tar
k3s ctr images import images/appscode-charts-longhorn-1.7.2.tar
k3s ctr images import images/appscode-charts-managed-serviceaccount-manager-v2024.12.26.tar
k3s ctr images import images/appscode-charts-metrics-server-3.11.0.tar
k3s ctr images import images/appscode-charts-monitoring-operator-v2025.3.14.tar
k3s ctr images import images/appscode-charts-multicluster-controlplane-v2024.7.10.tar
k3s ctr images import images/appscode-charts-multicluster-ingress-reader-v2024.7.10.tar
k3s ctr images import images/appscode-charts-opencost-grafana-dashboards-v2023.10.1.tar
k3s ctr images import images/appscode-charts-opencost-1.18.1.tar
k3s ctr images import images/appscode-charts-operator-shard-manager-v2025.3.14.tar
k3s ctr images import images/appscode-charts-opscenter-features-v2025.3.14.tar
k3s ctr images import images/appscode-charts-opskubedbcom-clickhouseopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-druidopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-elasticsearchopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-etcdopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-ferretdbopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-kafkaopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-mariadbopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-memcachedopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-mongodbopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-mssqlserveropsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-mysqlopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-perconaxtradbopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-pgbounceropsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-pgpoolopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-postgresopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-proxysqlopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-rabbitmqopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-redisopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-redissentinelopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-singlestoreopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-solropsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-opskubedbcom-zookeeperopsrequest-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-panopticon-v2025.3.14.tar
k3s ctr images import images/appscode-charts-prepare-cluster-v2023.12.21.tar
k3s ctr images import images/appscode-charts-prometheus-adapter-4.9.0.tar
k3s ctr images import images/appscode-charts-reloader-1.0.79.tar
k3s ctr images import images/appscode-charts-scanner-v2024.9.30.tar
k3s ctr images import images/appscode-charts-sealed-secrets-2.14.2.tar
k3s ctr images import images/appscode-charts-secrets-store-csi-driver-provider-aws-0.3.6.tar
k3s ctr images import images/appscode-charts-secrets-store-csi-driver-provider-gcp-0.1.0.tar
k3s ctr images import images/appscode-charts-secrets-store-csi-driver-provider-virtual-secrets-v2025.3.14.tar
k3s ctr images import images/appscode-charts-secrets-store-csi-driver-1.4.1.tar
k3s ctr images import images/appscode-charts-service-backend-v2025.3.14.tar
k3s ctr images import images/appscode-charts-service-gateway-presets-v2025.3.14.tar
k3s ctr images import images/appscode-charts-service-gateway-v2025.3.14.tar
k3s ctr images import images/appscode-charts-service-provider-v2025.3.14.tar
k3s ctr images import images/appscode-charts-sidekick-v2024.11.8.tar
k3s ctr images import images/appscode-charts-snapshot-controller-3.0.6.tar
k3s ctr images import images/appscode-charts-spoke-cluster-addons-v2024.7.10.tar
k3s ctr images import images/appscode-charts-stash-opscenter-v2025.2.10.tar
k3s ctr images import images/appscode-charts-stash-presets-v2025.3.14.tar
k3s ctr images import images/appscode-charts-stash-v2025.2.10.tar
k3s ctr images import images/appscode-charts-storagekubestashcom-backupstorage-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-storagekubestashcom-backupstorage-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-storagekubestashcom-repository-editor-options-v0.14.0.tar
k3s ctr images import images/appscode-charts-storagekubestashcom-repository-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-storagekubestashcom-retentionpolicy-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-storagekubestashcom-snapshot-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-supervisor-v2024.11.8.tar
k3s ctr images import images/appscode-charts-topolvm-15.0.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-alert-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-backup-option-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-backupconfiguration-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-certificates-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-data-sources-items-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-database-runtime-settings-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-env-from-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-env-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-health-checker-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-initialization-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-jwtoidc-config-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-kubedb-ui-presets-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-match-expressions-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-match-fields-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-monitoring-option-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-pod-template-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-repository-create-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-resources-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-runtime-settings-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-se-linux-options-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-selector-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-service-templates-v0.12.0.tar
k3s ctr images import images/appscode-charts-uibytebuildersdev-component-stash-presets-v0.12.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-capi-capa-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-capi-core-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-crossplane-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-ocm-hub-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-ocm-mc-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-ocm-spoke-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-backup-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-core-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-cost-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-datastore-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-networking-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-observability-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-policy-management-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-secret-management-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-security-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-storage-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-opscenter-tools-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-uik8sappscodecom-featureset-saas-core-editor-v0.14.0.tar
k3s ctr images import images/appscode-charts-vault-secrets-operator-0.4.3.tar
k3s ctr images import images/appscode-charts-vault-0.27.0.tar
k3s ctr images import images/appscode-charts-virtual-secrets-server-v2025.3.14.tar
k3s ctr images import images/appscode-charts-voyager-gateway-v2024.11.4.tar
k3s ctr images import images/appscode-charts-voyager-v2024.8.30.tar
k3s ctr images import images/appscode-images-ingress-nginx-controller-v1.11.1.tar
k3s ctr images import images/appscode-images-nats-2.10.24-alpine.tar
k3s ctr images import images/appscode-images-postgres-16.4-alpine.tar
k3s ctr images import images/appscode-images-redis-7.2.4-bookworm.tar
k3s ctr images import images/appscode-aceshifter-v0.0.1.tar
k3s ctr images import images/appscode-b3-v2025.3.14.tar
k3s ctr images import images/appscode-capa-vpc-peering-operator-v0.0.4.tar
k3s ctr images import images/appscode-capi-ops-manager-v0.0.2.tar
k3s ctr images import images/appscode-catalog-manager-v0.2.3.tar
k3s ctr images import images/appscode-cluster-presets-v0.0.8.tar
k3s ctr images import images/appscode-cluster-ui-0.9.14.tar
k3s ctr images import images/appscode-config-syncer-v0.15.2-ent.tar
k3s ctr images import images/appscode-csi-driver-cacerts-v0.1.0.tar
k3s ctr images import images/appscode-external-dns-operator-v0.0.8.tar
k3s ctr images import images/appscode-falco-ui-server-v0.0.4.tar
k3s ctr images import images/appscode-fileserver-v0.0.1.tar
k3s ctr images import images/appscode-flux-cli-v2.3.0.tar
k3s ctr images import images/appscode-grafana-tools-v0.3.0.tar
k3s ctr images import images/appscode-grafana-v2025.2.3.tar
k3s ctr images import images/appscode-inbox-agent-v0.0.2.tar
k3s ctr images import images/appscode-inbox-server-postgres-latest.tar
k3s ctr images import images/appscode-inbox-ui-0.0.4.tar
k3s ctr images import images/appscode-k8s-wait-for-v2.0.tar
k3s ctr images import images/appscode-kube-rbac-proxy-v0.11.0.tar
k3s ctr images import images/appscode-kube-rbac-proxy-v0.13.0.tar
k3s ctr images import images/appscode-kube-rbac-proxy-v0.15.0.tar
k3s ctr images import images/appscode-kube-rbac-proxy-v0.18.2.tar
k3s ctr images import images/appscode-kube-ui-server-v0.0.50.tar
k3s ctr images import images/appscode-kubectl-nonroot-1.31.tar
k3s ctr images import images/appscode-kubedb-ui-0.7.13.tar
k3s ctr images import images/appscode-license-proxyserver-v0.0.20.tar
k3s ctr images import images/appscode-maxmind-geoip-city-mmdb-latest.tar
k3s ctr images import images/appscode-openfga-v1.8.5.tar
k3s ctr images import images/appscode-operator-shard-manager-v0.0.1.tar
k3s ctr images import images/appscode-panopticon-v0.0.16.tar
k3s ctr images import images/appscode-petset-v0.0.7.tar
k3s ctr images import images/appscode-platform-ui-0.8.13.tar
k3s ctr images import images/appscode-prom-authproxy-v0.0.1.tar
k3s ctr images import images/appscode-reloader-v1.0.79.tar
k3s ctr images import images/appscode-s3proxy-sha-a82ca68.tar
k3s ctr images import images/appscode-scanner-v0.0.19.tar
k3s ctr images import images/appscode-service-provider-v0.0.1.tar
k3s ctr images import images/appscode-sidekick-v0.0.10.tar
k3s ctr images import images/appscode-supervisor-v0.0.7.tar
k3s ctr images import images/appscode-trickster-v2.0.0-beta3.tar
k3s ctr images import images/appscode-vcluster-plugin-ace-v0.0.3.tar
k3s ctr images import images/external-secrets-external-secrets-v0.9.12.tar
k3s ctr images import images/fluxcd-helm-controller-v1.0.1.tar
k3s ctr images import images/fluxcd-kustomize-controller-v1.3.0.tar
k3s ctr images import images/fluxcd-notification-controller-v1.3.0.tar
k3s ctr images import images/fluxcd-source-controller-v1.3.0.tar
k3s ctr images import images/kedacore-http-add-on-interceptor-0.8.0.tar
k3s ctr images import images/kedacore-http-add-on-operator-0.8.0.tar
k3s ctr images import images/kedacore-http-add-on-scaler-0.8.0.tar
k3s ctr images import images/kedacore-keda-admission-webhooks-2.15.1.tar
k3s ctr images import images/kedacore-keda-metrics-apiserver-2.15.1.tar
k3s ctr images import images/kedacore-keda-2.15.1.tar
k3s ctr images import images/kluster-manager-addon-manager-v0.15.2.tar
k3s ctr images import images/kluster-manager-cluster-auth-v0.3.0.tar
k3s ctr images import images/kluster-manager-cluster-gateway-manager-v1.10.0.tar
k3s ctr images import images/kluster-manager-cluster-gateway-v1.10.0.tar
k3s ctr images import images/kluster-manager-cluster-profile-v0.6.0.tar
k3s ctr images import images/kluster-manager-cluster-proxy-v0.6.0.tar
k3s ctr images import images/kluster-manager-clusteradm-v0.10.0.tar
k3s ctr images import images/kluster-manager-fluxcd-addon-v0.0.6.tar
k3s ctr images import images/kluster-manager-managed-serviceaccount-v0.7.0.tar
k3s ctr images import images/kluster-manager-placement-v0.15.2.tar
k3s ctr images import images/kluster-manager-registration-operator-v0.15.2.tar
k3s ctr images import images/kluster-manager-registration-v0.15.2.tar
k3s ctr images import images/kluster-manager-work-v0.15.2.tar
k3s ctr images import images/kubedb-kubedb-autoscaler-v0.37.0.tar
k3s ctr images import images/kubedb-kubedb-crd-manager-v0.7.0.tar
k3s ctr images import images/kubedb-kubedb-ops-manager-v0.39.0.tar
k3s ctr images import images/kubedb-kubedb-provisioner-v0.52.0.tar
k3s ctr images import images/kubedb-kubedb-schema-manager-v0.28.0.tar
k3s ctr images import images/kubedb-kubedb-ui-server-v0.28.0.tar
k3s ctr images import images/kubedb-kubedb-webhook-server-v0.28.0.tar
k3s ctr images import images/kubedb-pg-coordinator-v0.36.0.tar
k3s ctr images import images/kubedb-postgres-archiver-v0.13.0_16.1-alpine.tar
k3s ctr images import images/kubedb-postgres-init-0.17.1.tar
k3s ctr images import images/kubedb-postgres-restic-plugin-v0.15.0_16.1.tar
k3s ctr images import images/kubedb-redis-coordinator-v0.31.0.tar
k3s ctr images import images/kubedb-redis-init-0.9.0.tar
k3s ctr images import images/kubedb-redis-restic-plugin-v0.15.0.tar
k3s ctr images import images/kubedb-redis_exporter-1.66.0.tar
k3s ctr images import images/kubedb-vcluster-plugin-kubedb-v0.0.1.tar
k3s ctr images import images/kubestash-kubedump-v0.15.0.tar
k3s ctr images import images/kubestash-kubestash-v0.16.0.tar
k3s ctr images import images/kubevault-vault-operator-v0.19.0.tar
k3s ctr images import images/kyverno-background-controller-v1.12.5.tar
k3s ctr images import images/kyverno-cleanup-controller-v1.12.5.tar
k3s ctr images import images/kyverno-kyverno-v1.12.5.tar
k3s ctr images import images/kyverno-kyvernopre-v1.12.5.tar
k3s ctr images import images/kyverno-reports-controller-v1.12.5.tar
k3s ctr images import images/loft-sh-vcluster-oss-0.22.4.tar
k3s ctr images import images/voyagermesh-echoserver-v20221109.tar
k3s ctr images import images/voyagermesh-envoy-v1.31.2-ac.tar
k3s ctr images import images/voyagermesh-gateway-converter-v0.0.1.tar
k3s ctr images import images/voyagermesh-gateway-v1.1.2.tar
k3s ctr images import images/hashicorp-vault-csi-provider-1.4.1.tar
k3s ctr images import images/hashicorp-vault-secrets-operator-0.4.3.tar
k3s ctr images import images/hashicorp-vault-1.15.2.tar
k3s ctr images import images/natsio-nats-boot-config-0.16.1.tar
k3s ctr images import images/natsio-nats-server-config-reloader-0.16.1.tar
k3s ctr images import images/natsio-prometheus-nats-exporter-0.16.0.tar
k3s ctr images import images/openpolicyagent-gatekeeper-v3.13.3.tar
k3s ctr images import images/opensearchproject-opensearch-2.1.0.tar
k3s ctr images import images/prometheuscommunity-postgres-exporter-v0.15.0.tar
k3s ctr images import images/jetstack-cert-manager-acmesolver-v1.15.4.tar
k3s ctr images import images/jetstack-cert-manager-cainjector-v1.15.4.tar
k3s ctr images import images/jetstack-cert-manager-controller-v1.15.4.tar
k3s ctr images import images/jetstack-cert-manager-startupapicheck-v1.15.4.tar
k3s ctr images import images/jetstack-cert-manager-webhook-v1.15.4.tar
k3s ctr images import images/prometheus-operator-prometheus-config-reloader-v0.75.2.tar
k3s ctr images import images/prometheus-operator-prometheus-operator-v0.75.2.tar
k3s ctr images import images/prometheus-alertmanager-v0.27.0.tar
k3s ctr images import images/prometheus-node-exporter-v1.8.2.tar
k3s ctr images import images/prometheus-prometheus-v2.54.0.tar
k3s ctr images import images/thanos-thanos-v0.32.5.tar
k3s ctr images import images/library-rabbitmq-3.12.1-management.tar
k3s ctr images import images/rancher-kine-v0.11.4.tar
k3s ctr images import images/autoscaling-cluster-autoscaler-v1.27.1.tar
k3s ctr images import images/csi-secrets-store-driver-v1.4.1.tar
k3s ctr images import images/ingress-nginx-kube-webhook-certgen-v20221220-controller-v1.5.1-58-g787ea74b6.tar
k3s ctr images import images/kube-apiserver-v1.20.0.tar
k3s ctr images import images/kube-controller-manager-v1.20.0.tar
k3s ctr images import images/kube-state-metrics-kube-state-metrics-v2.13.0.tar
k3s ctr images import images/metrics-server-metrics-server-v0.7.2.tar
k3s ctr images import images/prometheus-adapter-prometheus-adapter-v0.11.2.tar
k3s ctr images import images/sig-storage-csi-node-driver-registrar-v2.10.0.tar
k3s ctr images import images/sig-storage-csi-node-driver-registrar-v2.11.1.tar
k3s ctr images import images/sig-storage-csi-node-driver-registrar-v2.8.0.tar
k3s ctr images import images/sig-storage-csi-provisioner-v4.0.0.tar
k3s ctr images import images/sig-storage-csi-snapshotter-v6.3.3.tar
k3s ctr images import images/sig-storage-livenessprobe-v2.10.0.tar
k3s ctr images import images/sig-storage-livenessprobe-v2.12.0.tar
k3s ctr images import images/sig-storage-livenessprobe-v2.13.1.tar
k3s ctr images import images/sig-storage-nfsplugin-v4.7.0.tar
k3s ctr images import images/sig-storage-snapshot-controller-v8.0.1.tar
k3s ctr images import images/sig-storage-snapshot-validation-webhook-v8.0.1.tar
