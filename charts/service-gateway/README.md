# ACE Service Gateway

[ACE Service Gateway by AppsCode](https://github.com/appscode-cloud) - ACE Service Gateway

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/service-gateway --version=v2026.1.15
$ helm upgrade -i service-gateway appscode/service-gateway -n ace --create-namespace --version=v2026.1.15
```

## Introduction

This chart deploys ACE Service Gateway on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `service-gateway`:

```bash
$ helm upgrade -i service-gateway appscode/service-gateway -n ace --create-namespace --version=v2026.1.15
```

The command deploys ACE Service Gateway on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `service-gateway`:

```bash
$ helm uninstall service-gateway -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `service-gateway` chart and their default values.

|                     Parameter                      |                            Description                             |                                                                                                      Default                                                                                                      |
|----------------------------------------------------|--------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| nameOverride                                       | Overrides name template                                            | <code>""</code>                                                                                                                                                                                                   |
| fullnameOverride                                   | Overrides fullname template                                        | <code>""</code>                                                                                                                                                                                                   |
| clusterMetadata.uid                                |                                                                    | <code>tbd</code>                                                                                                                                                                                                  |
| clusterMetadata.name                               |                                                                    | <code>tbd</code>                                                                                                                                                                                                  |
| gatewayClass.annotations                           |                                                                    | <code>{}</code>                                                                                                                                                                                                   |
| gatewayClass.description                           | catalog.appscode.com/is-default-gatewayclass: "true"               | <code>""</code>                                                                                                                                                                                                   |
| infra.host                                         |                                                                    | <code>chart-example.local</code>                                                                                                                                                                                  |
| infra.hostType                                     |                                                                    | <code>domain</code>                                                                                                                                                                                               |
| infra.tls.issuer                                   |                                                                    | <code>"ca" # ca,letsencrypt,letsencrypt-staging,external</code>                                                                                                                                                   |
| infra.tls.ca.cert                                  |                                                                    | <code>""</code>                                                                                                                                                                                                   |
| infra.tls.ca.key                                   |                                                                    | <code>""</code>                                                                                                                                                                                                   |
| infra.tls.acme.email                               |                                                                    | <code>ops@appscode.com</code>                                                                                                                                                                                     |
| infra.tls.acme.solver                              |                                                                    | <code>Gateway</code>                                                                                                                                                                                              |
| infra.tls.acme.gatewayName                         |                                                                    | <code>backend</code>                                                                                                                                                                                              |
| infra.tls.certificate.cert                         |                                                                    | <code>""</code>                                                                                                                                                                                                   |
| infra.tls.certificate.key                          |                                                                    | <code>""</code>                                                                                                                                                                                                   |
| infra.tls.jks.keystore                             |                                                                    | <code></code>                                                                                                                                                                                                     |
| infra.tls.jks.truststore                           |                                                                    | <code></code>                                                                                                                                                                                                     |
| infra.tls.jks.password                             |                                                                    | <code>""</code>                                                                                                                                                                                                   |
| infra.dns.provider                                 |                                                                    | <code>"external" # external,cloudflare,route53,cloudDNS</code>                                                                                                                                                    |
| infra.dns.auth                                     |                                                                    | <code>{}</code>                                                                                                                                                                                                   |
| gateway.gateway-converter.enabled                  |                                                                    | <code>false</code>                                                                                                                                                                                                |
| gateway.config.envoyGateway.gateway.controllerName |                                                                    | <code>gateway.voyagermesh.com/ace</code>                                                                                                                                                                          |
| gateway.config.envoyGateway.extensionApis          |                                                                    | <code>{}</code>                                                                                                                                                                                                   |
| gateway.deployment.priorityClassName               |                                                                    | <code>system-cluster-critical</code>                                                                                                                                                                              |
| gateway.deployment.annotations                     |                                                                    | <code>{}</code>                                                                                                                                                                                                   |
| gateway.hpa.enabled                                |                                                                    | <code>false</code>                                                                                                                                                                                                |
| gateway.hpa.behavior                               |                                                                    | <code>{}</code>                                                                                                                                                                                                   |
| gateway.hpa.maxReplicas                            |                                                                    | <code>0</code>                                                                                                                                                                                                    |
| gateway.hpa.metrics                                |                                                                    | <code>[]</code>                                                                                                                                                                                                   |
| gateway.hpa.minReplicas                            |                                                                    | <code>0</code>                                                                                                                                                                                                    |
| gateway.service.annotations                        |                                                                    | <code>{}</code>                                                                                                                                                                                                   |
| gateway.service.trafficDistribution                |                                                                    | <code>""</code>                                                                                                                                                                                                   |
| gateway.topologyInjector.enabled                   |                                                                    | <code>false</code>                                                                                                                                                                                                |
| gateway.topologyInjector.annotations               |                                                                    | <code>{}</code>                                                                                                                                                                                                   |
| gateway-dns.enabled                                |                                                                    | <code>false</code>                                                                                                                                                                                                |
| cluster.tls.issuer                                 | possible values: ca,none,vault. none for client orgs, ca othereise | <code>"ca"</code>                                                                                                                                                                                                 |
| cluster.tls.ca.cert                                |                                                                    | <code>""</code>                                                                                                                                                                                                   |
| cluster.tls.ca.key                                 |                                                                    | <code>""</code>                                                                                                                                                                                                   |
| envoy.provisionerType                              |                                                                    | <code>Deployment # DaemonSet</code>                                                                                                                                                                               |
| envoy.image                                        |                                                                    | <code>ghcr.io/voyagermesh/envoy</code>                                                                                                                                                                            |
| envoy.tag                                          |                                                                    | <code>"v1.35.6-ac"</code>                                                                                                                                                                                         |
| envoy.service.portRange                            | Default listener portmanager range to use for gateway exposure     | <code>"10000-12767"</code>                                                                                                                                                                                        |
| envoy.service.nodeportRange                        | Default node portmanager range to use for gateway exposure         | <code>"30000-32767"</code>                                                                                                                                                                                        |
| envoy.service.seedBackendPort                      |                                                                    | <code>8080</code>                                                                                                                                                                                                 |
| envoy.service.type                                 |                                                                    | <code>LoadBalancer # ClusterIP, LoadBalancer, NodePort</code>                                                                                                                                                     |
| envoy.service.externalTrafficPolicy                |                                                                    | <code>Cluster # Local</code>                                                                                                                                                                                      |
| envoy.nodeSelector                                 |                                                                    | <code>{}</code>                                                                                                                                                                                                   |
| envoy.securityContext                              |                                                                    | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code>                               |
| echoserver.image                                   |                                                                    | <code>ghcr.io/voyagermesh/echoserver</code>                                                                                                                                                                       |
| echoserver.tag                                     |                                                                    | <code>"v20221109"</code>                                                                                                                                                                                          |
| echoserver.securityContext                         |                                                                    | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| vaultServer.name                                   | Vault server name that exist on cluster                            | <code>"vault"</code>                                                                                                                                                                                              |
| vaultServer.namespace                              | Vault server namespace that exist on cluster                       | <code>"ace"</code>                                                                                                                                                                                                |
| distro.openshift                                   |                                                                    | <code>false</code>                                                                                                                                                                                                |
| distro.ubi                                         |                                                                    | <code>""</code>                                                                                                                                                                                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i service-gateway appscode/service-gateway -n ace --create-namespace --version=v2026.1.15 --set clusterMetadata.uid=tbd
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i service-gateway appscode/service-gateway -n ace --create-namespace --version=v2026.1.15 --values values.yaml
```
