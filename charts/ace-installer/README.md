# ACE Installer

[ACE Installer](https://github.com/bytebuilders/installer) - ACE Installer

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/ace-installer --version=v2023.10.18
$ helm upgrade -i ace-installer appscode/ace-installer -n kubeops --create-namespace --version=v2023.10.18
```

## Introduction

This chart deploys charts for ACE on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `ace-installer`:

```bash
$ helm upgrade -i ace-installer appscode/ace-installer -n kubeops --create-namespace --version=v2023.10.18
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

|                                Parameter                                 |       Description       |                         Default                         |
|--------------------------------------------------------------------------|-------------------------|---------------------------------------------------------|
| nameOverride                                                             |                         | <code>""</code>                                         |
| fullnameOverride                                                         |                         | <code>""</code>                                         |
| image.registryFQDN                                                       |                         | <code>""</code>                                         |
| image.proxies.appscode                                                   | r.appscode.com          | <code>""</code>                                         |
| image.proxies.dockerHub                                                  | company/bin:tag         | <code>""</code>                                         |
| image.proxies.dockerLibrary                                              | alpine, nginx etc.      | <code>""</code>                                         |
| image.proxies.ghcr                                                       | ghcr.io/company/bin:tag | <code>""</code>                                         |
| image.proxies.kubernetes                                                 | registry.k8s.io/bin:tag | <code>""</code>                                         |
| registry.credentials                                                     |                         | <code>{}</code>                                         |
| helm.repositories.bootstrap.interval                                     |                         | <code>1h0m0s</code>                                     |
| helm.repositories.bootstrap.url                                          |                         | <code>https://charts.appscode.com/stable</code>         |
| helm.repositories.stakater.interval                                      |                         | <code>1h0m0s</code>                                     |
| helm.repositories.stakater.url                                           |                         | <code>https://stakater.github.io/stakater-charts</code> |
| helm.releases.ace.enabled                                                |                         | <code>false</code>                                      |
| helm.releases.ace.version                                                |                         | <code>"v2023.10.18"</code>                              |
| helm.releases.cert-manager-csi-driver-cacerts.enabled                    |                         | <code>true</code>                                       |
| helm.releases.cert-manager-csi-driver-cacerts.version                    |                         | <code>"v2023.10.1"</code>                               |
| helm.releases.cert-manager-webhook-ace.enabled                           |                         | <code>true</code>                                       |
| helm.releases.cert-manager-webhook-ace.version                           |                         | <code>"v2023.10.18"</code>                              |
| helm.releases.cert-manager.enabled                                       |                         | <code>true</code>                                       |
| helm.releases.cert-manager.version                                       |                         | <code>"v1.11.0"</code>                                  |
| helm.releases.cert-manager.values.installCRDs                            |                         | <code>true</code>                                       |
| helm.releases.kubedb.enabled                                             |                         | <code>true</code>                                       |
| helm.releases.kubedb.version                                             |                         | <code>"v2023.10.9"</code>                               |
| helm.releases.kubedb.values.kubedb-provisioner.enabled                   |                         | <code>true</code>                                       |
| helm.releases.kubedb.values.kubedb-catalog.enabled                       |                         | <code>true</code>                                       |
| helm.releases.kubedb.values.kubedb-ops-manager.enabled                   |                         | <code>true</code>                                       |
| helm.releases.kubedb.values.kubedb-autoscaler.enabled                    |                         | <code>false</code>                                      |
| helm.releases.kubedb.values.kubedb-dashboard.enabled                     |                         | <code>false</code>                                      |
| helm.releases.kubedb.values.kubedb-schema-manager.enabled                |                         | <code>false</code>                                      |
| helm.releases.kubedb.values.kubedb-metrics.enabled                       |                         | <code>false</code>                                      |
| helm.releases.docker-machine-operator.enabled                            |                         | <code>true</code>                                       |
| helm.releases.docker-machine-operator.version                            |                         | <code>"v2023.10.18"</code>                              |
| helm.releases.external-dns-operator.enabled                              |                         | <code>true</code>                                       |
| helm.releases.external-dns-operator.version                              |                         | <code>"v2023.10.1"</code>                               |
| helm.releases.license-proxyserver.enabled                                |                         | <code>true</code>                                       |
| helm.releases.license-proxyserver.version                                |                         | <code>"v2023.10.18"</code>                              |
| helm.releases.reloader.enabled                                           |                         | <code>true</code>                                       |
| helm.releases.reloader.version                                           |                         | <code>"v1.0.24"</code>                                  |
| helm.releases.kube-prometheus-stack.enabled                              |                         | <code>true</code>                                       |
| helm.releases.kube-prometheus-stack.version                              |                         | <code>""</code>                                         |
| helm.releases.opscenter-features.enabled                                 |                         | <code>true</code>                                       |
| helm.releases.opscenter-features.version                                 |                         | <code>"v2023.10.18"</code>                              |
| helm.releases.panopticon.enabled                                         |                         | <code>true</code>                                       |
| helm.releases.panopticon.version                                         |                         | <code>"v2023.10.1"</code>                               |
| helm.releases.panopticon.values.monitoring.enabled                       |                         | <code>true</code>                                       |
| helm.releases.panopticon.values.monitoring.agent                         |                         | <code>prometheus.io/operator</code>                     |
| helm.releases.panopticon.values.monitoring.serviceMonitor.labels.release |                         | <code>kube-prometheus-stack</code>                      |
| helm.releases.stash.enabled                                              |                         | <code>true</code>                                       |
| helm.releases.stash.version                                              |                         | <code>"v2023.10.9"</code>                               |
| helm.releases.stash.values.features.enterprise                           |                         | <code>true</code>                                       |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i ace-installer appscode/ace-installer -n kubeops --create-namespace --version=v2023.10.18 --set helm.repositories.bootstrap.interval=1h0m0s
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i ace-installer appscode/ace-installer -n kubeops --create-namespace --version=v2023.10.18 --values values.yaml
```
