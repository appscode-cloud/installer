# ACE Centralized Vault Service

[ACE Centralized Vault Service by AppsCode](https://github.com/appscode-cloud) - ACE Centralized Vault Service

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/service-vault --version=v2026.9.11
$ helm upgrade -i service-vault appscode/service-vault -n ace --create-namespace --version=v2026.9.11
```

## Introduction

This chart deploys ACE Centralized Vault Service on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `service-vault`:

```bash
$ helm upgrade -i service-vault appscode/service-vault -n ace --create-namespace --version=v2026.9.11
```

The command deploys ACE Centralized Vault Service on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `service-vault`:

```bash
$ helm uninstall service-vault -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `service-vault` chart and their default values.

|                Parameter                 |                                                 Description                                                 |                            Default                             |
|------------------------------------------|-------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------|
| nameOverride                             | Overrides name template                                                                                     | <code>""</code>                                                |
| fullnameOverride                         | Overrides fullname template                                                                                 | <code>""</code>                                                |
| infra.host                               |                                                                                                             | <code>chart-example.local</code>                               |
| infra.hostType                           |                                                                                                             | <code>domain</code>                                            |
| infra.tenantSpreadPolicy                 |                                                                                                             | <code>"multi"</code>                                           |
| infra.tls.issuer                         |                                                                                                             | <code>"ca" # ca,letsencrypt,letsencrypt-staging</code>         |
| infra.tls.ca.cert                        |                                                                                                             | <code>""</code>                                                |
| infra.tls.ca.key                         |                                                                                                             | <code>""</code>                                                |
| infra.tls.acme.email                     |                                                                                                             | <code>ops@appscode.com</code>                                  |
| infra.tls.acme.solver                    |                                                                                                             | <code>Gateway</code>                                           |
| infra.tls.acme.gatewayName               |                                                                                                             | <code>backend</code>                                           |
| infra.tls.certificate.cert               |                                                                                                             | <code>""</code>                                                |
| infra.tls.certificate.key                |                                                                                                             | <code>""</code>                                                |
| infra.tls.jks.keystore                   |                                                                                                             | <code></code>                                                  |
| infra.tls.jks.truststore                 |                                                                                                             | <code></code>                                                  |
| infra.tls.jks.password                   |                                                                                                             | <code>""</code>                                                |
| infra.dns.provider                       |                                                                                                             | <code>"external" # external,cloudflare,route53,cloudDNS</code> |
| infra.dns.auth                           |                                                                                                             | <code>{}</code>                                                |
| gateway-dns.enabled                      |                                                                                                             | <code>false</code>                                             |
| vaultServer.name                         | Vault server name that exist on cluster                                                                     | <code>"vault"</code>                                           |
| vaultServer.version                      |                                                                                                             | <code>sigilr-2.6.1.1</code>                                    |
| vaultServer.replicas                     |                                                                                                             | <code>3</code>                                                 |
| vaultServer.isolateTenants               | propagated to the spoke's AppBinding; set false for the root case                                           | <code>true</code>                                              |
| vaultServer.serviceType                  | ClusterIP | LoadBalancer | NodePort LoadBalancer and NodePort emit spec.serviceTemplates on the VaultServer | <code>ClusterIP</code>                                         |
| vaultServer.terminationPolicy            |                                                                                                             | <code>WipeOut</code>                                           |
| vaultServer.persistence.storageClassName |                                                                                                             | <code>""</code>                                                |
| vaultServer.persistence.size             |                                                                                                             | <code>1Gi</code>                                               |
| vaultServer.unsealer.secretShares        |                                                                                                             | <code>5</code>                                                 |
| vaultServer.unsealer.secretThreshold     |                                                                                                             | <code>3</code>                                                 |
| vaultServer.tls.caSecretName             | cert-manager CA secret backing the vault issuer; empty means a selfSigned issuer                            | <code>vault-ca</code>                                          |
| vaultServer.relay.clusterSet             |                                                                                                             | <code>cp-dbaas-generic</code>                                  |
| vaultServer.relay.namespace              |                                                                                                             | <code>vault-relay-demo</code>                                  |
| vaultServer.relay.bootstrapTokenTTL      |                                                                                                             | <code>24h</code>                                               |
| distro.openshift                         |                                                                                                             | <code>false</code>                                             |
| distro.ubi                               |                                                                                                             | <code>""</code>                                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i service-vault appscode/service-vault -n ace --create-namespace --version=v2026.9.11 --set infra.host=chart-example.local
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i service-vault appscode/service-vault -n ace --create-namespace --version=v2026.9.11 --values values.yaml
```
