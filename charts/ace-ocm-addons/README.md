# ACE OCM Addons

[ACE OCM Addons](https://github.com/appscode-cloud/installer) - ACE OCM Addons

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/ace-ocm-addons --version=v2024.6.3
$ helm upgrade -i ace-ocm-addons appscode/ace-ocm-addons -n open-cluster-management --create-namespace --version=v2024.6.3
```

## Introduction

This chart deploys charts for ACE OCM Addons on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `ace-ocm-addons`:

```bash
$ helm upgrade -i ace-ocm-addons appscode/ace-ocm-addons -n open-cluster-management --create-namespace --version=v2024.6.3
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

|                 Parameter                 |           Description           |                      Default                       |
|-------------------------------------------|---------------------------------|----------------------------------------------------|
| nameOverride                              |                                 | <code>""</code>                                    |
| fullnameOverride                          |                                 | <code>""</code>                                    |
| offlineInstaller                          |                                 | <code>false</code>                                 |
| image.proxies.appscode                    | r.appscode.com                  | <code>r.appscode.com</code>                        |
| image.proxies.dockerHub                   | company/bin:tag                 | <code>""</code>                                    |
| image.proxies.dockerLibrary               | alpine, nginx etc.              | <code>""</code>                                    |
| image.proxies.ghcr                        | ghcr.io/company/bin:tag         | <code>ghcr.io</code>                               |
| image.proxies.quay                        | quay.io/company/bin:tag         | <code>quay.io</code>                               |
| image.proxies.kubernetes                  | registry.k8s.io/bin:tag         | <code>registry.k8s.io</code>                       |
| registry.credentials                      |                                 | <code>{}</code>                                    |
| registry.certs                            | username: "abc" password: "xyz" | <code>{}</code>                                    |
| registry.imagePullSecrets                 | ca.crt: "***"                   | <code>[]</code>                                    |
| helm.createNamespace                      |                                 | <code>true</code>                                  |
| helm.repositories.appscode-charts-oci.url |                                 | <code>oci://ghcr.io/appscode-charts</code>         |
| helm.releases.kube-ui-server.enabled      |                                 | <code>true</code>                                  |
| helm.releases.kube-ui-server.version      |                                 | <code>"v2024.5.15"</code>                          |
| helm.releases.opscenter-features.enabled  |                                 | <code>true</code>                                  |
| helm.releases.opscenter-features.version  |                                 | <code>"v2024.6.3"</code>                           |
| kubeconfigSecretName                      | ocm values                      | <code>""</code>                                    |
| addonManagerNamespace                     |                                 | <code>open-cluster-management-addon</code>         |
| placement.create                          |                                 | <code>true</code>                                  |
| placement.name                            |                                 | <code>global</code>                                |
| kubectl.image                             |                                 | <code>ghcr.io/appscode/kubectl-nonroot:1.25</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i ace-ocm-addons appscode/ace-ocm-addons -n open-cluster-management --create-namespace --version=v2024.6.3 --set image.proxies.appscode=r.appscode.com
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i ace-ocm-addons appscode/ace-ocm-addons -n open-cluster-management --create-namespace --version=v2024.6.3 --values values.yaml
```
