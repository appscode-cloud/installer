# AKP Prereqs

[AKP Prereqs by AppsCode](https://github.com/appscode-cloud) - Postgres, Casdoor, NATS identities and the gateway certificate for AKP v2

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/akp-prereqs --version=v2026.11.15
$ helm upgrade -i akp-prereqs appscode/akp-prereqs -n akp --create-namespace --version=v2026.11.15
```

## Introduction

This chart deploys an AKP Prereqs on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+
- A default StorageClass (or set persistence.storageClassName)

## Installing the Chart

To install/upgrade the chart with the release name `akp-prereqs`:

```bash
$ helm upgrade -i akp-prereqs appscode/akp-prereqs -n akp --create-namespace --version=v2026.11.15
```

The command deploys an AKP Prereqs on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `akp-prereqs`:

```bash
$ helm uninstall akp-prereqs -n akp
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `akp-prereqs` chart and their default values.

|             Parameter              |                                              Description                                              |                    Default                    |
|------------------------------------|-------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| global.platform.host               | The one public host, a DNS name (not an address). Casdoor is served at `casdoor.<host>`.              | <code>akp.10.2.0.73.nip.io</code>             |
| global.httpsPort                   | The public HTTPS port, when it is not 443 (used in Casdoor's URLs).                                   | <code>443</code>                              |
| global.imagePullSecrets            |                                                                                                       | <code>[]</code>                               |
| gateway.name                       |                                                                                                       | <code>ace</code>                              |
| gateway.sectionName                |                                                                                                       | <code>https</code>                            |
| tls.secretName                     |                                                                                                       | <code>ace-gw-cert</code>                      |
| tls.validityDays                   |                                                                                                       | <code>3650</code>                             |
| persistence.storageClassName       |                                                                                                       | <code>""</code>                               |
| persistence.postgres               |                                                                                                       | <code>5Gi</code>                              |
| postgres.image.repository          |                                                                                                       | <code>ghcr.io/appscode-images/postgres</code> |
| postgres.image.tag                 |                                                                                                       | <code>18.3-bookworm</code>                    |
| postgres.image.digest              |                                                                                                       | <code>""</code>                               |
| postgres.image.pullPolicy          |                                                                                                       | <code>IfNotPresent</code>                     |
| postgres.databases.akp.name        |                                                                                                       | <code>akp</code>                              |
| postgres.databases.akp.user        |                                                                                                       | <code>akp</code>                              |
| postgres.databases.casdoor.name    |                                                                                                       | <code>casdoor</code>                          |
| postgres.databases.casdoor.user    |                                                                                                       | <code>casdoor</code>                          |
| postgres.resources.requests.cpu    |                                                                                                       | <code>250m</code>                             |
| postgres.resources.requests.memory |                                                                                                       | <code>512Mi</code>                            |
| casdoor.image.repository           |                                                                                                       | <code>ghcr.io/appscode/casdoor</code>         |
| casdoor.image.tag                  |                                                                                                       | <code>v4.29.0-3391e5fe</code>                 |
| casdoor.image.digest               |                                                                                                       | <code>""</code>                               |
| casdoor.image.pullPolicy           |                                                                                                       | <code>IfNotPresent</code>                     |
| casdoor.host                       | Host the browser reaches Casdoor at. Empty: `casdoor.<global.platform.host>`.                         | <code>""</code>                               |
| casdoor.organization               | One organization, one application (b3's iam signs people in through it).                              | <code>akp</code>                              |
| casdoor.application.name           |                                                                                                       | <code>akp</code>                              |
| casdoor.application.clientId       |                                                                                                       | <code>akp</code>                              |
| casdoor.iamPublicPath              | Redirect URI of the application: <public URL><iam publicPath>/casdoor/callback (b3's hosted sign-in). | <code>/iam</code>                             |
| casdoor.mfaRule                    | Second factors: Optional, Prompt or Required (an organization setting).                               | <code>Optional</code>                         |
| casdoor.admin.username             |                                                                                                       | <code>admin</code>                            |
| casdoor.admin.email                |                                                                                                       | <code>admin@akp.local</code>                  |
| casdoor.admin.displayName          |                                                                                                       | <code>Administrator</code>                    |
| casdoor.resources.requests.cpu     |                                                                                                       | <code>100m</code>                             |
| casdoor.resources.requests.memory  |                                                                                                       | <code>256Mi</code>                            |
| nats.natsBox.repository            |                                                                                                       | <code>natsio/nats-box</code>                  |
| nats.natsBox.tag                   |                                                                                                       | <code>0.19.2</code>                           |
| nats.natsBox.digest                |                                                                                                       | <code>""</code>                               |
| nats.natsBox.pullPolicy            |                                                                                                       | <code>IfNotPresent</code>                     |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i akp-prereqs appscode/akp-prereqs -n akp --create-namespace --version=v2026.11.15 --set global.platform.host=akp.10.2.0.73.nip.io
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i akp-prereqs appscode/akp-prereqs -n akp --create-namespace --version=v2026.11.15 --values values.yaml
```
