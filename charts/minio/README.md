# MinIO

[MinIO](https://github.com/bytebuilders) - MinIO Demo Deployment

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/minio --version=v2022.06.14
$ helm upgrade -i minio appscode/minio -n ace-system --create-namespace --version=v2022.06.14
```

## Introduction

This chart deploys a MinIO on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install/upgrade the chart with the release name `minio`:

```bash
$ helm upgrade -i minio appscode/minio -n ace-system --create-namespace --version=v2022.06.14
```

The command deploys a MinIO on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `minio`:

```bash
$ helm uninstall minio -n ace-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `minio` chart and their default values.

|       Parameter       |                                                             Description                                                              |                  Default                  |
|-----------------------|--------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|
| replicaCount          |                                                                                                                                      | <code>1</code>                            |
| registryFQDN          | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image} | <code>""</code>                           |
| image.registry        | Docker registry used to pull app container image                                                                                     | <code>minio</code>                        |
| image.repository      | App container image                                                                                                                  | <code>minio</code>                        |
| image.tag             | Overrides the image tag whose default is the chart appVersion.                                                                       | <code>RELEASE.2022-02-01T18-00-14Z</code> |
| image.pullPolicy      |                                                                                                                                      | <code>IfNotPresent</code>                 |
| imagePullSecrets      |                                                                                                                                      | <code>[]</code>                           |
| nameOverride          |                                                                                                                                      | <code>""</code>                           |
| fullnameOverride      |                                                                                                                                      | <code>""</code>                           |
| podAnnotations        |                                                                                                                                      | <code>{}</code>                           |
| podSecurityContext    |                                                                                                                                      | <code>{}</code>                           |
| securityContext       |                                                                                                                                      | <code>{}</code>                           |
| resources             |                                                                                                                                      | <code>{}</code>                           |
| service.type          |                                                                                                                                      | <code>ClusterIP</code>                    |
| service.port          |                                                                                                                                      | <code>9000</code>                         |
| storageClass.name     |                                                                                                                                      | <code>""</code>                           |
| persistence.size      |                                                                                                                                      | <code>10Gi</code>                         |
| nodeSelector          |                                                                                                                                      | <code>{}</code>                           |
| tolerations           |                                                                                                                                      | <code>[]</code>                           |
| affinity              |                                                                                                                                      | <code>{}</code>                           |
| minio.issuer.name     |                                                                                                                                      | <code>""</code>                           |
| minio.issuer.kind     |                                                                                                                                      | <code>""</code>                           |
| minio.accessKeyId     |                                                                                                                                      | <code>""</code>                           |
| minio.secretAccessKey |                                                                                                                                      | <code>""</code>                           |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i minio appscode/minio -n ace-system --create-namespace --version=v2022.06.14 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i minio appscode/minio -n ace-system --create-namespace --version=v2022.06.14 --values values.yaml
```
