# ByteBuilders Opscenter Configurator

[ByteBuilders Opscenter Configurator by AppsCode](https://github.com/bytebuilders/installer) - ByteBuilders Opscenter Configurator

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/opscenter-features --version=v2023.03.23
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.03.23
```

## Introduction

This chart deploys a ByteBuilders Opscenter Configurator on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.16+

## Installing the Chart

To install/upgrade the chart with the release name `opscenter-features`:

```bash
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.03.23
```

The command deploys a ByteBuilders Opscenter Configurator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `opscenter-features`:

```bash
$ helm uninstall opscenter-features -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `opscenter-features` chart and their default values.

|    Parameter     | Description |     Default     |
|------------------|-------------|-----------------|
| nameOverride     |             | <code>""</code> |
| fullnameOverride |             | <code>""</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.03.23 --set -- generate from values file --
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.03.23 --values values.yaml
```
