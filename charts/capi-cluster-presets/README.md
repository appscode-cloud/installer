# ACE UI Presets for CAPI

[ACE UI Presets for CAPI by AppsCode](https://github.com/bytebuilders) - ACE UI presets for Monitoring

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/capi-cluster-presets --version=v2023.10.18
$ helm upgrade -i capi-cluster-presets appscode/capi-cluster-presets -n kubeops --create-namespace --version=v2023.10.18
```

## Introduction

This chart deploys ACE UI presets for Monitoring on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `capi-cluster-presets`:

```bash
$ helm upgrade -i capi-cluster-presets appscode/capi-cluster-presets -n kubeops --create-namespace --version=v2023.10.18
```

The command deploys ACE UI presets for Monitoring on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `capi-cluster-presets`:

```bash
$ helm uninstall capi-cluster-presets -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `capi-cluster-presets` chart and their default values.

|    Parameter     | Description |     Default     |
|------------------|-------------|-----------------|
| capi.provider    |             | <code>""</code> |
| capi.namespace   |             | <code>""</code> |
| capi.clusterName |             | <code>""</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i capi-cluster-presets appscode/capi-cluster-presets -n kubeops --create-namespace --version=v2023.10.18 --set -- generate from values file --
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i capi-cluster-presets appscode/capi-cluster-presets -n kubeops --create-namespace --version=v2023.10.18 --values values.yaml
```
