# ByteBuilders Opscenter

[ByteBuilders Opscenter Core by AppsCode](https://github.com/kubedb) - ByteBuilders Opscenter Core

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/opscenter-core --version=v2022.04.04
$ helm upgrade -i opscenter-core appscode/opscenter-core -n kubeops --create-namespace --version=v2022.04.04
```

## Introduction

This chart deploys a ByteBuilders Opscenter on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.16+

## Installing the Chart

To install/upgrade the chart with the release name `opscenter-core`:

```bash
$ helm upgrade -i opscenter-core appscode/opscenter-core -n kubeops --create-namespace --version=v2022.04.04
```

The command deploys a ByteBuilders Opscenter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `opscenter-core`:

```bash
$ helm uninstall opscenter-core -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `opscenter-core` chart and their default values.

|                Parameter                |                                                                                                                                                                              Description                                                                                                                                                                              |      Default      |
|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|
| global.license                          | License for the product. Get a license by following the steps from [here](https://kubedb.com/docs/latest/setup/install/enterprise#get-a-trial-license). <br> Example: <br> `helm install appscode/kubedb \` <br> `--set-file global.license=/path/to/license/file` <br> `or` <br> `helm install appscode/kubedb \` <br> `--set global.license=<license file content>` | <code>""</code>   |
| global.registry                         | Docker registry used to pull KubeDB related images                                                                                                                                                                                                                                                                                                                    | <code>""</code>   |
| global.registryFQDN                     | Docker registry fqdn used to pull KubeDB related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                                                                                                                                                                                                               | <code>""</code>   |
| global.imagePullSecrets                 | Specify an array of imagePullSecrets. Secrets must be manually created in the namespace. <br> Example: <br> `helm template charts/kubedb \` <br> `--set global.imagePullSecrets[0].name=sec0 \` <br> `--set global.imagePullSecrets[1].name=sec1`                                                                                                                     | <code>[]</code>   |
| global.monitoring.agent                 | Name of monitoring agent (one of "prometheus.io", "prometheus.io/operator", "prometheus.io/builtin")                                                                                                                                                                                                                                                                  | <code>""</code>   |
| global.monitoring.serviceMonitor.labels | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/operator`.                                                                                                                                                                                                   | <code>{}</code>   |
| kube-ui-server.enabled                  |                                                                                                                                                                                                                                                                                                                                                                       | <code>true</code> |
| panopticon.enabled                      |                                                                                                                                                                                                                                                                                                                                                                       | <code>true</code> |
| supervisor.enabled                      |                                                                                                                                                                                                                                                                                                                                                                       | <code>true</code> |
| grafana-operator.enabled                |                                                                                                                                                                                                                                                                                                                                                                       | <code>true</code> |
| grafana-ui-server.enabled               |                                                                                                                                                                                                                                                                                                                                                                       | <code>true</code> |
| kube-grafana-dashboards.enabled         |                                                                                                                                                                                                                                                                                                                                                                       | <code>true</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i opscenter-core appscode/opscenter-core -n kubeops --create-namespace --version=v2022.04.04 --set -- generate from values file --
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i opscenter-core appscode/opscenter-core -n kubeops --create-namespace --version=v2022.04.04 --values values.yaml
```
