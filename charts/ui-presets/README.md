# ACE UI Presets

[ACE UI Presets by AppsCode](https://github.com/bytebuilders) - ACE UI presets

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/ui-presets --version=v2022.06.14
$ helm upgrade -i ui-presets appscode/ui-presets -n kubeops --create-namespace --version=v2022.06.14
```

## Introduction

This chart deploys ACE UI presets on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install/upgrade the chart with the release name `ui-presets`:

```bash
$ helm upgrade -i ui-presets appscode/ui-presets -n kubeops --create-namespace --version=v2022.06.14
```

The command deploys ACE UI presets on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `ui-presets`:

```bash
$ helm uninstall ui-presets -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `ui-presets` chart and their default values.

|            Parameter             |                                                                                Description                                                                                |     Default     |
|----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| monitoring.serviceMonitor.labels | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/webhook server`. | <code>{}</code> |
| form.alert.labels                | # Labels for default rules                                                                                                                                                | <code>{}</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i ui-presets appscode/ui-presets -n kubeops --create-namespace --version=v2022.06.14 --set -- generate from values file --
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i ui-presets appscode/ui-presets -n kubeops --create-namespace --version=v2022.06.14 --values values.yaml
```
