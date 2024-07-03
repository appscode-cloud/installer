# Cloudflare DNS Proxy

[Cloudflare DNS Proxy by AppsCode](https://github.com/appscode-cloud) - Cloudflare DNS Proxy

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/service-backend --version=v2024.2.11
$ helm upgrade -i service-backend appscode/service-backend -n ace --create-namespace --version=v2024.2.11
```

## Introduction

This chart deploys a Cloudflare DNS Proxy server on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `service-backend`:

```bash
$ helm upgrade -i service-backend appscode/service-backend -n ace --create-namespace --version=v2024.2.11
```

The command deploys a Cloudflare DNS Proxy server on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `service-backend`:

```bash
$ helm uninstall service-backend -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `service-backend` chart and their default values.

|                 Parameter                  |                                                                                                                     Description                                                                                                                      |                                                                       Default                                                                       |
|--------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| replicaCount                               |                                                                                                                                                                                                                                                      | <code>1</code>                                                                                                                                      |
| registryFQDN                               | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                                                                                                 | <code>ghcr.io</code>                                                                                                                                |
| image.registry                             | Docker registry used to pull app container image                                                                                                                                                                                                     | <code>appscode</code>                                                                                                                               |
| image.repository                           | App container image                                                                                                                                                                                                                                  | <code>service-provider</code>                                                                                                                       |
| image.tag                                  | Overrides the image tag whose default is the chart appVersion.                                                                                                                                                                                       | <code>""</code>                                                                                                                                     |
| image.pullPolicy                           |                                                                                                                                                                                                                                                      | <code>IfNotPresent</code>                                                                                                                           |
| imagePullSecrets                           |                                                                                                                                                                                                                                                      | <code>[]</code>                                                                                                                                     |
| nameOverride                               |                                                                                                                                                                                                                                                      | <code>""</code>                                                                                                                                     |
| fullnameOverride                           |                                                                                                                                                                                                                                                      | <code>""</code>                                                                                                                                     |
| serviceAccount.name                        |                                                                                                                                                                                                                                                      | <code>""</code>                                                                                                                                     |
| podAnnotations                             |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                     |
| podSecurityContext                         |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                     |
| securityContext                            | Security options this container should run with                                                                                                                                                                                                      | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534}</code> |
| service.type                               |                                                                                                                                                                                                                                                      | <code>ClusterIP</code>                                                                                                                              |
| service.port                               |                                                                                                                                                                                                                                                      | <code>80</code>                                                                                                                                     |
| ingress.enabled                            |                                                                                                                                                                                                                                                      | <code>false</code>                                                                                                                                  |
| ingress.className                          |                                                                                                                                                                                                                                                      | <code>""</code>                                                                                                                                     |
| ingress.annotations                        |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                     |
| ingress.hosts                              | kubernetes.io/ingress.class: nginx kubernetes.io/tls-acme: "true"                                                                                                                                                                                    | <code>[]</code>                                                                                                                                     |
| ingress.tls                                | - host: chart-example.local paths: - path: / pathType: ImplementationSpecific                                                                                                                                                                        | <code>[]</code>                                                                                                                                     |
| ingress.dns.targetIPs                      |                                                                                                                                                                                                                                                      | <code>[]</code>                                                                                                                                     |
| resources                                  |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                     |
| autoscaling.enabled                        |                                                                                                                                                                                                                                                      | <code>false</code>                                                                                                                                  |
| autoscaling.minReplicas                    |                                                                                                                                                                                                                                                      | <code>1</code>                                                                                                                                      |
| autoscaling.maxReplicas                    |                                                                                                                                                                                                                                                      | <code>100</code>                                                                                                                                    |
| autoscaling.targetCPUUtilizationPercentage |                                                                                                                                                                                                                                                      | <code>80</code>                                                                                                                                     |
| nodeSelector                               |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                     |
| tolerations                                |                                                                                                                                                                                                                                                      | <code>[]</code>                                                                                                                                     |
| affinity                                   |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                     |
| monitoring.agent                           | Name of monitoring agent (one of "prometheus.io", "prometheus.io/operator", "prometheus.io/builtin")                                                                                                                                                 | <code>""</code>                                                                                                                                     |
| monitoring.serviceMonitor.labels           | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/operator`.                                                                                  | <code>{}</code>                                                                                                                                     |
| server.oidc.clientID                       | issuer client ID                                                                                                                                                                                                                                     | <code>""</code>                                                                                                                                     |
| server.oidc.clientSecret                   | issuer client Secret                                                                                                                                                                                                                                 | <code>""</code>                                                                                                                                     |
| server.oidc.baseURL                        |                                                                                                                                                                                                                                                      | <code>"https://api.appscode.com"</code>                                                                                                             |
| server.oidc.issuerURL                      |                                                                                                                                                                                                                                                      | <code>"https://accounts.appscode.com/accounts"</code>                                                                                               |
| server.oidc.callbackURL                    |                                                                                                                                                                                                                                                      | <code>"https://bind.appscode.com/bind/callback"</code>                                                                                              |
| server.namespacePrefix                     | the sync namespace created in the provider side will be named like bb-<some-hash>                                                                                                                                                                    | <code>"ace-"</code>                                                                                                                                 |
| server.consumerScope                       | How consumers access the service provider cluster. In Kubernetes, "namespaced" allows namespace isolation. In kcp, "cluster" allows workspace isolation, and with that allows cluster-scoped resources to bind, and it is generally more performant. | <code>"Namespaced"</code>                                                                                                                           |
| server.cookie.signingKey                   | The key which is used to sign cookies, base64 encoded. Valid lengths are 32 or 64 bytes.                                                                                                                                                             | <code>""</code>                                                                                                                                     |
| server.cookie.encryptionKey                | The key which is used to encrypt cookies, base64 encoded, optional. Valid lengths are 16, 24, or 32 bytes selecting AES-128, AES-192, or AES-256.                                                                                                    | <code>""</code>                                                                                                                                     |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i service-backend appscode/service-backend -n ace --create-namespace --version=v2024.2.11 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i service-backend appscode/service-backend -n ace --create-namespace --version=v2024.2.11 --values values.yaml
```
