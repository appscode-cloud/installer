# ByteBuilders Opscenter Monitoring Configurator

[ByteBuilders Opscenter Monitoring Configurator by AppsCode](https://github.com/bytebuilders/installer) - ByteBuilders Opscenter Monitoring Configurator

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/monitoring-config --version=v2022.06.14
$ helm upgrade -i monitoring-config appscode/monitoring-config -n kubeops --create-namespace --version=v2022.06.14
```

## Introduction

This chart deploys a ByteBuilders Opscenter Monitoring Configurator on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.16+

## Installing the Chart

To install/upgrade the chart with the release name `monitoring-config`:

```bash
$ helm upgrade -i monitoring-config appscode/monitoring-config -n kubeops --create-namespace --version=v2022.06.14
```

The command deploys a ByteBuilders Opscenter Monitoring Configurator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `monitoring-config`:

```bash
$ helm uninstall monitoring-config -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `monitoring-config` chart and their default values.

|              Parameter               |                                 Description                                 |        Default         |
|--------------------------------------|-----------------------------------------------------------------------------|------------------------|
| nameOverride                         |                                                                             | <code>""</code>        |
| fullnameOverride                     |                                                                             | <code>opscenter</code> |
| grafana.default                      |                                                                             | <code>false</code>     |
| grafana.url                          |                                                                             | <code>""</code>        |
| grafana.service.scheme               |                                                                             | <code>""</code>        |
| grafana.service.name                 |                                                                             | <code>""</code>        |
| grafana.service.namespace            |                                                                             | <code>""</code>        |
| grafana.service.port                 |                                                                             | <code>""</code>        |
| grafana.service.path                 |                                                                             | <code>""</code>        |
| grafana.service.query                |                                                                             | <code>""</code>        |
| grafana.basicAuth.username           | The HTTP basic authentication username for the Prometheus server.           | <code>""</code>        |
| grafana.basicAuth.password           | The HTTP basic authentication password for the Prometheus server.           | <code>""</code>        |
| grafana.bearerToken                  | The bearer token for the Prometheus server.                                 | <code>""</code>        |
| grafana.tls.ca                       | The CA cert to use for the Prometheus server.                               | <code>""</code>        |
| grafana.tls.cert                     | The client cert to use for communicating with the Prometheus server.        | <code>""</code>        |
| grafana.tls.key                      | The client key to use for communicating with the Prometheus server.         | <code>""</code>        |
| grafana.tls.serverName               | The server name which will be used to verify the Prometheus server address. | <code>""</code>        |
| grafana.tls.insecureSkipTLSVerify    | To skip tls verification when communicating with the Prometheus server.     | <code>false</code>     |
| grafana.dashboard.datasource         |                                                                             | <code>""</code>        |
| grafana.dashboard.folderID           |                                                                             | <code>0</code>         |
| prometheus.default                   |                                                                             | <code>false</code>     |
| prometheus.url                       |                                                                             | <code>""</code>        |
| prometheus.service.scheme            |                                                                             | <code>""</code>        |
| prometheus.service.name              |                                                                             | <code>""</code>        |
| prometheus.service.namespace         |                                                                             | <code>""</code>        |
| prometheus.service.port              |                                                                             | <code>""</code>        |
| prometheus.service.path              |                                                                             | <code>""</code>        |
| prometheus.service.query             |                                                                             | <code>""</code>        |
| prometheus.basicAuth.username        | The HTTP basic authentication username for the Prometheus server.           | <code>""</code>        |
| prometheus.basicAuth.password        | The HTTP basic authentication password for the Prometheus server.           | <code>""</code>        |
| prometheus.bearerToken               | The bearer token for the Prometheus server.                                 | <code>""</code>        |
| prometheus.tls.ca                    | The CA cert to use for the Prometheus server.                               | <code>""</code>        |
| prometheus.tls.cert                  | The client cert to use for communicating with the Prometheus server.        | <code>""</code>        |
| prometheus.tls.key                   | The client key to use for communicating with the Prometheus server.         | <code>""</code>        |
| prometheus.tls.serverName            | The server name which will be used to verify the Prometheus server address. | <code>""</code>        |
| prometheus.tls.insecureSkipTLSVerify | To skip tls verification when communicating with the Prometheus server.     | <code>false</code>     |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i monitoring-config appscode/monitoring-config -n kubeops --create-namespace --version=v2022.06.14 --set fullnameOverride=opscenter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i monitoring-config appscode/monitoring-config -n kubeops --create-namespace --version=v2022.06.14 --values values.yaml
```
