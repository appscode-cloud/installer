# Stash Presets

[Stash Presets by AppsCode](https://github.com/stashed) - Stash Presets

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/stash-presets --version=v2025.10.17
$ helm upgrade -i stash-presets appscode/stash-presets -n kubeops --create-namespace --version=v2025.10.17
```

## Introduction

This chart deploys Stash Presets on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `stash-presets`:

```bash
$ helm upgrade -i stash-presets appscode/stash-presets -n kubeops --create-namespace --version=v2025.10.17
```

The command deploys Stash Presets on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `stash-presets`:

```bash
$ helm uninstall stash-presets -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `stash-presets` chart and their default values.

|                         Parameter                          | Description |            Default             |
|------------------------------------------------------------|-------------|--------------------------------|
| tool                                                       |             | <code>KubeStash # Stash</code> |
| clusterMetadata.uid                                        |             | <code>""</code>                |
| clusterMetadata.name                                       |             | <code>""</code>                |
| kubestash.schedule                                         |             | <code>"0 */2 * * *"</code>     |
| kubestash.retentionPolicy                                  |             | <code>keep-1mo</code>          |
| kubestash.encryptionSecret                                 |             | <code>""</code>                |
| kubestash.storageSecret.create                             |             | <code>true</code>              |
| kubestash.backend.provider                                 |             | <code>s3 # s3,gcs,azure</code> |
| kubestash.backend.s3.spec.endpoint                         |             | <code>""</code>                |
| kubestash.backend.s3.spec.bucket                           |             | <code>""</code>                |
| kubestash.backend.s3.auth.AWS_ACCESS_KEY_ID                |             | <code>""</code>                |
| kubestash.backend.s3.auth.AWS_SECRET_ACCESS_KEY            |             | <code>""</code>                |
| kubestash.backend.azure.spec.container                     |             | <code>""</code>                |
| kubestash.backend.azure.auth.AZURE_ACCOUNT_NAME            |             | <code>""</code>                |
| kubestash.backend.azure.auth.AZURE_ACCOUNT_KEY             |             | <code>""</code>                |
| kubestash.backend.gcs.spec.bucket                          |             | <code>""</code>                |
| kubestash.backend.gcs.auth.GOOGLE_PROJECT_ID               |             | <code>""</code>                |
| kubestash.backend.gcs.auth.GOOGLE_SERVICE_ACCOUNT_JSON_KEY |             | <code>""</code>                |
| kubestash.backend.local.persistentVolumeClaim.claimName    |             | <code>""</code>                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i stash-presets appscode/stash-presets -n kubeops --create-namespace --version=v2025.10.17 --set tool=KubeStash # Stash
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i stash-presets appscode/stash-presets -n kubeops --create-namespace --version=v2025.10.17 --values values.yaml
```
