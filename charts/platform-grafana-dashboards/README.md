# 

[platform-grafana-dashboards](https://github.com/bytebuilders/installer) - A Helm chart that deploys Platform Grafana dashboards as ConfigMaps for automatic import into Grafana.

This chart includes comprehensive dashboards for monitoring Platform servers and JetStream, providing insights into:
- Server performance metrics (CPU, memory)
- Message throughput and client connections
- JetStream storage and memory usage
- Stream and consumer metrics


## TL;DR;

```bash
$ helm repo add  
$ helm repo update
$ helm search repo /platform-grafana-dashboards --version=v2025.9.15
$ helm upgrade -i  /platform-grafana-dashboards -n  --create-namespace --version=v2025.9.15
```

## Introduction

This chart deploys  on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites


## Installing the Chart

To install/upgrade the chart with the release name ``:

```bash
$ helm upgrade -i  /platform-grafana-dashboards -n  --create-namespace --version=v2025.9.15
```

The command deploys  on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the ``:

```bash
$ helm uninstall  -n 
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `platform-grafana-dashboards` chart and their default values.

|            Parameter            |                                                                                                                       Description                                                                                                                        |                                                                                            Default                                                                                             |
|---------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| nameOverride                    | Overrides name template                                                                                                                                                                                                                                  | <code>""</code>                                                                                                                                                                                |
| fullnameOverride                | Overrides fullname template                                                                                                                                                                                                                              | <code>""</code>                                                                                                                                                                                |
| resources                       | List of Platform resources for which dashboards will be applied                                                                                                                                                                                          | <code>["nats"]</code>                                                                                                                                                                          |
| dashboard.folderID              | ID of Grafana folder where these dashboards will be applied                                                                                                                                                                                              | <code>0</code>                                                                                                                                                                                 |
| dashboard.overwrite             | If true, dashboard with matching uid will be overwritten                                                                                                                                                                                                 | <code>true</code>                                                                                                                                                                              |
| dashboard.templatize.title      | If true, datasource will be prefixed to dashboard name                                                                                                                                                                                                   | <code>false</code>                                                                                                                                                                             |
| dashboard.templatize.datasource | If true, datasource will be hardcoded in the dashboard                                                                                                                                                                                                   | <code>false</code>                                                                                                                                                                             |
| dashboard.alerts                |                                                                                                                                                                                                                                                          | <code>false</code>                                                                                                                                                                             |
| dashboard.replacements          |                                                                                                                                                                                                                                                          | <code>{}</code>                                                                                                                                                                                |
| grafana.name                    | Name of Grafana Appbinding where these dashboards are applied                                                                                                                                                                                            | <code>""</code>                                                                                                                                                                                |
| grafana.namespace               | Namespace of Grafana Appbinding where these dashboards are applied                                                                                                                                                                                       | <code>""</code>                                                                                                                                                                                |
| grafana.version                 |                                                                                                                                                                                                                                                          | <code>8.0.7</code>                                                                                                                                                                             |
| grafana.url                     |                                                                                                                                                                                                                                                          | <code>""</code>                                                                                                                                                                                |
| grafana.apikey                  |                                                                                                                                                                                                                                                          | <code>""</code>                                                                                                                                                                                |
| app.name                        |                                                                                                                                                                                                                                                          | <code>""</code>                                                                                                                                                                                |
| app.namespace                   |                                                                                                                                                                                                                                                          | <code>""</code>                                                                                                                                                                                |
| registryFQDN                    | Docker registry fqdn used to pull images Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                                                                                                                  | <code>ghcr.io</code>                                                                                                                                                                           |
| image.registry                  | Docker registry used to pull operator image                                                                                                                                                                                                              | <code>curlimages</code>                                                                                                                                                                        |
| image.repository                | Name of operator container image                                                                                                                                                                                                                         | <code>curl</code>                                                                                                                                                                              |
| image.tag                       | Operator container image tag                                                                                                                                                                                                                             | <code>"latest"</code>                                                                                                                                                                          |
| image.securityContext           | Security options this container should run with                                                                                                                                                                                                          | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| image.resources                 | Compute Resources required by this container                                                                                                                                                                                                             | <code>{}</code>                                                                                                                                                                                |
| imagePullSecrets                | Specify an array of imagePullSecrets. Secrets must be manually created in the namespace. <br> Example: <br> `helm template charts/platform-grafana-dashboards \` <br> `--set imagePullSecrets[0].name=sec0 \` <br> `--set imagePullSecrets[1].name=sec1` | <code>[]</code>                                                                                                                                                                                |
| imagePullPolicy                 | Container image pull policy                                                                                                                                                                                                                              | <code>Always</code>                                                                                                                                                                            |
| annotations                     | Annotations applied to operator deployment                                                                                                                                                                                                               | <code>{}</code>                                                                                                                                                                                |
| podAnnotations                  | Annotations passed to operator pod(s).                                                                                                                                                                                                                   | <code>{}</code>                                                                                                                                                                                |
| nodeSelector                    | Node labels for pod assignment                                                                                                                                                                                                                           | <code>{}</code>                                                                                                                                                                                |
| tolerations                     | Tolerations for pod assignment                                                                                                                                                                                                                           | <code>[]</code>                                                                                                                                                                                |
| affinity                        | Affinity rules for pod assignment                                                                                                                                                                                                                        | <code>{}</code>                                                                                                                                                                                |
| podSecurityContext              | Security options the operator pod should run with.                                                                                                                                                                                                       | <code>{"fsGroup":65534}</code>                                                                                                                                                                 |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i  /platform-grafana-dashboards -n  --create-namespace --version=v2025.9.15 --set resources=["nats"]
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i  /platform-grafana-dashboards -n  --create-namespace --version=v2025.9.15 --values values.yaml
```
