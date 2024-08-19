# KubeDB UI Presets

[KubeDB UI Presets by AppsCode](https://github.com/appscode-cloud) - KubeDB UI Presets

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/kubedb-ui-presets --version=v2024.7.4
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.7.4
```

## Introduction

This chart deploys KubeDB UI Presets on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `kubedb-ui-presets`:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.7.4
```

The command deploys KubeDB UI Presets on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `kubedb-ui-presets`:

```bash
$ helm uninstall kubedb-ui-presets -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `kubedb-ui-presets` chart and their default values.

|                  Parameter                  |                                                                                Description                                                                                |                          Default                          |
|---------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|
| deployment.default                          |                                                                                                                                                                           | <code>Dedicated</code>                                    |
| deployment.toggle                           |                                                                                                                                                                           | <code>true</code>                                         |
| clusterTier.default                         |                                                                                                                                                                           | <code>"GeneralPurpose"</code>                             |
| clusterTier.toggle                          |                                                                                                                                                                           | <code>true</code>                                         |
| clusterTier.nodeTopology.default            |                                                                                                                                                                           | <code>"standard-bsv2-family"</code>                       |
| clusterTier.nodeTopology.toggle             |                                                                                                                                                                           | <code>true</code>                                         |
| clusterTier.placement.default               |                                                                                                                                                                           | <code>"default"</code>                                    |
| clusterTier.placement.toggle                |                                                                                                                                                                           | <code>true</code>                                         |
| databases.ClickHouse.versions.default       |                                                                                                                                                                           | <code>"24.4.1"</code>                                     |
| databases.ClickHouse.versions.toggle        |                                                                                                                                                                           | <code>true</code>                                         |
| databases.Druid.versions.default            |                                                                                                                                                                           | <code>"28.0.1"</code>                                     |
| databases.Druid.versions.toggle             |                                                                                                                                                                           | <code>true</code>                                         |
| databases.Elasticsearch.versions.default    |                                                                                                                                                                           | <code>"xpack-8.6.2"</code>                                |
| databases.Elasticsearch.versions.toggle     |                                                                                                                                                                           | <code>true</code>                                         |
| databases.FerretDB.versions.default         |                                                                                                                                                                           | <code>"1.18.0"</code>                                     |
| databases.FerretDB.versions.toggle          |                                                                                                                                                                           | <code>true</code>                                         |
| databases.Kafka.versions.default            |                                                                                                                                                                           | <code>"3.5.2"</code>                                      |
| databases.Kafka.versions.toggle             |                                                                                                                                                                           | <code>true</code>                                         |
| databases.MariaDB.versions.default          |                                                                                                                                                                           | <code>"10.6.16"</code>                                    |
| databases.MariaDB.versions.toggle           |                                                                                                                                                                           | <code>true</code>                                         |
| databases.Memcached.versions.default        |                                                                                                                                                                           | <code>"1.6.22"</code>                                     |
| databases.Memcached.versions.toggle         |                                                                                                                                                                           | <code>true</code>                                         |
| databases.MongoDB.versions.default          |                                                                                                                                                                           | <code>"6.0.12"</code>                                     |
| databases.MongoDB.versions.toggle           |                                                                                                                                                                           | <code>true</code>                                         |
| databases.MSSQLServer.versions.default      |                                                                                                                                                                           | <code>"2022-cu12"</code>                                  |
| databases.MSSQLServer.versions.toggle       |                                                                                                                                                                           | <code>true</code>                                         |
| databases.MySQL.versions.default            |                                                                                                                                                                           | <code>"8.0.35"</code>                                     |
| databases.MySQL.versions.toggle             |                                                                                                                                                                           | <code>true</code>                                         |
| databases.PerconaXtraDB.versions.default    |                                                                                                                                                                           | <code>"8.0.31"</code>                                     |
| databases.PerconaXtraDB.versions.toggle     |                                                                                                                                                                           | <code>true</code>                                         |
| databases.PgBouncer.versions.default        |                                                                                                                                                                           | <code>"1.18.0"</code>                                     |
| databases.PgBouncer.versions.toggle         |                                                                                                                                                                           | <code>true</code>                                         |
| databases.Pgpool.versions.default           |                                                                                                                                                                           | <code>"4.4.5"</code>                                      |
| databases.Pgpool.versions.toggle            |                                                                                                                                                                           | <code>true</code>                                         |
| databases.Postgres.versions.default         |                                                                                                                                                                           | <code>"15.5"</code>                                       |
| databases.Postgres.versions.toggle          |                                                                                                                                                                           | <code>true</code>                                         |
| databases.ProxySQL.versions.default         |                                                                                                                                                                           | <code>"2.3.2-debian"</code>                               |
| databases.ProxySQL.versions.toggle          |                                                                                                                                                                           | <code>true</code>                                         |
| databases.RabbitMQ.versions.default         |                                                                                                                                                                           | <code>"3.13.2"</code>                                     |
| databases.RabbitMQ.versions.toggle          |                                                                                                                                                                           | <code>true</code>                                         |
| databases.Redis.versions.default            |                                                                                                                                                                           | <code>"7.0.15"</code>                                     |
| databases.Redis.versions.toggle             |                                                                                                                                                                           | <code>true</code>                                         |
| databases.Singlestore.versions.default      |                                                                                                                                                                           | <code>"8.1.32"</code>                                     |
| databases.Singlestore.versions.toggle       |                                                                                                                                                                           | <code>true</code>                                         |
| databases.Solr.versions.default             |                                                                                                                                                                           | <code>"8.11.2"</code>                                     |
| databases.Solr.versions.toggle              |                                                                                                                                                                           | <code>true</code>                                         |
| databases.ZooKeeper.versions.default        |                                                                                                                                                                           | <code>"3.8.3"</code>                                      |
| databases.ZooKeeper.versions.toggle         |                                                                                                                                                                           | <code>true</code>                                         |
| storageClasses.default                      |                                                                                                                                                                           | <code>"default"</code>                                    |
| storageClasses.toggle                       |                                                                                                                                                                           | <code>true</code>                                         |
| tls.default                                 |                                                                                                                                                                           | <code>true</code>                                         |
| tls.toggle                                  |                                                                                                                                                                           | <code>true</code>                                         |
| clusterIssuers.default                      |                                                                                                                                                                           | <code>"cluster-issuer"</code>                             |
| clusterIssuers.toggle                       |                                                                                                                                                                           | <code>true</code>                                         |
| webUI.default                               |                                                                                                                                                                           | <code>true</code>                                         |
| webUI.toggle                                |                                                                                                                                                                           | <code>true</code>                                         |
| monitoring.agent                            | Name of monitoring agent (one of "prometheus.io", "prometheus.io/operator", "prometheus.io/builtin")                                                                      | <code>prometheus.io/operator</code>                       |
| monitoring.exporter.resources               |                                                                                                                                                                           | <code>{"requests":{"cpu":"100m","memory":"128Mi"}}</code> |
| monitoring.serviceMonitor.labels            | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/webhook server`. | <code>{}</code>                                           |
| monitoring.toggle                           |                                                                                                                                                                           | <code>true</code>                                         |
| alerts.toggle                               |                                                                                                                                                                           | <code>true</code>                                         |
| archiver.toggle                             |                                                                                                                                                                           | <code>true</code>                                         |
| archiver.default                            |                                                                                                                                                                           | <code>true</code>                                         |
| backup.tool                                 |                                                                                                                                                                           | <code>KubeStash</code>                                    |
| backup.toggle                               |                                                                                                                                                                           | <code>true</code>                                         |
| backup.kubestash.schedule                   |                                                                                                                                                                           | <code>"0 */2 * * *"</code>                                |
| backup.kubestash.storageRef.name            |                                                                                                                                                                           | <code>default</code>                                      |
| backup.kubestash.storageRef.namespace       |                                                                                                                                                                           | <code>stash</code>                                        |
| backup.kubestash.retentionPolicy.name       |                                                                                                                                                                           | <code>"keep-1mo"</code>                                   |
| backup.kubestash.retentionPolicy.namespace  |                                                                                                                                                                           | <code>stash</code>                                        |
| backup.kubestash.encryptionSecret.name      |                                                                                                                                                                           | <code>default-encryption-secret</code>                    |
| backup.kubestash.encryptionSecret.namespace |                                                                                                                                                                           | <code>stash</code>                                        |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.7.4 --set deployment.default=Dedicated
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.7.4 --values values.yaml
```
