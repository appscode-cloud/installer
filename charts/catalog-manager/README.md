# Appcatalog

[Appcatalog by AppsCode](https://github.com/kubeware/catalog-manager) - Appcatalog for Kubernetes

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/catalog-manager --version=v2024.2.11
$ helm upgrade -i catalog-manager appscode/catalog-manager -n kubeops --create-namespace --version=v2024.2.11
```

## Introduction

This chart deploys an Appcatalog on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `catalog-manager`:

```bash
$ helm upgrade -i catalog-manager appscode/catalog-manager -n kubeops --create-namespace --version=v2024.2.11
```

The command deploys an Appcatalog on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `catalog-manager`:

```bash
$ helm uninstall catalog-manager -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `catalog-manager` chart and their default values.

|              Parameter               |                                                                                                            Description                                                                                                             |                                                                                            Default                                                                                             |
|--------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| nameOverride                         | Overrides name template                                                                                                                                                                                                            | <code>""</code>                                                                                                                                                                                |
| fullnameOverride                     | Overrides fullname template                                                                                                                                                                                                        | <code>""</code>                                                                                                                                                                                |
| replicaCount                         |                                                                                                                                                                                                                                    | <code>1</code>                                                                                                                                                                                 |
| registryFQDN                         | Docker registry fqdn used to pull docker images Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                                                                                     | <code>ghcr.io</code>                                                                                                                                                                           |
| image.registry                       | Docker registry used to pull operator image                                                                                                                                                                                        | <code>appscode</code>                                                                                                                                                                          |
| image.repository                     | Name of operator container image                                                                                                                                                                                                   | <code>catalog-manager</code>                                                                                                                                                                   |
| image.tag                            | Overrides the image tag whose default is the chart appVersion.                                                                                                                                                                     | <code>""</code>                                                                                                                                                                                |
| image.resources                      | Compute Resources required by the operator container                                                                                                                                                                               | <code>{}</code>                                                                                                                                                                                |
| image.securityContext                | Security options this container should run with                                                                                                                                                                                    | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| imagePullSecrets                     | Specify an array of imagePullSecrets. Secrets must be manually created in the namespace. <br> Example: <br> `helm template charts/stash \` <br> `--set imagePullSecrets[0].name=sec0 \` <br> `--set imagePullSecrets[1].name=sec1` | <code>[]</code>                                                                                                                                                                                |
| imagePullPolicy                      | Container image pull policy                                                                                                                                                                                                        | <code>Always</code>                                                                                                                                                                            |
| serviceAccount.create                | Specifies whether a service account should be created                                                                                                                                                                              | <code>true</code>                                                                                                                                                                              |
| serviceAccount.annotations           | Annotations to add to the service account                                                                                                                                                                                          | <code>{}</code>                                                                                                                                                                                |
| serviceAccount.name                  | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                                                                                                             | <code>""</code>                                                                                                                                                                                |
| podAnnotations                       |                                                                                                                                                                                                                                    | <code>{}</code>                                                                                                                                                                                |
| podSecurityContext                   |                                                                                                                                                                                                                                    | <code>{}</code>                                                                                                                                                                                |
| nodeSelector                         |                                                                                                                                                                                                                                    | <code>{}</code>                                                                                                                                                                                |
| tolerations                          |                                                                                                                                                                                                                                    | <code>[]</code>                                                                                                                                                                                |
| affinity                             |                                                                                                                                                                                                                                    | <code>{}</code>                                                                                                                                                                                |
| monitoring.agent                     | Name of monitoring agent (one of "prometheus.io", "prometheus.io/operator", "prometheus.io/builtin")                                                                                                                               | <code>""</code>                                                                                                                                                                                |
| monitoring.serviceMonitor.labels     | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/operator`.                                                                | <code>{}</code>                                                                                                                                                                                |
| vaultServer.name                     |                                                                                                                                                                                                                                    | <code>""</code>                                                                                                                                                                                |
| vaultServer.namespace                |                                                                                                                                                                                                                                    | <code>""</code>                                                                                                                                                                                |
| secretReaderServiceAccount.name      |                                                                                                                                                                                                                                    | <code>""</code>                                                                                                                                                                                |
| secretReaderServiceAccount.namespace |                                                                                                                                                                                                                                    | <code>""</code>                                                                                                                                                                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i catalog-manager appscode/catalog-manager -n kubeops --create-namespace --version=v2024.2.11 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i catalog-manager appscode/catalog-manager -n kubeops --create-namespace --version=v2024.2.11 --values values.yaml
```
