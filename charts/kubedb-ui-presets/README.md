# KubeDB UI Presets

[KubeDB UI Presets by AppsCode](https://github.com/appscode-cloud) - KubeDB UI Presets

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/kubedb-ui-presets --version=v2024.10.24
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.10.24
```

## Introduction

This chart deploys KubeDB UI Presets on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `kubedb-ui-presets`:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.10.24
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

|                 Parameter                  |                                             Description                                              |               Default               |
|--------------------------------------------|------------------------------------------------------------------------------------------------------|-------------------------------------|
| deployment.default                         |                                                                                                      | <code>Shared</code>                 |
| deployment.toggle                          |                                                                                                      | <code>true</code>                   |
| clusterTier.default                        |                                                                                                      | <code>"GeneralPurpose"</code>       |
| clusterTier.toggle                         |                                                                                                      | <code>true</code>                   |
| clusterTier.nodeTopology.available         |                                                                                                      | <code>[]</code>                     |
| clusterTier.nodeTopology.default           |                                                                                                      | <code>""</code>                     |
| clusterTier.nodeTopology.toggle            |                                                                                                      | <code>true</code>                   |
| clusterTier.placement.available            |                                                                                                      | <code>[]</code>                     |
| clusterTier.placement.default              |                                                                                                      | <code>""</code>                     |
| clusterTier.placement.toggle               |                                                                                                      | <code>true</code>                   |
| databases.ClickHouse.versions.available    |                                                                                                      | <code>[]</code>                     |
| databases.ClickHouse.versions.default      |                                                                                                      | <code>""</code>                     |
| databases.ClickHouse.versions.toggle       |                                                                                                      | <code>true</code>                   |
| databases.Druid.versions.available         |                                                                                                      | <code>[]</code>                     |
| databases.Druid.versions.default           |                                                                                                      | <code>""</code>                     |
| databases.Druid.versions.toggle            |                                                                                                      | <code>true</code>                   |
| databases.Elasticsearch.versions.available |                                                                                                      | <code>[]</code>                     |
| databases.Elasticsearch.versions.default   |                                                                                                      | <code>""</code>                     |
| databases.Elasticsearch.versions.toggle    |                                                                                                      | <code>true</code>                   |
| databases.FerretDB.versions.available      |                                                                                                      | <code>[]</code>                     |
| databases.FerretDB.versions.default        |                                                                                                      | <code>""</code>                     |
| databases.FerretDB.versions.toggle         |                                                                                                      | <code>true</code>                   |
| databases.Kafka.versions.available         |                                                                                                      | <code>[]</code>                     |
| databases.Kafka.versions.default           |                                                                                                      | <code>""</code>                     |
| databases.Kafka.versions.toggle            |                                                                                                      | <code>true</code>                   |
| databases.MariaDB.versions.available       |                                                                                                      | <code>[]</code>                     |
| databases.MariaDB.versions.default         |                                                                                                      | <code>""</code>                     |
| databases.MariaDB.versions.toggle          |                                                                                                      | <code>true</code>                   |
| databases.Memcached.versions.available     |                                                                                                      | <code>[]</code>                     |
| databases.Memcached.versions.default       |                                                                                                      | <code>""</code>                     |
| databases.Memcached.versions.toggle        |                                                                                                      | <code>true</code>                   |
| databases.MongoDB.versions.available       |                                                                                                      | <code>[]</code>                     |
| databases.MongoDB.versions.default         |                                                                                                      | <code>""</code>                     |
| databases.MongoDB.versions.toggle          |                                                                                                      | <code>true</code>                   |
| databases.MSSQLServer.versions.available   |                                                                                                      | <code>[]</code>                     |
| databases.MSSQLServer.versions.default     |                                                                                                      | <code>""</code>                     |
| databases.MSSQLServer.versions.toggle      |                                                                                                      | <code>true</code>                   |
| databases.MySQL.versions.available         |                                                                                                      | <code>[]</code>                     |
| databases.MySQL.versions.default           |                                                                                                      | <code>""</code>                     |
| databases.MySQL.versions.toggle            |                                                                                                      | <code>true</code>                   |
| databases.PerconaXtraDB.versions.available |                                                                                                      | <code>[]</code>                     |
| databases.PerconaXtraDB.versions.default   |                                                                                                      | <code>""</code>                     |
| databases.PerconaXtraDB.versions.toggle    |                                                                                                      | <code>true</code>                   |
| databases.PgBouncer.versions.available     |                                                                                                      | <code>[]</code>                     |
| databases.PgBouncer.versions.default       |                                                                                                      | <code>""</code>                     |
| databases.PgBouncer.versions.toggle        |                                                                                                      | <code>true</code>                   |
| databases.Pgpool.versions.available        |                                                                                                      | <code>[]</code>                     |
| databases.Pgpool.versions.default          |                                                                                                      | <code>""</code>                     |
| databases.Pgpool.versions.toggle           |                                                                                                      | <code>true</code>                   |
| databases.Postgres.versions.available      |                                                                                                      | <code>[]</code>                     |
| databases.Postgres.versions.default        |                                                                                                      | <code>""</code>                     |
| databases.Postgres.versions.toggle         |                                                                                                      | <code>true</code>                   |
| databases.ProxySQL.versions.available      |                                                                                                      | <code>[]</code>                     |
| databases.ProxySQL.versions.default        |                                                                                                      | <code>""</code>                     |
| databases.ProxySQL.versions.toggle         |                                                                                                      | <code>true</code>                   |
| databases.RabbitMQ.versions.available      |                                                                                                      | <code>[]</code>                     |
| databases.RabbitMQ.versions.default        |                                                                                                      | <code>""</code>                     |
| databases.RabbitMQ.versions.toggle         |                                                                                                      | <code>true</code>                   |
| databases.Redis.versions.available         |                                                                                                      | <code>[]</code>                     |
| databases.Redis.versions.default           |                                                                                                      | <code>""</code>                     |
| databases.Redis.versions.toggle            |                                                                                                      | <code>true</code>                   |
| databases.Singlestore.versions.available   |                                                                                                      | <code>[]</code>                     |
| databases.Singlestore.versions.default     |                                                                                                      | <code>""</code>                     |
| databases.Singlestore.versions.toggle      |                                                                                                      | <code>true</code>                   |
| databases.Solr.versions.available          |                                                                                                      | <code>[]</code>                     |
| databases.Solr.versions.default            |                                                                                                      | <code>""</code>                     |
| databases.Solr.versions.toggle             |                                                                                                      | <code>true</code>                   |
| databases.ZooKeeper.versions.available     |                                                                                                      | <code>[]</code>                     |
| databases.ZooKeeper.versions.default       |                                                                                                      | <code>""</code>                     |
| databases.ZooKeeper.versions.toggle        |                                                                                                      | <code>true</code>                   |
| storageClasses.available                   |                                                                                                      | <code>[]</code>                     |
| storageClasses.default                     |                                                                                                      | <code>""</code>                     |
| storageClasses.toggle                      |                                                                                                      | <code>true</code>                   |
| tls.default                                |                                                                                                      | <code>true</code>                   |
| tls.toggle                                 |                                                                                                      | <code>true</code>                   |
| clusterIssuers.available                   |                                                                                                      | <code>[]</code>                     |
| clusterIssuers.default                     |                                                                                                      | <code>""</code>                     |
| clusterIssuers.toggle                      |                                                                                                      | <code>true</code>                   |
| expose.default                             |                                                                                                      | <code>true</code>                   |
| expose.toggle                              |                                                                                                      | <code>true</code>                   |
| showPreview                                |                                                                                                      | <code>false</code>                  |
| monitoring.agent                           | Name of monitoring agent (one of "prometheus.io", "prometheus.io/operator", "prometheus.io/builtin") | <code>prometheus.io/operator</code> |
| monitoring.exporter.resources              |                                                                                                      | <code>{}</code>                     |
| monitoring.toggle                          |                                                                                                      | <code>true</code>                   |
| alert.toggle                               |                                                                                                      | <code>true</code>                   |
| archiver.toggle                            |                                                                                                      | <code>true</code>                   |
| archiver.default                           |                                                                                                      | <code>true</code>                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.10.24 --set deployment.default=Shared
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.10.24 --values values.yaml
```
