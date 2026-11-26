# Casdoor

[Casdoor by AppsCode](https://github.com/appscode-cloud) - Casdoor, the identity provider behind AKP, the Trust Console and the patch console

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/casdoor --version=v2026.11.15
$ helm upgrade -i casdoor appscode/casdoor -n ace --create-namespace --version=v2026.11.15
```

## Introduction

This chart deploys a Casdoor on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `casdoor`:

```bash
$ helm upgrade -i casdoor appscode/casdoor -n ace --create-namespace --version=v2026.11.15
```

The command deploys a Casdoor on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `casdoor`:

```bash
$ helm uninstall casdoor -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `casdoor` chart and their default values.

|         Parameter         |                                                                                        Description                                                                                        |           Default           |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------|
| replicaCount              |                                                                                                                                                                                           | <code>1</code>              |
| registryFQDN              | Docker registry fqdn used to pull app related images.                                                                                                                                     | <code>ghcr.io</code>        |
| image.registry            | Docker registry used to pull app container image                                                                                                                                          | <code>appscode</code>       |
| image.repository          |                                                                                                                                                                                           | <code>casdoor</code>        |
| image.tag                 | Overrides the image tag whose default is the chart appVersion.                                                                                                                            | <code>""</code>             |
| image.digest              | A digest ("sha256:...") wins over the tag.                                                                                                                                                | <code>""</code>             |
| image.pullPolicy          |                                                                                                                                                                                           | <code>IfNotPresent</code>   |
| imagePullSecrets          |                                                                                                                                                                                           | <code>[]</code>             |
| nameOverride              |                                                                                                                                                                                           | <code>""</code>             |
| fullnameOverride          |                                                                                                                                                                                           | <code>""</code>             |
| podAnnotations            |                                                                                                                                                                                           | <code>{}</code>             |
| podSecurityContext        |                                                                                                                                                                                           | <code>{}</code>             |
| securityContext           |                                                                                                                                                                                           | <code>{}</code>             |
| service.port              |                                                                                                                                                                                           | <code>8000</code>           |
| resources.requests.cpu    |                                                                                                                                                                                           | <code>100m</code>           |
| resources.requests.memory |                                                                                                                                                                                           | <code>256Mi</code>          |
| nodeSelector              |                                                                                                                                                                                           | <code>{}</code>             |
| tolerations               |                                                                                                                                                                                           | <code>[]</code>             |
| affinity                  |                                                                                                                                                                                           | <code>{}</code>             |
| publicUrl                 | The URL the browser reaches Casdoor at. Empty: `https://casdoor.<global.platform.host>`, with `:<global.platform.httpsPort>` when that is not 443. Casdoor cannot be served under a path. | <code>""</code>             |
| database.host             |                                                                                                                                                                                           | <code>""</code>             |
| database.port             |                                                                                                                                                                                           | <code>5432</code>           |
| database.name             |                                                                                                                                                                                           | <code>casdoor</code>        |
| database.user             |                                                                                                                                                                                           | <code>postgres</code>       |
| database.password         |                                                                                                                                                                                           | <code>""</code>             |
| database.sslmode          |                                                                                                                                                                                           | <code>disable</code>        |
| adminPassword             | Password of Casdoor's built-in `admin` (organization `built-in`).                                                                                                                         | <code>""</code>             |
| organization.name         |                                                                                                                                                                                           | <code>akp</code>            |
| organization.displayName  |                                                                                                                                                                                           | <code>AKP</code>            |
| organization.mfaRule      | Optional, Prompt or Required.                                                                                                                                                             | <code>Optional</code>       |
| jwt.certificate           |                                                                                                                                                                                           | <code>""</code>             |
| jwt.privateKey            |                                                                                                                                                                                           | <code>""</code>             |
| applications              | Seeded into an empty Casdoor database only (initDataNewOnly): later changes are not applied. - name, displayName, clientId, clientSecret, redirectUris: [...]                             | <code>[]</code>             |
| users                     | The first people of the organization: name, displayName, email, password, tag.                                                                                                            | <code>[]</code>             |
| global.platform.host      |                                                                                                                                                                                           | <code>appscode.ninja</code> |
| global.platform.httpsPort | The public HTTPS port when it is not 443.                                                                                                                                                 | <code>443</code>            |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i casdoor appscode/casdoor -n ace --create-namespace --version=v2026.11.15 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i casdoor appscode/casdoor -n ace --create-namespace --version=v2026.11.15 --values values.yaml
```
