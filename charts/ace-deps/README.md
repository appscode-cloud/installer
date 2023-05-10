# Prerequisites for ACE

[Prerequisites for ACE](https://github.com/bytebuilders/installer) - Prerequisites for ACE

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/ace-deps --version=v2023.03.23
$ helm upgrade -i ace-deps appscode/ace-deps -n kubeops --create-namespace --version=v2023.03.23
```

## Introduction

This chart deploys prerequisite charts for ACE on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `ace-deps`:

```bash
$ helm upgrade -i ace-deps appscode/ace-deps -n kubeops --create-namespace --version=v2023.03.23
```

The command deploys prerequisite charts for ACE on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `ace-deps`:

```bash
$ helm uninstall ace-deps -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `ace-deps` chart and their default values.

|                 Parameter                  | Description |                             Default                             |
|--------------------------------------------|-------------|-----------------------------------------------------------------|
| nameOverride                               |             | <code>""</code>                                                 |
| fullnameOverride                           |             | <code>""</code>                                                 |
| repositories.appscode.interval             |             | <code>30m0s</code>                                              |
| repositories.appscode.url                  |             | <code>https://charts.appscode.com/stable/</code>                |
| repositories.bytebuilders-ui.interval      |             | <code>30m0s</code>                                              |
| repositories.bytebuilders-ui.url           |             | <code>https://bundles.byte.builders/ui/</code>                  |
| repositories.bytebuilders.interval         |             | <code>30m0s</code>                                              |
| repositories.bytebuilders.url              |             | <code>https://charts.appscode.com/stable/</code>                |
| repositories.jetstack.interval             |             | <code>30m0s</code>                                              |
| repositories.jetstack.url                  |             | <code>https://charts.jetstack.io</code>                         |
| repositories.kubedb.interval               |             | <code>30m0s</code>                                              |
| repositories.kubedb.url                    |             | <code>https://charts.appscode.com/stable/</code>                |
| repositories.kubeops.interval              |             | <code>30m0s</code>                                              |
| repositories.kubeops.url                   |             | <code>https://charts.appscode.com/stable/</code>                |
| repositories.kubevault.interval            |             | <code>30m0s</code>                                              |
| repositories.kubevault.url                 |             | <code>https://charts.appscode.com/stable/</code>                |
| repositories.nats.interval                 |             | <code>30m0s</code>                                              |
| repositories.nats.url                      |             | <code>https://nats-io.github.io/k8s/helm/charts/</code>         |
| repositories.prometheus-community.interval |             | <code>30m0s</code>                                              |
| repositories.prometheus-community.url      |             | <code>https://prometheus-community.github.io/helm-charts</code> |
| repositories.stashed.interval              |             | <code>30m0s</code>                                              |
| repositories.stashed.url                   |             | <code>https://charts.appscode.com/stable/</code>                |
| repositories.stakater.interval             |             | <code>30m0s</code>                                              |
| repositories.stakater.url                  |             | <code>https://stakater.github.io/stakater-charts</code>         |
| repositoryCredentials                      |             | <code>{}</code>                                                 |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i ace-deps appscode/ace-deps -n kubeops --create-namespace --version=v2023.03.23 --set repositories.appscode.interval=30m0s
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i ace-deps appscode/ace-deps -n kubeops --create-namespace --version=v2023.03.23 --values values.yaml
```
