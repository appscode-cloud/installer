# ACE UI Presets for Monitoring

[ACE UI Presets for Monitoring by AppsCode](https://github.com/bytebuilders) - ACE UI presets for Monitoring

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/monitoring-ui-presets --version=v2023.03.23
$ helm upgrade -i monitoring-ui-presets appscode/monitoring-ui-presets -n kubeops --create-namespace --version=v2023.03.23
```

## Introduction

This chart deploys ACE UI presets for Monitoring on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `monitoring-ui-presets`:

```bash
$ helm upgrade -i monitoring-ui-presets appscode/monitoring-ui-presets -n kubeops --create-namespace --version=v2023.03.23
```

The command deploys ACE UI presets for Monitoring on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `monitoring-ui-presets`:

```bash
$ helm uninstall monitoring-ui-presets -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `monitoring-ui-presets` chart and their default values.

|            Parameter             |                                                                                Description                                                                                |       Default        |
|----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------|
| monitoring.serviceMonitor.labels | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/webhook server`. | <code>{}</code>      |
| monitoring.alert.enabled         | Enable PrometheusRule alerts                                                                                                                                              | <code>warning</code> |
| monitoring.alert.labels          | Labels for default rules                                                                                                                                                  | <code>{}</code>      |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i monitoring-ui-presets appscode/monitoring-ui-presets -n kubeops --create-namespace --version=v2023.03.23 --set monitoring.alert.enabled=warning
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i monitoring-ui-presets appscode/monitoring-ui-presets -n kubeops --create-namespace --version=v2023.03.23 --values values.yaml
```
