# AppsCode License Proxy Server Manager

[AppsCode License Proxy Server OCM Addon Manager](https://github.com/appscode-cloud/license-proxyserver) - AppsCode License Proxy Server OCM Addon Manager

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/license-proxyserver-manager --version=v2026.1.15
$ helm upgrade -i license-proxyserver-manager appscode/license-proxyserver-manager -n open-cluster-management-license-proxyserver --create-namespace --version=v2026.1.15
```

## Introduction

This chart deploys an AppsCode License Proxy Server OCM Addon Manager on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `license-proxyserver-manager`:

```bash
$ helm upgrade -i license-proxyserver-manager appscode/license-proxyserver-manager -n open-cluster-management-license-proxyserver --create-namespace --version=v2026.1.15
```

The command deploys an AppsCode License Proxy Server OCM Addon Manager on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `license-proxyserver-manager`:

```bash
$ helm uninstall license-proxyserver-manager -n open-cluster-management-license-proxyserver
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `license-proxyserver-manager` chart and their default values.

|                Parameter                 |                             Description                             |                         Default                          |
|------------------------------------------|---------------------------------------------------------------------|----------------------------------------------------------|
| nameOverride                             |                                                                     | <code>""</code>                                          |
| fullnameOverride                         |                                                                     | <code>""</code>                                          |
| registryFQDN                             | Docker registry fqdn used to pull license-proxyserver docker images | <code>ghcr.io</code>                                     |
| image                                    |                                                                     | <code>ghcr.io/appscode/license-proxyserver</code>        |
| tag                                      |                                                                     | <code>""</code>                                          |
| imagePullPolicy                          |                                                                     | <code>Always</code>                                      |
| kubeconfigSecretName                     |                                                                     | <code>""</code>                                          |
| addonManagerNamespace                    |                                                                     | <code>open-cluster-management-license-proxyserver</code> |
| placement.create                         |                                                                     | <code>true</code>                                        |
| placement.name                           |                                                                     | <code>global</code>                                      |
| kubectl.image                            |                                                                     | <code>ghcr.io/appscode/kubectl-nonroot:1.31</code>       |
| platform.baseURL                         |                                                                     | <code>""</code>                                          |
| platform.token                           |                                                                     | <code>""</code>                                          |
| platform.tokenSecretName                 |                                                                     | <code>""</code>                                          |
| platform.caBundle                        |                                                                     | <code>""</code>                                          |
| platform.insecureSkipTLSVerify           |                                                                     | <code>false</code>                                       |
| securityContext.allowPrivilegeEscalation |                                                                     | <code>false</code>                                       |
| securityContext.privileged               |                                                                     | <code>false</code>                                       |
| securityContext.runAsNonRoot             |                                                                     | <code>true</code>                                        |
| securityContext.runAsUser                |                                                                     | <code>65534</code>                                       |
| securityContext.readOnlyRootFilesystem   |                                                                     | <code>true</code>                                        |
| securityContext.seccompProfile.type      |                                                                     | <code>RuntimeDefault</code>                              |
| envFrom                                  | List of sources to populate environment variables in the container  | <code>[]</code>                                          |
| env                                      | List of environment variables to set in the container               | <code>[]</code>                                          |
| distro.openshift                         |                                                                     | <code>false</code>                                       |
| distro.ubi                               |                                                                     | <code>""</code>                                          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i license-proxyserver-manager appscode/license-proxyserver-manager -n open-cluster-management-license-proxyserver --create-namespace --version=v2026.1.15 --set registryFQDN=ghcr.io
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i license-proxyserver-manager appscode/license-proxyserver-manager -n open-cluster-management-license-proxyserver --create-namespace --version=v2026.1.15 --values values.yaml
```
