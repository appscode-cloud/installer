# ACE Service Gateway Presets

[ACE Service Gateway Presets by AppsCode](https://github.com/appscode-cloud) - ACE Service Gateway Presets

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/service-gateway-presets --version=v2024.10.17
$ helm upgrade -i service-gateway-presets appscode/service-gateway-presets -n ace --create-namespace --version=v2024.10.17
```

## Introduction

This chart deploys ACE Service Gateway Presets on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `service-gateway-presets`:

```bash
$ helm upgrade -i service-gateway-presets appscode/service-gateway-presets -n ace --create-namespace --version=v2024.10.17
```

The command deploys ACE Service Gateway Presets on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `service-gateway-presets`:

```bash
$ helm uninstall service-gateway-presets -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `service-gateway-presets` chart and their default values.

|         Parameter          |         Description         |                                                                                                      Default                                                                                                      |
|----------------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| nameOverride               | Overrides name template     | <code>""</code>                                                                                                                                                                                                   |
| fullnameOverride           | Overrides fullname template | <code>""</code>                                                                                                                                                                                                   |
| infra.clusterName          |                             | <code>"c1"</code>                                                                                                                                                                                                 |
| infra.host                 |                             | <code>chart-example.local</code>                                                                                                                                                                                  |
| infra.hostType             |                             | <code>domain</code>                                                                                                                                                                                               |
| infra.tls.issuer           |                             | <code>"ca" # ca,letsencrypt,letsencrypt-staging</code>                                                                                                                                                            |
| infra.tls.ca.cert          |                             | <code>""</code>                                                                                                                                                                                                   |
| infra.tls.ca.key           |                             | <code>""</code>                                                                                                                                                                                                   |
| infra.tls.acme.email       |                             | <code>ops@appscode.com</code>                                                                                                                                                                                     |
| infra.tls.acme.solver      |                             | <code>Gateway</code>                                                                                                                                                                                              |
| infra.tls.certificate.cert |                             | <code>""</code>                                                                                                                                                                                                   |
| infra.tls.certificate.key  |                             | <code>""</code>                                                                                                                                                                                                   |
| infra.tls.jks.keystore     |                             | <code></code>                                                                                                                                                                                                     |
| infra.tls.jks.truststore   |                             | <code></code>                                                                                                                                                                                                     |
| infra.tls.jks.password     |                             | <code>""</code>                                                                                                                                                                                                   |
| infra.dns.provider         |                             | <code>"external" # external,cloudflare,route53,cloudDNS</code>                                                                                                                                                    |
| infra.dns.auth             |                             | <code>{}</code>                                                                                                                                                                                                   |
| gateway-dns.enabled        |                             | <code>false</code>                                                                                                                                                                                                |
| cluster.tls.issuer         |                             | <code>"ca" # ca,vault</code>                                                                                                                                                                                      |
| cluster.tls.ca.cert        |                             | <code>""</code>                                                                                                                                                                                                   |
| cluster.tls.ca.key         |                             | <code>""</code>                                                                                                                                                                                                   |
| envoy.image                |                             | <code>ghcr.io/voyagermesh/envoy</code>                                                                                                                                                                            |
| envoy.tag                  |                             | <code>"v1.29.9-ac"</code>                                                                                                                                                                                         |
| envoy.securityContext      |                             | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code>                               |
| echoserver.image           |                             | <code>ghcr.io/voyagermesh/echoserver</code>                                                                                                                                                                       |
| echoserver.tag             |                             | <code>"v20221109"</code>                                                                                                                                                                                          |
| echoserver.securityContext |                             | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i service-gateway-presets appscode/service-gateway-presets -n ace --create-namespace --version=v2024.10.17 --set infra.clusterName="c1"
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i service-gateway-presets appscode/service-gateway-presets -n ace --create-namespace --version=v2024.10.17 --values values.yaml
```
