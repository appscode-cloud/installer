# Patch Console Ui

[Patch Console Ui by AppsCode](https://github.com/appscode-cloud) - Patch console UI

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/patch-console-ui --version=v2026.11.15
$ helm upgrade -i patch-console-ui appscode/patch-console-ui -n ace --create-namespace --version=v2026.11.15
```

## Introduction

This chart deploys a Patch Console Ui on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `patch-console-ui`:

```bash
$ helm upgrade -i patch-console-ui appscode/patch-console-ui -n ace --create-namespace --version=v2026.11.15
```

The command deploys a Patch Console Ui on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `patch-console-ui`:

```bash
$ helm uninstall patch-console-ui -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `patch-console-ui` chart and their default values.

|               Parameter                |                                 Description                                  |                                                    Default                                                    |
|----------------------------------------|------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| replicaCount                           |                                                                              | <code>1</code>                                                                                                |
| registryFQDN                           | Docker registry fqdn used to pull app related images.                        | <code>ghcr.io</code>                                                                                          |
| image.registry                         | Docker registry used to pull app container image                             | <code>appscode</code>                                                                                         |
| image.repository                       |                                                                              | <code>patch-console-ui</code>                                                                                 |
| image.tag                              | Overrides the image tag whose default is the chart appVersion.               | <code>""</code>                                                                                               |
| image.digest                           | A digest ("sha256:...") wins over the tag.                                   | <code>""</code>                                                                                               |
| image.pullPolicy                       |                                                                              | <code>IfNotPresent</code>                                                                                     |
| imagePullSecrets                       |                                                                              | <code>[]</code>                                                                                               |
| nameOverride                           |                                                                              | <code>""</code>                                                                                               |
| fullnameOverride                       |                                                                              | <code>""</code>                                                                                               |
| serviceAccount.name                    |                                                                              | <code>""</code>                                                                                               |
| podAnnotations                         |                                                                              | <code>{}</code>                                                                                               |
| podSecurityContext.runAsNonRoot        |                                                                              | <code>true</code>                                                                                             |
| podSecurityContext.seccompProfile.type |                                                                              | <code>RuntimeDefault</code>                                                                                   |
| securityContext                        |                                                                              | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}</code> |
| service.port                           |                                                                              | <code>80</code>                                                                                               |
| resources.requests.cpu                 |                                                                              | <code>50m</code>                                                                                              |
| resources.requests.memory              |                                                                              | <code>64Mi</code>                                                                                             |
| nodeSelector                           |                                                                              | <code>{}</code>                                                                                               |
| tolerations                            |                                                                              | <code>[]</code>                                                                                               |
| affinity                               |                                                                              | <code>{}</code>                                                                                               |
| hub.service                            | Service name. Empty: `<release>-patch-console-api`.                          | <code>""</code>                                                                                               |
| hub.port                               |                                                                              | <code>8080</code>                                                                                             |
| clusterUi.enabled                      |                                                                              | <code>true</code>                                                                                             |
| clusterUi.baseUrl                      | Where cluster-ui is served. Empty: `https://<global.platform.host>/console`. | <code>""</code>                                                                                               |
| clusterUi.cveReportPath                |                                                                              | <code>/clusters/{cluster}/security/cve-report</code>                                                          |
| global.platform.host                   |                                                                              | <code>appscode.ninja</code>                                                                                   |
| global.platform.httpsPort              | The public HTTPS port when it is not 443.                                    | <code>443</code>                                                                                              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i patch-console-ui appscode/patch-console-ui -n ace --create-namespace --version=v2026.11.15 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i patch-console-ui appscode/patch-console-ui -n ace --create-namespace --version=v2026.11.15 --values values.yaml
```
