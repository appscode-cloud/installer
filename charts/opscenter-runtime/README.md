# KubeDB Opscenter

[KubeDB Opscenter by AppsCode](https://github.com/kubedb) - KubeDB Opscenter

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/opscenter-runtime --version=v2022.02.08
$ helm upgrade -i opscenter-runtime appscode/opscenter-runtime -n kubeops --create-namespace --version=v2022.02.08
```

## Introduction

This chart deploys a KubeDB Opscenter on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.16+

## Installing the Chart

To install/upgrade the chart with the release name `opscenter-runtime`:

```bash
$ helm upgrade -i opscenter-runtime appscode/opscenter-runtime -n kubeops --create-namespace --version=v2022.02.08
```

The command deploys a KubeDB Opscenter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `opscenter-runtime`:

```bash
$ helm uninstall opscenter-runtime -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `opscenter-runtime` chart and their default values.

|          Parameter           | Description |      Default      |
|------------------------------|-------------|-------------------|
| kube-ui-server.enabled       |             | <code>true</code> |
| panopticon.enabled           |             | <code>true</code> |
| grafana-operator.enabled     |             | <code>true</code> |
| grafana-ui-server.enabled    |             | <code>true</code> |
| grafana-configurator.enabled |             | <code>true</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i opscenter-runtime appscode/opscenter-runtime -n kubeops --create-namespace --version=v2022.02.08 --set -- generate from values file --
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i opscenter-runtime appscode/opscenter-runtime -n kubeops --create-namespace --version=v2022.02.08 --values values.yaml
```
