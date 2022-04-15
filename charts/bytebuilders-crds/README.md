# ByteBuilders CRDs

[ByteBuilders CRDs](https://github.com/bytebuilders/resource-model) - Resource Models for ByteBuilders

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/bytebuilders-crds --version=v2022.04.14
$ helm upgrade -i bytebuilders-crds appscode/bytebuilders-crds -n kube-system --create-namespace --version=v2022.04.14
```

## Introduction

This chart deploys ByteBuilders crds on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.16+

## Installing the Chart

To install/upgrade the chart with the release name `bytebuilders-crds`:

```bash
$ helm upgrade -i bytebuilders-crds appscode/bytebuilders-crds -n kube-system --create-namespace --version=v2022.04.14
```

The command deploys ByteBuilders crds on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `bytebuilders-crds`:

```bash
$ helm uninstall bytebuilders-crds -n kube-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `bytebuilders-crds` chart and their default values.

|  Parameter   | Description |         Default          |
|--------------|-------------|--------------------------|
| operator.tag |             | <code>v2022.03.20</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i bytebuilders-crds appscode/bytebuilders-crds -n kube-system --create-namespace --version=v2022.04.14 --set operator.tag=v2022.03.20
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i bytebuilders-crds appscode/bytebuilders-crds -n kube-system --create-namespace --version=v2022.04.14 --values values.yaml
```
