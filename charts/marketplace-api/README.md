# Cluster UI

[Cluster UI by AppsCode](https://github.com/appscode-cloud) - ACE Cluster UI

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/marketplace-api --version=v2025.7.31
$ helm upgrade -i marketplace-api appscode/marketplace-api -n ace --create-namespace --version=v2025.7.31
```

## Introduction

This chart deploys a Cluster UI on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `marketplace-api`:

```bash
$ helm upgrade -i marketplace-api appscode/marketplace-api -n ace --create-namespace --version=v2025.7.31
```

The command deploys a Cluster UI on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `marketplace-api`:

```bash
$ helm uninstall marketplace-api -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `marketplace-api` chart and their default values.

|                 Parameter                  |                                                             Description                                                              |                                                                                            Default                                                                                             |
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| replicaCount                               |                                                                                                                                      | <code>1</code>                                                                                                                                                                                 |
| registryFQDN                               | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image} | <code>ghcr.io</code>                                                                                                                                                                           |
| image.registry                             | Docker registry used to pull app container image                                                                                     | <code>appscode</code>                                                                                                                                                                          |
| image.repository                           | App container image                                                                                                                  | <code>b3</code>                                                                                                                                                                                |
| image.tag                                  | Overrides the image tag whose default is the chart appVersion.                                                                       | <code>""</code>                                                                                                                                                                                |
| image.pullPolicy                           |                                                                                                                                      | <code>Always</code>                                                                                                                                                                            |
| imagePullSecrets                           |                                                                                                                                      | <code>[]</code>                                                                                                                                                                                |
| nameOverride                               |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| fullnameOverride                           |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| serviceAccount.name                        |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| podAnnotations                             |                                                                                                                                      | <code>{}</code>                                                                                                                                                                                |
| podSecurityContext                         |                                                                                                                                      | <code>{}</code>                                                                                                                                                                                |
| securityContext                            | Security options this container should run with                                                                                      | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| service.type                               |                                                                                                                                      | <code>ClusterIP</code>                                                                                                                                                                         |
| service.port                               |                                                                                                                                      | <code>80</code>                                                                                                                                                                                |
| resources                                  |                                                                                                                                      | <code>{}</code>                                                                                                                                                                                |
| autoscaling.enabled                        |                                                                                                                                      | <code>false</code>                                                                                                                                                                             |
| autoscaling.minReplicas                    |                                                                                                                                      | <code>1</code>                                                                                                                                                                                 |
| autoscaling.maxReplicas                    |                                                                                                                                      | <code>100</code>                                                                                                                                                                               |
| autoscaling.targetCPUUtilizationPercentage |                                                                                                                                      | <code>80</code>                                                                                                                                                                                |
| nodeSelector                               |                                                                                                                                      | <code>{}</code>                                                                                                                                                                                |
| tolerations                                |                                                                                                                                      | <code>[]</code>                                                                                                                                                                                |
| affinity                                   |                                                                                                                                      | <code>{}</code>                                                                                                                                                                                |
| infra.storageClass.name                    |                                                                                                                                      | <code>"standard"</code>                                                                                                                                                                        |
| infra.objstore.provider                    |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| infra.objstore.mountPath                   |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| infra.badger.mountPath                     |                                                                                                                                      | <code>/badger</code>                                                                                                                                                                           |
| infra.invoice.mountPath                    |                                                                                                                                      | <code>/billing</code>                                                                                                                                                                          |
| settings.caProviderClass                   |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| settings.secretName.platformConfig         |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| settings.secretName.platformUserConfig     |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| settings.secretName.platformSystemConfig   |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| settings.secretName.grafanaConfig          |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| settings.secretName.objstore               |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| settings.secretName.nats                   |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| settings.secretName.spreadsheet            |                                                                                                                                      | <code>""</code>                                                                                                                                                                                |
| settings.spreadsheetCredentialMountPath    |                                                                                                                                      | <code>"/data/marketplace-credentials"</code>                                                                                                                                                   |
| envFrom                                    | List of sources to populate environment variables in the container                                                                   | <code>[]</code>                                                                                                                                                                                |
| env                                        | List of environment variables to set in the container                                                                                | <code>[]</code>                                                                                                                                                                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i marketplace-api appscode/marketplace-api -n ace --create-namespace --version=v2025.7.31 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i marketplace-api appscode/marketplace-api -n ace --create-namespace --version=v2025.7.31 --values values.yaml
```
