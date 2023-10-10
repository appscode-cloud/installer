# KubeStash Presets

[KubeStash Presets by AppsCode](https://github.com/kubestash) - KubeStash Presets

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/kubestash-presets --version=v2023.10.1
$ helm upgrade -i kubestash-presets appscode/kubestash-presets -n kubeops --create-namespace --version=v2023.10.1
```

## Introduction

This chart deploys KubeStash Presets on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `kubestash-presets`:

```bash
$ helm upgrade -i kubestash-presets appscode/kubestash-presets -n kubeops --create-namespace --version=v2023.10.1
```

The command deploys KubeStash Presets on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `kubestash-presets`:

```bash
$ helm uninstall kubestash-presets -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `kubestash-presets` chart and their default values.

|                         Parameter                          | Description |                 Default                 |
|------------------------------------------------------------|-------------|-----------------------------------------|
| kubestash.schedule                                         |             | <code>"0 */2 * * *"</code>              |
| kubestash.retentionPolicy.name                             |             | <code>keep-last-30d</code>              |
| kubestash.retentionPolicy.keepHourly                       |             | <code>24</code>                         |
| kubestash.retentionPolicy.keepDaily                        |             | <code>30</code>                         |
| kubestash.retentionPolicy.prune                            |             | <code>true</code>                       |
| kubestash.authSecret.name                                  |             | <code>""</code>                         |
| kubestash.authSecret.password                              |             | <code>""</code>                         |
| kubestash.backend.provider                                 |             | <code>"" # s3,gcs,azure,swift,b2</code> |
| kubestash.backend.s3.spec.endpoint                         |             | <code>""</code>                         |
| kubestash.backend.s3.spec.bucket                           |             | <code>""</code>                         |
| kubestash.backend.s3.auth.AWS_ACCESS_KEY_ID                |             | <code>""</code>                         |
| kubestash.backend.s3.auth.AWS_SECRET_ACCESS_KEY            |             | <code>""</code>                         |
| kubestash.backend.azure.spec.container                     |             | <code>""</code>                         |
| kubestash.backend.azure.auth.AZURE_ACCOUNT_NAME            |             | <code>""</code>                         |
| kubestash.backend.azure.auth.AZURE_ACCOUNT_KEY             |             | <code>""</code>                         |
| kubestash.backend.gcs.spec.bucket                          |             | <code>""</code>                         |
| kubestash.backend.gcs.auth.GOOGLE_PROJECT_ID               |             | <code>""</code>                         |
| kubestash.backend.gcs.auth.GOOGLE_SERVICE_ACCOUNT_JSON_KEY |             | <code>""</code>                         |
| kubestash.backend.swift.spec.container                     |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_USERNAME                   |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_PASSWORD                   |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_REGION_NAME                |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_AUTH_URL                   |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_USER_DOMAIN_NAME           |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_PROJECT_NAME               |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_PROJECT_DOMAIN_NAME        |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_TENANT_ID                  |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_TENANT_NAME                |             | <code>""</code>                         |
| kubestash.backend.swift.auth.ST_AUTH                       |             | <code>""</code>                         |
| kubestash.backend.swift.auth.ST_USER                       |             | <code>""</code>                         |
| kubestash.backend.swift.auth.ST_KEY                        |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_STORAGE_URL                |             | <code>""</code>                         |
| kubestash.backend.swift.auth.OS_AUTH_TOKEN                 |             | <code>""</code>                         |
| kubestash.backend.b2.spec.bucket                           |             | <code>""</code>                         |
| kubestash.backend.b2.auth.B2_ACCOUNT_ID                    |             | <code>""</code>                         |
| kubestash.backend.b2.auth.B2_ACCOUNT_KEY                   |             | <code>""</code>                         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i kubestash-presets appscode/kubestash-presets -n kubeops --create-namespace --version=v2023.10.1 --set kubestash.schedule="0 */2 * * *"
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i kubestash-presets appscode/kubestash-presets -n kubeops --create-namespace --version=v2023.10.1 --values values.yaml
```
