# Cloudflare DNS Proxy

[Cloudflare DNS Proxy by AppsCode](https://github.com/bytebuilders) - Cloudflare DNS Proxy

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/dns-proxy --version=v2023.03.23
$ helm upgrade -i dns-proxy appscode/dns-proxy -n ace-system --create-namespace --version=v2023.03.23
```

## Introduction

This chart deploys a Cloudflare DNS Proxy server on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `dns-proxy`:

```bash
$ helm upgrade -i dns-proxy appscode/dns-proxy -n ace-system --create-namespace --version=v2023.03.23
```

The command deploys a Cloudflare DNS Proxy server on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `dns-proxy`:

```bash
$ helm uninstall dns-proxy -n ace-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `dns-proxy` chart and their default values.

|                 Parameter                  |                                                                             Description                                                                             |                                                                                            Default                                                                                             |
|--------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| replicaCount                               |                                                                                                                                                                     | <code>1</code>                                                                                                                                                                                 |
| registryFQDN                               | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                | <code>ghcr.io</code>                                                                                                                                                                           |
| image.registry                             | Docker registry used to pull app container image                                                                                                                    | <code>appscode</code>                                                                                                                                                                          |
| image.repository                           | App container image                                                                                                                                                 | <code>cloudflare-dns-proxy</code>                                                                                                                                                              |
| image.tag                                  | Overrides the image tag whose default is the chart appVersion.                                                                                                      | <code>""</code>                                                                                                                                                                                |
| image.pullPolicy                           |                                                                                                                                                                     | <code>IfNotPresent</code>                                                                                                                                                                      |
| imagePullSecrets                           |                                                                                                                                                                     | <code>[]</code>                                                                                                                                                                                |
| nameOverride                               |                                                                                                                                                                     | <code>""</code>                                                                                                                                                                                |
| fullnameOverride                           |                                                                                                                                                                     | <code>""</code>                                                                                                                                                                                |
| serviceAccount.name                        |                                                                                                                                                                     | <code>""</code>                                                                                                                                                                                |
| podAnnotations                             |                                                                                                                                                                     | <code>{}</code>                                                                                                                                                                                |
| podSecurityContext                         |                                                                                                                                                                     | <code>{}</code>                                                                                                                                                                                |
| securityContext                            | Security options this container should run with                                                                                                                     | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| service.type                               |                                                                                                                                                                     | <code>ClusterIP</code>                                                                                                                                                                         |
| service.port                               |                                                                                                                                                                     | <code>80</code>                                                                                                                                                                                |
| ingress.enabled                            |                                                                                                                                                                     | <code>false</code>                                                                                                                                                                             |
| ingress.className                          |                                                                                                                                                                     | <code>""</code>                                                                                                                                                                                |
| ingress.annotations                        |                                                                                                                                                                     | <code>{}</code>                                                                                                                                                                                |
| ingress.hosts                              | kubernetes.io/ingress.class: nginx kubernetes.io/tls-acme: "true"                                                                                                   | <code>[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]</code>                                                                                       |
| ingress.tls                                |                                                                                                                                                                     | <code>[]</code>                                                                                                                                                                                |
| resources                                  |                                                                                                                                                                     | <code>{}</code>                                                                                                                                                                                |
| autoscaling.enabled                        |                                                                                                                                                                     | <code>false</code>                                                                                                                                                                             |
| autoscaling.minReplicas                    |                                                                                                                                                                     | <code>1</code>                                                                                                                                                                                 |
| autoscaling.maxReplicas                    |                                                                                                                                                                     | <code>100</code>                                                                                                                                                                               |
| autoscaling.targetCPUUtilizationPercentage |                                                                                                                                                                     | <code>80</code>                                                                                                                                                                                |
| nodeSelector                               |                                                                                                                                                                     | <code>{}</code>                                                                                                                                                                                |
| tolerations                                |                                                                                                                                                                     | <code>[]</code>                                                                                                                                                                                |
| affinity                                   |                                                                                                                                                                     | <code>{}</code>                                                                                                                                                                                |
| monitoring.agent                           | Name of monitoring agent (eg "prometheus.io/operator")                                                                                                              | <code>""</code>                                                                                                                                                                                |
| monitoring.port                            |                                                                                                                                                                     | <code>8080</code>                                                                                                                                                                              |
| monitoring.serviceMonitor.labels           | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/operator`. | <code>{}</code>                                                                                                                                                                                |
| cloudflare.token                           |                                                                                                                                                                     | <code>""</code>                                                                                                                                                                                |
| auth.domain                                |                                                                                                                                                                     | <code>""</code>                                                                                                                                                                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i dns-proxy appscode/dns-proxy -n ace-system --create-namespace --version=v2023.03.23 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i dns-proxy appscode/dns-proxy -n ace-system --create-namespace --version=v2023.03.23 --values values.yaml
```
