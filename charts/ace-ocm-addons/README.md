# ACE OCM Addons

[ACE OCM Addons](https://github.com/bytebuilders/installer) - ACE OCM Addons

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/ace-ocm-addons --version=v2023.12.20
$ helm upgrade -i ace-ocm-addons appscode/ace-ocm-addons -n open-cluster-management --create-namespace --version=v2023.12.20
```

## Introduction

This chart deploys charts for ACE OCM Addons on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `ace-ocm-addons`:

```bash
$ helm upgrade -i ace-ocm-addons appscode/ace-ocm-addons -n open-cluster-management --create-namespace --version=v2023.12.20
```

The command deploys charts for ACE OCM Addons on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `ace-ocm-addons`:

```bash
$ helm uninstall ace-ocm-addons -n open-cluster-management
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `ace-ocm-addons` chart and their default values.

|                 Parameter                 |       Description       |                  Default                   |
|-------------------------------------------|-------------------------|--------------------------------------------|
| nameOverride                              |                         | <code>""</code>                            |
| fullnameOverride                          |                         | <code>""</code>                            |
| offlineInstaller                          |                         | <code>false</code>                         |
| image.proxies.appscode                    | r.appscode.com          | <code>r.appscode.com</code>                |
| image.proxies.dockerHub                   | company/bin:tag         | <code>""</code>                            |
| image.proxies.dockerLibrary               | alpine, nginx etc.      | <code>""</code>                            |
| image.proxies.ghcr                        | ghcr.io/company/bin:tag | <code>ghcr.io</code>                       |
| image.proxies.quay                        | quay.io/company/bin:tag | <code>quay.io</code>                       |
| image.proxies.kubernetes                  | registry.k8s.io/bin:tag | <code>registry.k8s.io</code>               |
| registry.credentials                      |                         | <code>{}</code>                            |
| helm.repositories.appscode-charts-oci.url |                         | <code>oci://ghcr.io/appscode-charts</code> |
| helm.releases.kube-ui-server.enabled      |                         | <code>true</code>                          |
| helm.releases.kube-ui-server.version      |                         | <code>"v2023.12.18"</code>                 |
| helm.releases.license-proxyserver.enabled |                         | <code>true</code>                          |
| helm.releases.license-proxyserver.version |                         | <code>"v2023.11.14"</code>                 |
| helm.releases.opscenter-features.enabled  |                         | <code>true</code>                          |
| helm.releases.opscenter-features.version  |                         | <code>"v2023.12.20"</code>                 |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i ace-ocm-addons appscode/ace-ocm-addons -n open-cluster-management --create-namespace --version=v2023.12.20 --set image.proxies.appscode=r.appscode.com
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i ace-ocm-addons appscode/ace-ocm-addons -n open-cluster-management --create-namespace --version=v2023.12.20 --values values.yaml
```
