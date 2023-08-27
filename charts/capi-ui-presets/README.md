# ACE UI Presets for CAPI

[ACE UI Presets for CAPI by AppsCode](https://github.com/bytebuilders) - ACE UI presets for Monitoring

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/capi-ui-presets --version=v2023.03.23
$ helm upgrade -i capi-ui-presets appscode/capi-ui-presets -n kubeops --create-namespace --version=v2023.03.23
```

## Introduction

This chart deploys ACE UI presets for Monitoring on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `capi-ui-presets`:

```bash
$ helm upgrade -i capi-ui-presets appscode/capi-ui-presets -n kubeops --create-namespace --version=v2023.03.23
```

The command deploys ACE UI presets for Monitoring on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `capi-ui-presets`:

```bash
$ helm uninstall capi-ui-presets -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


