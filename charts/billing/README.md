# Billing Backend

[Billing Backend by AppsCode](https://github.com/bytebuilders) - ByteBuilders Billing Backend

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/billing --version=v2023.03.23
$ helm upgrade -i billing appscode/billing -n ace-system --create-namespace --version=v2023.03.23
```

## Introduction

This chart deploys a billing backend on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `billing`:

```bash
$ helm upgrade -i billing appscode/billing -n ace-system --create-namespace --version=v2023.03.23
```

The command deploys a billing backend on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `billing`:

```bash
$ helm uninstall billing -n ace-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `billing` chart and their default values.

|             Parameter              |                                                                             Description                                                                             |           Default            |
|------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| replicaCount                       |                                                                                                                                                                     | <code>3</code>               |
| registryFQDN                       | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                | <code>ghcr.io</code>         |
| image.registry                     | Docker registry used to pull app container image                                                                                                                    | <code>appscode</code>        |
| image.repository                   | App container image                                                                                                                                                 | <code>b3</code>              |
| image.tag                          | Overrides the image tag whose default is the chart appVersion.                                                                                                      | <code>""</code>              |
| image.pullPolicy                   |                                                                                                                                                                     | <code>Always</code>          |
| imagePullSecrets                   |                                                                                                                                                                     | <code>[]</code>              |
| nameOverride                       |                                                                                                                                                                     | <code>""</code>              |
| fullnameOverride                   |                                                                                                                                                                     | <code>""</code>              |
| serviceAccount.name                |                                                                                                                                                                     | <code>""</code>              |
| podAnnotations                     |                                                                                                                                                                     | <code>{}</code>              |
| podSecurityContext                 |                                                                                                                                                                     | <code>{}</code>              |
| securityContext                    |                                                                                                                                                                     | <code>{}</code>              |
| service.type                       |                                                                                                                                                                     | <code>ClusterIP</code>       |
| service.port                       |                                                                                                                                                                     | <code>80</code>              |
| resources                          |                                                                                                                                                                     | <code>{}</code>              |
| nodeSelector                       |                                                                                                                                                                     | <code>{}</code>              |
| tolerations                        |                                                                                                                                                                     | <code>[]</code>              |
| affinity                           |                                                                                                                                                                     | <code>{}</code>              |
| monitoring.agent                   | Name of monitoring agent (eg "prometheus.io/operator")                                                                                                              | <code>""</code>              |
| monitoring.serviceMonitor.labels   | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/operator`. | <code>{}</code>              |
| summary.schedule                   |                                                                                                                                                                     | <code>"0 8 */1 */1 *"</code> |
| persistence.size                   |                                                                                                                                                                     | <code>10Gi</code>            |
| infra.storageClass.name            |                                                                                                                                                                     | <code>"standard"</code>      |
| infra.objstore.provider            |                                                                                                                                                                     | <code>""</code>              |
| infra.objstore.mountPath           |                                                                                                                                                                     | <code>""</code>              |
| infra.badger.mountPath             |                                                                                                                                                                     | <code>/badger</code>         |
| infra.invoice.mountPath            |                                                                                                                                                                     | <code>/billing</code>        |
| settings.caProviderClass           |                                                                                                                                                                     | <code>""</code>              |
| settings.secretName.platformConfig |                                                                                                                                                                     | <code>""</code>              |
| settings.secretName.grafanaConfig  |                                                                                                                                                                     | <code>""</code>              |
| settings.secretName.objstore       |                                                                                                                                                                     | <code>""</code>              |
| settings.secretName.nats           |                                                                                                                                                                     | <code>""</code>              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i billing appscode/billing -n ace-system --create-namespace --version=v2023.03.23 --set replicaCount=3
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i billing appscode/billing -n ace-system --create-namespace --version=v2023.03.23 --values values.yaml
```
