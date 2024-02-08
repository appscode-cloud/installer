# ACE Opscenter Configurator

[ACE Opscenter Configurator by AppsCode](https://github.com/bytebuilders/installer) - ACE Opscenter Configurator

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/opscenter-features --version=v2023.12.20
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.12.20
```

## Introduction

This chart deploys a ACE Opscenter Configurator on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `opscenter-features`:

```bash
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.12.20
```

The command deploys a ACE Opscenter Configurator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `opscenter-features`:

```bash
$ helm uninstall opscenter-features -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `opscenter-features` chart and their default values.

|                       Parameter                       |       Description       |                  Default                   |
|-------------------------------------------------------|-------------------------|--------------------------------------------|
| nameOverride                                          |                         | <code>""</code>                            |
| fullnameOverride                                      |                         | <code>""</code>                            |
| offlineInstaller                                      |                         | <code>false</code>                         |
| image.proxies.appscode                                | r.appscode.com          | <code>r.appscode.com</code>                |
| image.proxies.dockerHub                               | company/bin:tag         | <code>""</code>                            |
| image.proxies.dockerLibrary                           | alpine, nginx etc.      | <code>""</code>                            |
| image.proxies.ghcr                                    | ghcr.io/company/bin:tag | <code>ghcr.io</code>                       |
| image.proxies.quay                                    | quay.io/company/bin:tag | <code>quay.io</code>                       |
| image.proxies.kubernetes                              | registry.k8s.io/bin:tag | <code>registry.k8s.io</code>               |
| registry.credentials                                  |                         | <code>{}</code>                            |
| helm.repositories.appscode-charts-oci.url             |                         | <code>oci://ghcr.io/appscode-charts</code> |
| helm.releases.aws-ebs-csi-driver.version              |                         | <code>"2.23.0"</code>                      |
| helm.releases.capa-vpc-peering-operator.version       |                         | <code>"v2023.12.11"</code>                 |
| helm.releases.capi-cluster-presets.version            |                         | <code>"v2023.11.14"</code>                 |
| helm.releases.cert-manager.version                    |                         | <code>"v1.14.1"</code>                     |
| helm.releases.cert-manager-csi-driver-cacerts.version |                         | <code>"v2023.10.1"</code>                  |
| helm.releases.cluster-autoscaler.version              |                         | <code>"9.29.0"</code>                      |
| helm.releases.config-syncer.version                   |                         | <code>"v0.14.6"</code>                     |
| helm.releases.crossplane.version                      |                         | <code>"1.14.0"</code>                      |
| helm.releases.external-dns-operator.version           |                         | <code>"v2023.10.1"</code>                  |
| helm.releases.falco.version                           |                         | <code>"4.0.0"</code>                       |
| helm.releases.falco-ui-server.version                 |                         | <code>"v2024.2.5"</code>                   |
| helm.releases.flux2.version                           |                         | <code>"2.12.2"</code>                      |
| helm.releases.gatekeeper.version                      |                         | <code>"3.13.3"</code>                      |
| helm.releases.gatekeeper-grafana-dashboards.version   |                         | <code>"v2023.10.1"</code>                  |
| helm.releases.gatekeeper-library.version              |                         | <code>"v2023.10.1"</code>                  |
| helm.releases.grafana-operator.version                |                         | <code>"v0.0.3"</code>                      |
| helm.releases.keda.version                            |                         | <code>"2.13.1"</code>                      |
| helm.releases.keda-add-ons-http.version               |                         | <code>"0.7.0"</code>                       |
| helm.releases.kube-grafana-dashboards.version         |                         | <code>"v2023.10.1"</code>                  |
| helm.releases.kube-prometheus-stack.version           |                         | <code>"52.1.0"</code>                      |
| helm.releases.kube-ui-server.version                  |                         | <code>"v2023.12.20"</code>                 |
| helm.releases.kubedb.version                          |                         | <code>"v2024.1.31"</code>                  |
| helm.releases.kubedb-opscenter.version                |                         | <code>"v2024.1.31"</code>                  |
| helm.releases.kubedb-provider-aws.version             |                         | <code>"v2024.1.31"</code>                  |
| helm.releases.kubedb-provider-azure.version           |                         | <code>"v2024.1.31"</code>                  |
| helm.releases.kubedb-provider-gcp.version             |                         | <code>"v2024.1.31"</code>                  |
| helm.releases.kubestash.version                       |                         | <code>"v2024.2.5"</code>                   |
| helm.releases.kubevault.version                       |                         | <code>"v2024.1.31"</code>                  |
| helm.releases.kubevault-opscenter.version             |                         | <code>"v2024.1.31"</code>                  |
| helm.releases.license-proxyserver.version             |                         | <code>"v2023.11.14"</code>                 |
| helm.releases.longhorn.version                        |                         | <code>"1.5.3"</code>                       |
| helm.releases.metrics-server.version                  |                         | <code>"3.11.0"</code>                      |
| helm.releases.monitoring-operator.version             |                         | <code>"v0.0.4"</code>                      |
| helm.releases.opencost.version                        |                         | <code>"1.18.1"</code>                      |
| helm.releases.opencost-grafana-dashboards.version     |                         | <code>"v2023.10.1"</code>                  |
| helm.releases.opscenter-features.version              |                         | <code>"v2023.12.20"</code>                 |
| helm.releases.panopticon.version                      |                         | <code>"v2024.2.5"</code>                   |
| helm.releases.prepare-cluster.version                 |                         | <code>"v2023.12.21"</code>                 |
| helm.releases.prometheus-adapter.version              |                         | <code>"4.9.0"</code>                       |
| helm.releases.reloader.version                        |                         | <code>"1.0.50"</code>                      |
| helm.releases.scanner.version                         |                         | <code>"v2024.1.18"</code>                  |
| helm.releases.sidekick.version                        |                         | <code>"v2024.2.6"</code>                   |
| helm.releases.snapshot-controller.version             |                         | <code>"2.0.3"</code>                       |
| helm.releases.stash.version                           |                         | <code>"v2023.10.9"</code>                  |
| helm.releases.stash-opscenter.version                 |                         | <code>"v2023.10.9"</code>                  |
| helm.releases.stash-presets.version                   |                         | <code>"v2023.11.14"</code>                 |
| helm.releases.supervisor.version                      |                         | <code>"v2024.2.6"</code>                   |
| helm.releases.topolvm.version                         |                         | <code>"13.0.0"</code>                      |
| helm.releases.voyager.version                         |                         | <code>"v2023.9.18"</code>                  |
| helm.releases.voyager-gateway.version                 |                         | <code>"v2024.1.29"</code>                  |
| clusterManagers                                       |                         | <code>[]</code>                            |
| capi.provider                                         |                         | <code>""</code>                            |
| capi.namespace                                        |                         | <code>""</code>                            |
| capi.clusterName                                      |                         | <code>""</code>                            |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.12.20 --set image.proxies.appscode=r.appscode.com
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.12.20 --values values.yaml
```
