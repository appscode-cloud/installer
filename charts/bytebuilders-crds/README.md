# ByteBuilders CRDs

[ByteBuilders CRDs](https://github.com/bytebuilders/resource-model) - Resource Models for ByteBuilders

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/bytebuilders-crds --version=v0.1.0
$ helm upgrade -i bytebuilders-crds appscode/bytebuilders-crds -n kube-system --create-namespace --version=v0.1.0
```

## Introduction

This chart deploys ByteBuilders crds on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.16+

## Installing the Chart

To install/upgrade the chart with the release name `bytebuilders-crds`:

```bash
$ helm upgrade -i bytebuilders-crds appscode/bytebuilders-crds -n kube-system --create-namespace --version=v0.1.0
```

The command deploys ByteBuilders crds on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `bytebuilders-crds`:

```bash
$ helm uninstall bytebuilders-crds -n kube-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


