# Catalog

[AppsCode SaaS Calalog](https://github.com/appscode-cloud/catalog-manager) - AppsCode SaaS Calalog

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/catalog-manager --version=v2025.9.30
$ helm upgrade -i catalog-manager appscode/catalog-manager -n ace --create-namespace --version=v2025.9.30
```

## Introduction

This chart deploys a catalog manager on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `catalog-manager`:

```bash
$ helm upgrade -i catalog-manager appscode/catalog-manager -n ace --create-namespace --version=v2025.9.30
```

The command deploys a catalog manager on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `catalog-manager`:

```bash
$ helm uninstall catalog-manager -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `catalog-manager` chart and their default values.

|                Parameter                |                                                                                                            Description                                                                                                             |                                                                                            Default                                                                                             |
|-----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| proxies.appscode                        | r.appscode.com                                                                                                                                                                                                                     | <code>r.appscode.com</code>                                                                                                                                                                    |
| proxies.dockerHub                       | company/bin:tag                                                                                                                                                                                                                    | <code>""</code>                                                                                                                                                                                |
| proxies.dockerLibrary                   | alpine, nginx etc.                                                                                                                                                                                                                 | <code>""</code>                                                                                                                                                                                |
| proxies.ghcr                            | ghcr.io/company/bin:tag                                                                                                                                                                                                            | <code>ghcr.io</code>                                                                                                                                                                           |
| proxies.quay                            | quay.io/company/bin:tag                                                                                                                                                                                                            | <code>quay.io</code>                                                                                                                                                                           |
| proxies.kubernetes                      | registry.k8s.io/bin:tag                                                                                                                                                                                                            | <code>registry.k8s.io</code>                                                                                                                                                                   |
| proxies.microsoft                       |                                                                                                                                                                                                                                    | <code>mcr.microsoft.com</code>                                                                                                                                                                 |
| nameOverride                            | Overrides name template                                                                                                                                                                                                            | <code>""</code>                                                                                                                                                                                |
| fullnameOverride                        | Overrides fullname template                                                                                                                                                                                                        | <code>""</code>                                                                                                                                                                                |
| replicaCount                            |                                                                                                                                                                                                                                    | <code>1</code>                                                                                                                                                                                 |
| registryFQDN                            | Docker registry fqdn used to pull docker images Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                                                                                     | <code>ghcr.io</code>                                                                                                                                                                           |
| image.registry                          | Docker registry used to pull operator image                                                                                                                                                                                        | <code>appscode</code>                                                                                                                                                                          |
| image.repository                        | Name of operator container image                                                                                                                                                                                                   | <code>catalog-manager</code>                                                                                                                                                                   |
| image.tag                               | Overrides the image tag whose default is the chart appVersion.                                                                                                                                                                     | <code>""</code>                                                                                                                                                                                |
| image.resources                         | Compute Resources required by the operator container                                                                                                                                                                               | <code>{}</code>                                                                                                                                                                                |
| image.securityContext                   | Security options this container should run with                                                                                                                                                                                    | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| imagePullSecrets                        | Specify an array of imagePullSecrets. Secrets must be manually created in the namespace. <br> Example: <br> `helm template charts/stash \` <br> `--set imagePullSecrets[0].name=sec0 \` <br> `--set imagePullSecrets[1].name=sec1` | <code>[]</code>                                                                                                                                                                                |
| imagePullPolicy                         | Container image pull policy                                                                                                                                                                                                        | <code>Always</code>                                                                                                                                                                            |
| serviceAccount.create                   | Specifies whether a service account should be created                                                                                                                                                                              | <code>true</code>                                                                                                                                                                              |
| serviceAccount.annotations              | Annotations to add to the service account                                                                                                                                                                                          | <code>{}</code>                                                                                                                                                                                |
| serviceAccount.name                     | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                                                                                                             | <code>""</code>                                                                                                                                                                                |
| podAnnotations                          |                                                                                                                                                                                                                                    | <code>{}</code>                                                                                                                                                                                |
| podSecurityContext                      |                                                                                                                                                                                                                                    | <code>{}</code>                                                                                                                                                                                |
| nodeSelector                            |                                                                                                                                                                                                                                    | <code>{}</code>                                                                                                                                                                                |
| tolerations                             |                                                                                                                                                                                                                                    | <code>[]</code>                                                                                                                                                                                |
| affinity                                |                                                                                                                                                                                                                                    | <code>{}</code>                                                                                                                                                                                |
| monitoring.agent                        | Name of monitoring agent (one of "prometheus.io", "prometheus.io/operator", "prometheus.io/builtin")                                                                                                                               | <code>""</code>                                                                                                                                                                                |
| monitoring.serviceMonitor.labels        | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/operator`.                                                                | <code>{}</code>                                                                                                                                                                                |
| serviceProviderServiceAccount.name      | Service Account name of the kube-bind service provider                                                                                                                                                                             | <code>"service-provider"</code>                                                                                                                                                                |
| serviceProviderServiceAccount.namespace | Service Account namespace of the kube-bind service provider                                                                                                                                                                        | <code>"ace"</code>                                                                                                                                                                             |
| keda.proxyService.namespace             |                                                                                                                                                                                                                                    | <code>"keda"</code>                                                                                                                                                                            |
| keda.proxyService.name                  |                                                                                                                                                                                                                                    | <code>"keda-add-ons-http-interceptor-proxy"</code>                                                                                                                                             |
| helmrepo.name                           | Name of the helmrepo for ui charts                                                                                                                                                                                                 | <code>""</code>                                                                                                                                                                                |
| helmrepo.namespace                      | Namespace of the helmrepo for ui charts                                                                                                                                                                                            | <code>""</code>                                                                                                                                                                                |
| platform.baseURL                        |                                                                                                                                                                                                                                    | <code>""</code>                                                                                                                                                                                |
| platform.caBundle                       |                                                                                                                                                                                                                                    | <code>""</code>                                                                                                                                                                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i catalog-manager appscode/catalog-manager -n ace --create-namespace --version=v2025.9.30 --set proxies.appscode=r.appscode.com
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i catalog-manager appscode/catalog-manager -n ace --create-namespace --version=v2025.9.30 --values values.yaml
```
