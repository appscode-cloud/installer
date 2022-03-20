# ByteBuilders Opscenter

[ByteBuilders Opscenter Core by AppsCode](https://github.com/kubedb) - ByteBuilders Opscenter Core

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/opscenter-core --version=v2022.03.07
$ helm upgrade -i opscenter-core appscode/opscenter-core -n kubeops --create-namespace --version=v2022.03.07
```

## Introduction

This chart deploys a ByteBuilders Opscenter on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.16+

## Installing the Chart

To install/upgrade the chart with the release name `opscenter-core`:

```bash
$ helm upgrade -i opscenter-core appscode/opscenter-core -n kubeops --create-namespace --version=v2022.03.07
```

The command deploys a ByteBuilders Opscenter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `opscenter-core`:

```bash
$ helm uninstall opscenter-core -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `opscenter-core` chart and their default values.

|            Parameter            | Description |      Default      |
|---------------------------------|-------------|-------------------|
| kube-ui-server.enabled          |             | <code>true</code> |
| panopticon.enabled              |             | <code>true</code> |
| grafana-operator.enabled        |             | <code>true</code> |
| grafana-ui-server.enabled       |             | <code>true</code> |
| kube-grafana-dashboards.enabled |             | <code>true</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i opscenter-core appscode/opscenter-core -n kubeops --create-namespace --version=v2022.03.07 --set -- generate from values file --
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i opscenter-core appscode/opscenter-core -n kubeops --create-namespace --version=v2022.03.07 --values values.yaml
```
