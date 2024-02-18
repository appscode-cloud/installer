# ACE UI Presets for CAPI

[ACE UI Presets for CAPI by AppsCode](https://github.com/bytebuilders) - ACE UI presets for Monitoring

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/service-presets --version=v2024.2.11
$ helm upgrade -i service-presets appscode/service-presets -n ace --create-namespace --version=v2024.2.11
```

## Introduction

This chart deploys ACE UI presets for Monitoring on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `service-presets`:

```bash
$ helm upgrade -i service-presets appscode/service-presets -n ace --create-namespace --version=v2024.2.11
```

The command deploys ACE UI presets for Monitoring on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `service-presets`:

```bash
$ helm uninstall service-presets -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `service-presets` chart and their default values.

|                   Parameter                   |                                                                                                                  Description                                                                                                                   |                            Default                             |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------|
| nameOverride                                  | Overrides name template                                                                                                                                                                                                                        | <code>""</code>                                                |
| fullnameOverride                              | Overrides fullname template                                                                                                                                                                                                                    | <code>""</code>                                                |
| replicaCount                                  |                                                                                                                                                                                                                                                | <code>1</code>                                                 |
| registryFQDN                                  | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                                                                                           | <code>ghcr.io</code>                                           |
| image.registry                                | Docker registry used to pull app container image                                                                                                                                                                                               | <code>appscode</code>                                          |
| image.repository                              | App container image                                                                                                                                                                                                                            | <code>b3</code>                                                |
| image.tag                                     | Overrides the image tag whose default is the chart appVersion.                                                                                                                                                                                 | <code>""</code>                                                |
| image.pullPolicy                              |                                                                                                                                                                                                                                                | <code>Always</code>                                            |
| podAnnotations                                |                                                                                                                                                                                                                                                | <code>{}</code>                                                |
| podSecurityContext                            |                                                                                                                                                                                                                                                | <code>{}</code>                                                |
| securityContext                               |                                                                                                                                                                                                                                                | <code>{}</code>                                                |
| resources                                     |                                                                                                                                                                                                                                                | <code>{}</code>                                                |
| nodeSelector                                  |                                                                                                                                                                                                                                                | <code>{}</code>                                                |
| tolerations                                   |                                                                                                                                                                                                                                                | <code>[]</code>                                                |
| affinity                                      |                                                                                                                                                                                                                                                | <code>{}</code>                                                |
| imagePullSecrets                              | Specify an array of imagePullSecrets. Secrets must be manually created in the namespace. <br> Example: <br> `helm template charts/ace \` <br> `--set global.imagePullSecrets[0].name=sec0 \` <br> `--set global.imagePullSecrets[1].name=sec1` | <code>[]</code>                                                |
| serviceAccount.create                         | Specifies whether a service account should be created                                                                                                                                                                                          | <code>true</code>                                              |
| serviceAccount.annotations                    | Annotations to add to the service account                                                                                                                                                                                                      | <code>{}</code>                                                |
| serviceAccount.name                           | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                                                                                                                         | <code>""</code>                                                |
| monitoring.agent                              | Name of monitoring agent (eg "prometheus.io/operator")                                                                                                                                                                                         | <code>""</code>                                                |
| monitoring.serviceMonitor.labels              | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/operator`.                                                                            | <code>{}</code>                                                |
| monitoring.exporter.resources.requests.memory | cpu: 100m                                                                                                                                                                                                                                      | <code>128Mi</code>                                             |
| infra.clusterName                             |                                                                                                                                                                                                                                                | <code>"c1"</code>                                              |
| infra.gatewayDomain                           |                                                                                                                                                                                                                                                | <code>chart-example.local</code>                               |
| infra.tls.issuer                              |                                                                                                                                                                                                                                                | <code>"ca" # ca,letsencrypt,letsencrypt-staging</code>         |
| infra.tls.ca.cert                             |                                                                                                                                                                                                                                                | <code>""</code>                                                |
| infra.tls.ca.key                              |                                                                                                                                                                                                                                                | <code>""</code>                                                |
| infra.tls.acme.email                          |                                                                                                                                                                                                                                                | <code>ops@appscode.com</code>                                  |
| infra.tls.certificate.cert                    |                                                                                                                                                                                                                                                | <code>""</code>                                                |
| infra.tls.certificate.key                     |                                                                                                                                                                                                                                                | <code>""</code>                                                |
| infra.dns.provider                            |                                                                                                                                                                                                                                                | <code>"external" # external,cloudflare,route53,cloudDNS</code> |
| infra.dns.auth                                |                                                                                                                                                                                                                                                | <code>{}</code>                                                |
| gateway-dns.enabled                           |                                                                                                                                                                                                                                                | <code>false</code>                                             |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i service-presets appscode/service-presets -n ace --create-namespace --version=v2024.2.11 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i service-presets appscode/service-presets -n ace --create-namespace --version=v2024.2.11 --values values.yaml
```
