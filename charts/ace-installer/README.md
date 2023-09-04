# ACE Installer

[ACE Installer](https://github.com/bytebuilders/installer) - ACE Installer

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/ace-installer --version=v2023.03.23
$ helm upgrade -i ace-installer appscode/ace-installer -n kubeops --create-namespace --version=v2023.03.23
```

## Introduction

This chart deploys charts for ACE on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `ace-installer`:

```bash
$ helm upgrade -i ace-installer appscode/ace-installer -n kubeops --create-namespace --version=v2023.03.23
```

The command deploys charts for ACE on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `ace-installer`:

```bash
$ helm uninstall ace-installer -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `ace-installer` chart and their default values.

|                              Parameter                              | Description |                             Default                             |
|---------------------------------------------------------------------|-------------|-----------------------------------------------------------------|
| nameOverride                                                        |             | <code>""</code>                                                 |
| fullnameOverride                                                    |             | <code>""</code>                                                 |
| repositories.appscode.interval                                      |             | <code>1h0m0s</code>                                             |
| repositories.appscode.url                                           |             | <code>https://charts.appscode.com/stable</code>                 |
| repositories.bytebuilders-ui.interval                               |             | <code>1h0m0s</code>                                             |
| repositories.bytebuilders-ui.url                                    |             | <code>oci://r.byte.builders/charts/</code>                      |
| repositories.bytebuilders.interval                                  |             | <code>1h0m0s</code>                                             |
| repositories.bytebuilders.url                                       |             | <code>https://charts.appscode.com/stable</code>                 |
| repositories.jetstack.interval                                      |             | <code>1h0m0s</code>                                             |
| repositories.jetstack.url                                           |             | <code>https://charts.jetstack.io</code>                         |
| repositories.kubedb.interval                                        |             | <code>1h0m0s</code>                                             |
| repositories.kubedb.url                                             |             | <code>https://charts.appscode.com/stable</code>                 |
| repositories.kubeops.interval                                       |             | <code>1h0m0s</code>                                             |
| repositories.kubeops.url                                            |             | <code>https://charts.appscode.com/stable</code>                 |
| repositories.kubevault.interval                                     |             | <code>1h0m0s</code>                                             |
| repositories.kubevault.url                                          |             | <code>https://charts.appscode.com/stable</code>                 |
| repositories.nats.interval                                          |             | <code>1h0m0s</code>                                             |
| repositories.nats.url                                               |             | <code>https://nats-io.github.io/k8s/helm/charts/</code>         |
| repositories.prometheus-community.interval                          |             | <code>1h0m0s</code>                                             |
| repositories.prometheus-community.url                               |             | <code>https://prometheus-community.github.io/helm-charts</code> |
| repositories.stashed.interval                                       |             | <code>1h0m0s</code>                                             |
| repositories.stashed.url                                            |             | <code>https://charts.appscode.com/stable</code>                 |
| repositories.stakater.interval                                      |             | <code>1h0m0s</code>                                             |
| repositories.stakater.url                                           |             | <code>https://stakater.github.io/stakater-charts</code>         |
| repositoryCredentials                                               |             | <code>{}</code>                                                 |
| releases.ace.enabled                                                |             | <code>false</code>                                              |
| releases.ace.version                                                |             | <code>"v2023.03.23"</code>                                      |
| releases.cert-manager-csi-driver-cacerts.enabled                    |             | <code>true</code>                                               |
| releases.cert-manager-csi-driver-cacerts.version                    |             | <code>"v2023.03.23"</code>                                      |
| releases.cert-manager-webhook-ace.enabled                           |             | <code>true</code>                                               |
| releases.cert-manager-webhook-ace.version                           |             | <code>"v2023.03.23"</code>                                      |
| releases.cert-manager.enabled                                       |             | <code>true</code>                                               |
| releases.cert-manager.version                                       |             | <code>"v1.11.0"</code>                                          |
| releases.cert-manager.values.installCRDs                            |             | <code>true</code>                                               |
| releases.kubedb.enabled                                             |             | <code>true</code>                                               |
| releases.kubedb.version                                             |             | <code>"v2023.08.18"</code>                                      |
| releases.kubedb.values.kubedb-provisioner.enabled                   |             | <code>true</code>                                               |
| releases.kubedb.values.kubedb-catalog.enabled                       |             | <code>true</code>                                               |
| releases.kubedb.values.kubedb-ops-manager.enabled                   |             | <code>false</code>                                              |
| releases.kubedb.values.kubedb-autoscaler.enabled                    |             | <code>false</code>                                              |
| releases.kubedb.values.kubedb-dashboard.enabled                     |             | <code>false</code>                                              |
| releases.kubedb.values.kubedb-schema-manager.enabled                |             | <code>false</code>                                              |
| releases.kubedb.values.kubedb-metrics.enabled                       |             | <code>true</code>                                               |
| releases.docker-machine-operator.enabled                            |             | <code>true</code>                                               |
| releases.docker-machine-operator.version                            |             | <code>"v2023.9.1"</code>                                        |
| releases.external-dns-operator.enabled                              |             | <code>true</code>                                               |
| releases.external-dns-operator.version                              |             | <code>"v2023.03.23"</code>                                      |
| releases.license-proxyserver.enabled                                |             | <code>true</code>                                               |
| releases.license-proxyserver.version                                |             | <code>"v2023.03.23"</code>                                      |
| releases.reloader.enabled                                           |             | <code>true</code>                                               |
| releases.reloader.version                                           |             | <code>"v1.0.24"</code>                                          |
| releases.kube-prometheus-stack.enabled                              |             | <code>true</code>                                               |
| releases.kube-prometheus-stack.version                              |             | <code>""</code>                                                 |
| releases.panopticon.enabled                                         |             | <code>true</code>                                               |
| releases.panopticon.version                                         |             | <code>"v2023.03.23"</code>                                      |
| releases.panopticon.values.monitoring.enabled                       |             | <code>true</code>                                               |
| releases.panopticon.values.monitoring.agent                         |             | <code>prometheus.io/operator</code>                             |
| releases.panopticon.values.monitoring.serviceMonitor.labels.release |             | <code>kube-prometheus-stack</code>                              |
| releases.stash.enabled                                              |             | <code>true</code>                                               |
| releases.stash.version                                              |             | <code>"v2023.08.18"</code>                                      |
| releases.stash.values.features.enterprise                           |             | <code>true</code>                                               |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i ace-installer appscode/ace-installer -n kubeops --create-namespace --version=v2023.03.23 --set repositories.appscode.interval=1h0m0s
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i ace-installer appscode/ace-installer -n kubeops --create-namespace --version=v2023.03.23 --values values.yaml
```
