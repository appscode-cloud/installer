# Platform Opscenter

[Platform Opscenter by AppsCode](https://github.com/bytebuilders/installer) - Platform Opscenter

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/platform-opscenter --version=v2025.12.15
$ helm upgrade -i platform-opscenter appscode/platform-opscenter -n ace --create-namespace --version=v2025.12.15
```

## Introduction

This chart deploys a Platform Opscenter on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `platform-opscenter`:

```bash
$ helm upgrade -i platform-opscenter appscode/platform-opscenter -n ace --create-namespace --version=v2025.12.15
```

The command deploys a Platform Opscenter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `platform-opscenter`:

```bash
$ helm uninstall platform-opscenter -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `platform-opscenter` chart and their default values.

|              Parameter              |         Description         |                 Default                 |
|-------------------------------------|-----------------------------|-----------------------------------------|
| nameOverride                        | Overrides name template     | <code>""</code>                         |
| fullnameOverride                    | Overrides fullname template | <code>""</code>                         |
| platform-grafana-dashboards.enabled |                             | <code>true</code>                       |
| openfga-alerts.enabled              |                             | <code>true</code>                       |
| openfga-alerts.grafana.jobName      |                             | <code>openfga</code>                    |
| nats-alerts.enabled                 |                             | <code>true</code>                       |
| nats-alerts.grafana.jobName         |                             | <code>"{{ .Release.name }}-nats"</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i platform-opscenter appscode/platform-opscenter -n ace --create-namespace --version=v2025.12.15 --set openfga-alerts.grafana.jobName=openfga
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i platform-opscenter appscode/platform-opscenter -n ace --create-namespace --version=v2025.12.15 --values values.yaml
```
