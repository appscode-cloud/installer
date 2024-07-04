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

|    Parameter     | Description |     Default     |
|------------------|-------------|-----------------|
| capi.provider    |             | <code>""</code> |
| capi.namespace   |             | <code>""</code> |
| capi.clusterName |             | <code>""</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.7.4 --set -- generate from values file --
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i kubedb-ui-presets appscode/kubedb-ui-presets -n kubeops --create-namespace --version=v2024.7.4 --values values.yaml
```
