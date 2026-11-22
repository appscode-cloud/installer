# Trust Console Api

[Trust Console Api by AppsCode](https://github.com/appscode-cloud) - Trust Console hub: the API of the Trust Console

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/trust-console-api --version=v2026.11.15
$ helm upgrade -i trust-console-api appscode/trust-console-api -n ace --create-namespace --version=v2026.11.15
```

## Introduction

This chart deploys a Trust Console Api on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `trust-console-api`:

```bash
$ helm upgrade -i trust-console-api appscode/trust-console-api -n ace --create-namespace --version=v2026.11.15
```

The command deploys a Trust Console Api on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `trust-console-api`:

```bash
$ helm uninstall trust-console-api -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `trust-console-api` chart and their default values.

|               Parameter                |                                                                                                                          Description                                                                                                                           |                                                    Default                                                    |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| replicaCount                           |                                                                                                                                                                                                                                                                | <code>1</code>                                                                                                |
| registryFQDN                           | Docker registry fqdn used to pull app related images.                                                                                                                                                                                                          | <code>ghcr.io</code>                                                                                          |
| image.registry                         | Docker registry used to pull app container image                                                                                                                                                                                                               | <code>appscode</code>                                                                                         |
| image.repository                       |                                                                                                                                                                                                                                                                | <code>trust-console</code>                                                                                    |
| image.tag                              | Overrides the image tag whose default is the chart appVersion.                                                                                                                                                                                                 | <code>""</code>                                                                                               |
| image.digest                           | A digest ("sha256:...") wins over the tag.                                                                                                                                                                                                                     | <code>""</code>                                                                                               |
| image.pullPolicy                       |                                                                                                                                                                                                                                                                | <code>IfNotPresent</code>                                                                                     |
| imagePullSecrets                       |                                                                                                                                                                                                                                                                | <code>[]</code>                                                                                               |
| nameOverride                           |                                                                                                                                                                                                                                                                | <code>""</code>                                                                                               |
| fullnameOverride                       |                                                                                                                                                                                                                                                                | <code>""</code>                                                                                               |
| serviceAccount.name                    |                                                                                                                                                                                                                                                                | <code>""</code>                                                                                               |
| podAnnotations                         |                                                                                                                                                                                                                                                                | <code>{}</code>                                                                                               |
| podSecurityContext.runAsNonRoot        |                                                                                                                                                                                                                                                                | <code>true</code>                                                                                             |
| podSecurityContext.runAsUser           |                                                                                                                                                                                                                                                                | <code>65532</code>                                                                                            |
| podSecurityContext.seccompProfile.type |                                                                                                                                                                                                                                                                | <code>RuntimeDefault</code>                                                                                   |
| securityContext                        |                                                                                                                                                                                                                                                                | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}</code> |
| service.port                           |                                                                                                                                                                                                                                                                | <code>8080</code>                                                                                             |
| resources.requests.cpu                 |                                                                                                                                                                                                                                                                | <code>250m</code>                                                                                             |
| resources.requests.memory              |                                                                                                                                                                                                                                                                | <code>256Mi</code>                                                                                            |
| resources.limits.memory                |                                                                                                                                                                                                                                                                | <code>2Gi</code>                                                                                              |
| nodeSelector                           |                                                                                                                                                                                                                                                                | <code>{}</code>                                                                                               |
| tolerations                            |                                                                                                                                                                                                                                                                | <code>[]</code>                                                                                               |
| affinity                               |                                                                                                                                                                                                                                                                | <code>{}</code>                                                                                               |
| org                                    | The organization the hub serves (the hub is one organization per install).                                                                                                                                                                                     | <code>default</code>                                                                                          |
| publicUrl                              | The address people reach the Trust Console at. Empty: `https://trust.<global.platform.host>`, with `:<global.platform.httpsPort>` when that is not 443.                                                                                                        | <code>""</code>                                                                                               |
| database.secretName                    |                                                                                                                                                                                                                                                                | <code>""</code>                                                                                               |
| database.secretKey                     |                                                                                                                                                                                                                                                                | <code>url</code>                                                                                              |
| casdoor.endpoint                       | In-cluster URL. Empty: `http://<release>-casdoor.<namespace>.svc:8000`.                                                                                                                                                                                        | <code>""</code>                                                                                               |
| casdoor.publicUrl                      | The URL the browser reaches Casdoor at. Empty: `casdoor.<global.platform.host>`.                                                                                                                                                                               | <code>""</code>                                                                                               |
| casdoor.organization                   |                                                                                                                                                                                                                                                                | <code>trustconsole</code>                                                                                     |
| casdoor.application                    |                                                                                                                                                                                                                                                                | <code>trust-console</code>                                                                                    |
| casdoor.clientId                       |                                                                                                                                                                                                                                                                | <code>trust-console</code>                                                                                    |
| casdoor.clientSecret.secretName        |                                                                                                                                                                                                                                                                | <code>""</code>                                                                                               |
| casdoor.clientSecret.secretKey         |                                                                                                                                                                                                                                                                | <code>trust-casdoor-client-secret</code>                                                                      |
| casdoor.csrfKey.secretName             |                                                                                                                                                                                                                                                                | <code>""</code>                                                                                               |
| casdoor.csrfKey.secretKey              |                                                                                                                                                                                                                                                                | <code>trust-iam-csrf-key</code>                                                                               |
| casdoor.bootstrapAdmins                | The Casdoor user who becomes the console's administrator at the first sign-in.                                                                                                                                                                                 | <code>admin</code>                                                                                            |
| appPrefix                              | Where the UI is served under the public address: sign-in sends the browser back to it.                                                                                                                                                                         | <code>/trust</code>                                                                                           |
| openfga.apiUrl                         | Empty: `http://<release>-openfga.<namespace>.svc:8080`.                                                                                                                                                                                                        | <code>""</code>                                                                                               |
| valkey.addr                            | host:port. Empty: `<release>-valkey.<namespace>.svc:6379`.                                                                                                                                                                                                     | <code>""</code>                                                                                               |
| extraEnv                               | Extra environment for the hub, e.g. NATS_URL, CADENCE_HOST_PORT, EVIDENCE_BUCKET_URL: the hub starts without them and the features behind them stay off. NATS_URL needs a server without operator mode: the hub opens its NATS connection without credentials. | <code>[]</code>                                                                                               |
| global.platform.host                   |                                                                                                                                                                                                                                                                | <code>appscode.ninja</code>                                                                                   |
| global.platform.httpsPort              | The public HTTPS port when it is not 443.                                                                                                                                                                                                                      | <code>443</code>                                                                                              |
| global.credentials.secretName          |                                                                                                                                                                                                                                                                | <code>""</code>                                                                                               |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i trust-console-api appscode/trust-console-api -n ace --create-namespace --version=v2026.11.15 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i trust-console-api appscode/trust-console-api -n ace --create-namespace --version=v2026.11.15 --values values.yaml
```
