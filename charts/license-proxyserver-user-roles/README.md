# AppsCode License ProxyServer User Roles

[AppsCode License ProxyServer User Roles](https://github.com/appscode-cloud/license-proxyserver) - AppsCode License ProxyServer User Roles

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/license-proxyserver-user-roles --version=v2025.1.17
$ helm upgrade -i license-proxyserver-user-roles appscode/license-proxyserver-user-roles -n kubeops --create-namespace --version=v2025.1.17
```

## Introduction

This chart deploys a AppsCode license proxyserver User Roles on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `license-proxyserver-user-roles`:

```bash
$ helm upgrade -i license-proxyserver-user-roles appscode/license-proxyserver-user-roles -n kubeops --create-namespace --version=v2025.1.17
```

The command deploys a AppsCode license proxyserver User Roles on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `license-proxyserver-user-roles`:

```bash
$ helm uninstall license-proxyserver-user-roles -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `license-proxyserver-user-roles` chart and their default values.

|    Parameter     |             Description             |     Default     |
|------------------|-------------------------------------|-----------------|
| nameOverride     | This is to override the chart name. | <code>""</code> |
| fullnameOverride |                                     | <code>""</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i license-proxyserver-user-roles appscode/license-proxyserver-user-roles -n kubeops --create-namespace --version=v2025.1.17 --set -- generate from values file --
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i license-proxyserver-user-roles appscode/license-proxyserver-user-roles -n kubeops --create-namespace --version=v2025.1.17 --values values.yaml
```
