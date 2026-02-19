# ACE

[AppsCode Container Engine](https://github.com/appscode-cloud) - AppsCode Container Engine

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/acaas --version=v2026.2.16
$ helm upgrade -i ace appscode/acaas -n ace --create-namespace --version=v2026.2.16
```

## Introduction

This chart deploys AppsCode Container Engine on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `ace`:

```bash
$ helm upgrade -i ace appscode/acaas -n ace --create-namespace --version=v2026.2.16
```

The command deploys AppsCode Container Engine on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `ace`:

```bash
$ helm uninstall ace -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `acaas` chart and their default values.

|                    Parameter                    |                                                             Description                                                              |                   Default                    |
|-------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|
| billing.enabled                                 |                                                                                                                                      | <code>false</code>                           |
| billing-ui.enabled                              |                                                                                                                                      | <code>false</code>                           |
| deploy-ui.enabled                               |                                                                                                                                      | <code>false</code>                           |
| marketplace-api.enabled                         |                                                                                                                                      | <code>false</code>                           |
| marketplace-ui.enabled                          |                                                                                                                                      | <code>false</code>                           |
| platform-links.enabled                          |                                                                                                                                      | <code>false</code>                           |
| website.enabled                                 |                                                                                                                                      | <code>false</code>                           |
| global.nameOverride                             |                                                                                                                                      | <code>"ace"</code>                           |
| global.fullnameOverride                         |                                                                                                                                      | <code>""</code>                              |
| global.platform.host                            |                                                                                                                                      | <code>appscode.ninja</code>                  |
| global.registry                                 | Docker registry used to pull app related images                                                                                      | <code>""</code>                              |
| global.registryFQDN                             | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image} | <code>ghcr.io</code>                         |
| global.settings.caProviderClass                 |                                                                                                                                      | <code>""</code>                              |
| global.settings.secretName.platformConfig       |                                                                                                                                      | <code>""</code>                              |
| global.settings.secretName.platformUserConfig   |                                                                                                                                      | <code>""</code>                              |
| global.settings.secretName.platformSystemConfig |                                                                                                                                      | <code>""</code>                              |
| global.settings.secretName.grafanaConfig        |                                                                                                                                      | <code>""</code>                              |
| global.settings.secretName.objstore             |                                                                                                                                      | <code>""</code>                              |
| global.settings.secretName.nats                 |                                                                                                                                      | <code>""</code>                              |
| global.settings.secretName.spreadsheet          |                                                                                                                                      | <code>""</code>                              |
| global.settings.spreadsheetCredentialMountPath  |                                                                                                                                      | <code>"/data/marketplace-credentials"</code> |
| global.distro.openshift                         |                                                                                                                                      | <code>false</code>                           |
| global.distro.ubi                               |                                                                                                                                      | <code>""</code>                              |
| httpRoute.annotations                           |                                                                                                                                      | <code>{}</code>                              |
| httpRoute.enabled                               |                                                                                                                                      | <code>false</code>                           |
| httpRoute.gatewayClassName                      |                                                                                                                                      | <code>ace</code>                             |
| httpRoute.tls.enable                            |                                                                                                                                      | <code>true</code>                            |
| httpRoute.tls.secret.name                       |                                                                                                                                      | <code>"ace-cert"</code>                      |
| ingress.enabled                                 |                                                                                                                                      | <code>true</code>                            |
| ingress.className                               |                                                                                                                                      | <code>"nginx-ace"</code>                     |
| ingress.tls.enable                              |                                                                                                                                      | <code>true</code>                            |
| ingress.tls.secret.name                         |                                                                                                                                      | <code>"ace-cert"</code>                      |
| ingress.rules.blog.upstream                     |                                                                                                                                      | <code>""</code>                              |
| ingress.rules.docs.upstream                     |                                                                                                                                      | <code>""</code>                              |
| ingress.rules.learn.upstream                    |                                                                                                                                      | <code>""</code>                              |
| ingress.rules.license.upstream                  |                                                                                                                                      | <code>""</code>                              |
| ingress.rules.selfhost.upstream                 |                                                                                                                                      | <code>""</code>                              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i ace appscode/acaas -n ace --create-namespace --version=v2026.2.16 --set global.nameOverride="ace"
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i ace appscode/acaas -n ace --create-namespace --version=v2026.2.16 --values values.yaml
```
