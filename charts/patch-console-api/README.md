# Patch Console Api

[Patch Console Api by AppsCode](https://github.com/appscode-cloud) - Patch console hub: the API and the event ingest of the patch console

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/patch-console-api --version=v2026.11.15
$ helm upgrade -i patch-console-api appscode/patch-console-api -n ace --create-namespace --version=v2026.11.15
```

## Introduction

This chart deploys a Patch Console Api on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `patch-console-api`:

```bash
$ helm upgrade -i patch-console-api appscode/patch-console-api -n ace --create-namespace --version=v2026.11.15
```

The command deploys a Patch Console Api on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `patch-console-api`:

```bash
$ helm uninstall patch-console-api -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `patch-console-api` chart and their default values.

|               Parameter                |                                                                                        Description                                                                                         |                                                    Default                                                    |
|----------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| replicaCount                           |                                                                                                                                                                                            | <code>1</code>                                                                                                |
| registryFQDN                           | Docker registry fqdn used to pull app related images.                                                                                                                                      | <code>ghcr.io</code>                                                                                          |
| image.registry                         | Docker registry used to pull app container image                                                                                                                                           | <code>appscode</code>                                                                                         |
| image.repository                       |                                                                                                                                                                                            | <code>patch-console</code>                                                                                    |
| image.tag                              | Overrides the image tag whose default is the chart appVersion.                                                                                                                             | <code>""</code>                                                                                               |
| image.digest                           | A digest ("sha256:...") wins over the tag.                                                                                                                                                 | <code>""</code>                                                                                               |
| image.pullPolicy                       |                                                                                                                                                                                            | <code>IfNotPresent</code>                                                                                     |
| imagePullSecrets                       |                                                                                                                                                                                            | <code>[]</code>                                                                                               |
| nameOverride                           |                                                                                                                                                                                            | <code>""</code>                                                                                               |
| fullnameOverride                       |                                                                                                                                                                                            | <code>""</code>                                                                                               |
| serviceAccount.name                    |                                                                                                                                                                                            | <code>""</code>                                                                                               |
| podAnnotations                         |                                                                                                                                                                                            | <code>{}</code>                                                                                               |
| podSecurityContext.runAsNonRoot        |                                                                                                                                                                                            | <code>true</code>                                                                                             |
| podSecurityContext.seccompProfile.type |                                                                                                                                                                                            | <code>RuntimeDefault</code>                                                                                   |
| securityContext                        |                                                                                                                                                                                            | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}</code> |
| service.port                           |                                                                                                                                                                                            | <code>8080</code>                                                                                             |
| resources.requests.cpu                 |                                                                                                                                                                                            | <code>250m</code>                                                                                             |
| resources.requests.memory              |                                                                                                                                                                                            | <code>256Mi</code>                                                                                            |
| resources.limits.memory                |                                                                                                                                                                                            | <code>1Gi</code>                                                                                              |
| nodeSelector                           |                                                                                                                                                                                            | <code>{}</code>                                                                                               |
| tolerations                            |                                                                                                                                                                                            | <code>[]</code>                                                                                               |
| affinity                               |                                                                                                                                                                                            | <code>{}</code>                                                                                               |
| production                             | Refuse nothing, but tell the hub it is a production install.                                                                                                                               | <code>false</code>                                                                                            |
| publicUrl                              | The address people reach the console at. Empty: `https://<global.platform.host>`, with `:<global.platform.httpsPort>` when that is not 443.                                                | <code>""</code>                                                                                               |
| database.secretName                    |                                                                                                                                                                                            | <code>""</code>                                                                                               |
| database.secretKey                     |                                                                                                                                                                                            | <code>url</code>                                                                                              |
| iam.rootKey.secretName                 |                                                                                                                                                                                            | <code>""</code>                                                                                               |
| iam.rootKey.secretKey                  |                                                                                                                                                                                            | <code>patch-iam-root-key</code>                                                                               |
| casdoor.endpoint                       | In-cluster URL. Empty: `http://<release>-casdoor.<namespace>.svc:8000`.                                                                                                                    | <code>""</code>                                                                                               |
| casdoor.publicUrl                      | The URL the browser reaches Casdoor at. Empty: `casdoor.<global.platform.host>`.                                                                                                           | <code>""</code>                                                                                               |
| casdoor.organization                   |                                                                                                                                                                                            | <code>kubepatch</code>                                                                                        |
| casdoor.application                    |                                                                                                                                                                                            | <code>patch-console</code>                                                                                    |
| casdoor.clientId                       |                                                                                                                                                                                            | <code>patch-console</code>                                                                                    |
| casdoor.clientSecret.secretName        |                                                                                                                                                                                            | <code>""</code>                                                                                               |
| casdoor.clientSecret.secretKey         |                                                                                                                                                                                            | <code>patch-casdoor-client-secret</code>                                                                      |
| clusterDirectory                       | akp: the cluster list comes from AKP; table: clusters typed into the console. Empty: akp once `akp.tokenSecret` is set, table before (the hub will not start in akp mode without a token). | <code>""</code>                                                                                               |
| akp.url                                | Empty: this install's public URL (the hub refuses http).                                                                                                                                   | <code>""</code>                                                                                               |
| akp.tokenSecret                        | A Secret with the iam API token of a site administrator, key `token`.                                                                                                                      | <code>""</code>                                                                                               |
| akp.caSecret.name                      |                                                                                                                                                                                            | <code>""</code>                                                                                               |
| blobStore.existingClaim                | An existing PersistentVolumeClaim for SBOM documents; empty keeps them in an emptyDir.                                                                                                     | <code>""</code>                                                                                               |
| blobStore.sizeLimit                    |                                                                                                                                                                                            | <code>2Gi</code>                                                                                              |
| extraEnv                               | Extra environment for the hub.                                                                                                                                                             | <code>[]</code>                                                                                               |
| global.platform.host                   |                                                                                                                                                                                            | <code>appscode.ninja</code>                                                                                   |
| global.platform.httpsPort              | The public HTTPS port when it is not 443.                                                                                                                                                  | <code>443</code>                                                                                              |
| global.credentials.secretName          |                                                                                                                                                                                            | <code>""</code>                                                                                               |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i patch-console-api appscode/patch-console-api -n ace --create-namespace --version=v2026.11.15 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i patch-console-api appscode/patch-console-api -n ace --create-namespace --version=v2026.11.15 --values values.yaml
```
