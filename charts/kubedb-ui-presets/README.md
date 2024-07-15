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

|                           Parameter                           |                                                                                Description                                                                                |                          Default                          |
|---------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|
| deployment.default                                            |                                                                                                                                                                           | <code>Dedicated</code>                                    |
| deployment.toggle                                             |                                                                                                                                                                           | <code>true</code>                                         |
| clusterTier.default                                           |                                                                                                                                                                           | <code>"GeneralPurpose"</code>                             |
| clusterTier.toggle                                            |                                                                                                                                                                           | <code>true</code>                                         |
| clusterTier.nodeTopology.default                              |                                                                                                                                                                           | <code>"standard-basv2-family"</code>                      |
| clusterTier.nodeTopology.toggle                               |                                                                                                                                                                           | <code>true</code>                                         |
| clusterTier.capacity.default                                  |                                                                                                                                                                           | <code>"on-demand"</code>                                  |
| clusterTier.capacity.toggle                                   |                                                                                                                                                                           | <code>true</code>                                         |
| storageClasses.default                                        |                                                                                                                                                                           | <code>"default"</code>                                    |
| storageClasses.toggle                                         |                                                                                                                                                                           | <code>true</code>                                         |
| tls.default                                                   |                                                                                                                                                                           | <code>true</code>                                         |
| tls.toggle                                                    |                                                                                                                                                                           | <code>true</code>                                         |
| clusterIssuers.default                                        |                                                                                                                                                                           | <code>"cluster-issuer"</code>                             |
| clusterIssuers.toggle                                         |                                                                                                                                                                           | <code>true</code>                                         |
| webUI.default                                                 |                                                                                                                                                                           | <code>true</code>                                         |
| webUI.toggle                                                  |                                                                                                                                                                           | <code>true</code>                                         |
| monitoring.agent                                              | Name of monitoring agent (one of "prometheus.io", "prometheus.io/operator", "prometheus.io/builtin")                                                                      | <code>prometheus.io/operator</code>                       |
| monitoring.exporter.resources                                 |                                                                                                                                                                           | <code>{"requests":{"cpu":"100m","memory":"128Mi"}}</code> |
| monitoring.serviceMonitor.labels                              | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/webhook server`. | <code>{}</code>                                           |
| monitoring.toggle                                             |                                                                                                                                                                           | <code>true</code>                                         |
| alerts.toggle                                                 |                                                                                                                                                                           | <code>true</code>                                         |
| archiver.toggle                                               |                                                                                                                                                                           | <code>true</code>                                         |
| archiver.default                                              |                                                                                                                                                                           | <code>true</code>                                         |
| backup.tool                                                   |                                                                                                                                                                           | <code>""</code>                                           |
| backup.toggle                                                 |                                                                                                                                                                           | <code>true</code>                                         |
| backup.kubestash.schedule                                     |                                                                                                                                                                           | <code>"0 */2 * * *"</code>                                |
| backup.kubestash.storageRef.name                              |                                                                                                                                                                           | <code>default</code>                                      |
| backup.kubestash.storageRef.namespace                         |                                                                                                                                                                           | <code>stash</code>                                        |
| backup.kubestash.retentionPolicy.name                         |                                                                                                                                                                           | <code>"keep-1mo"</code>                                   |
| backup.kubestash.retentionPolicy.namespace                    |                                                                                                                                                                           | <code>stash</code>                                        |
| backup.kubestash.encryptionSecret.name                        |                                                                                                                                                                           | <code>default-encryption-secret</code>                    |
| backup.kubestash.encryptionSecret.namespace                   |                                                                                                                                                                           | <code>stash</code>                                        |
| backup.kubestash.storageSecret.create                         |                                                                                                                                                                           | <code>true</code>                                         |
| backup.stash.schedule                                         |                                                                                                                                                                           | <code>"0 */2 * * *"</code>                                |
| backup.stash.retentionPolicy.name                             |                                                                                                                                                                           | <code>keep-last-30d</code>                                |
| backup.stash.retentionPolicy.keepHourly                       |                                                                                                                                                                           | <code>24</code>                                           |
| backup.stash.retentionPolicy.keepDaily                        |                                                                                                                                                                           | <code>30</code>                                           |
| backup.stash.retentionPolicy.prune                            |                                                                                                                                                                           | <code>true</code>                                         |
| backup.stash.authSecret.name                                  |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.authSecret.password                              |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.provider                                 |                                                                                                                                                                           | <code>"" # s3,gcs,azure,swift,b2</code>                   |
| backup.stash.backend.s3.spec.endpoint                         |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.s3.spec.bucket                           |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.s3.auth.AWS_ACCESS_KEY_ID                |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.s3.auth.AWS_SECRET_ACCESS_KEY            |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.s3.auth.CA_CERT_DATA                     |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.azure.spec.container                     |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.azure.auth.AZURE_ACCOUNT_NAME            |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.azure.auth.AZURE_ACCOUNT_KEY             |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.gcs.spec.bucket                          |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.gcs.auth.GOOGLE_PROJECT_ID               |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.gcs.auth.GOOGLE_SERVICE_ACCOUNT_JSON_KEY |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.spec.container                     |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_USERNAME                   |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_PASSWORD                   |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_REGION_NAME                |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_AUTH_URL                   |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_USER_DOMAIN_NAME           |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_PROJECT_NAME               |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_PROJECT_DOMAIN_NAME        |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_TENANT_ID                  |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_TENANT_NAME                |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.ST_AUTH                       |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.ST_USER                       |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.ST_KEY                        |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_STORAGE_URL                |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.swift.auth.OS_AUTH_TOKEN                 |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.b2.spec.bucket                           |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.b2.auth.B2_ACCOUNT_ID                    |                                                                                                                                                                           | <code>""</code>                                           |
| backup.stash.backend.b2.auth.B2_ACCOUNT_KEY                   |                                                                                                                                                                           | <code>""</code>                                           |
| databases.MongoDB.versions.default                            |                                                                                                                                                                           | <code>"6.0.12"</code>                                     |
| databases.MongoDB.versions.toggle                             |                                                                                                                                                                           | <code>true</code>                                         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.7.4 --set deployment.default=Dedicated
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.7.4 --values values.yaml
```
