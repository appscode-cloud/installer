# MinIO

[MinIO](https://github.com/appscode-cloud) - MinIO Demo Deployment

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/minio --version=v2025.4.30
$ helm upgrade -i minio appscode/minio -n ace --create-namespace --version=v2025.4.30
```

## Introduction

This chart deploys a MinIO on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `minio`:

```bash
$ helm upgrade -i minio appscode/minio -n ace --create-namespace --version=v2025.4.30
```

The command deploys a MinIO on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `minio`:

```bash
$ helm uninstall minio -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `minio` chart and their default values.

|         Parameter          |                                                             Description                                                              |                                                                             Default                                                                              |
|----------------------------|--------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| replicaCount               |                                                                                                                                      | <code>1</code>                                                                                                                                                   |
| registryFQDN               | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image} | <code>""</code>                                                                                                                                                  |
| image.registry             | Docker registry used to pull app container image                                                                                     | <code>minio</code>                                                                                                                                               |
| image.repository           | App container image                                                                                                                  | <code>minio</code>                                                                                                                                               |
| image.tag                  | Overrides the image tag whose default is the chart appVersion.                                                                       | <code>""</code>                                                                                                                                                  |
| image.pullPolicy           |                                                                                                                                      | <code>IfNotPresent</code>                                                                                                                                        |
| imagePullSecrets           |                                                                                                                                      | <code>[]</code>                                                                                                                                                  |
| nameOverride               |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| fullnameOverride           |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| podAnnotations             |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| podSecurityContext         |                                                                                                                                      | <code>{"fsGroup":65534}</code>                                                                                                                                   |
| securityContext            | Security options this container should run with                                                                                      | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| ingress.enabled            |                                                                                                                                      | <code>false</code>                                                                                                                                               |
| ingress.className          |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| ingress.annotations        |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| ingress.domain             | kubernetes.io/ingress.class: nginx kubernetes.io/tls-acme: "true"                                                                    | <code>""</code>                                                                                                                                                  |
| resources                  |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| service.type               |                                                                                                                                      | <code>ClusterIP</code>                                                                                                                                           |
| service.port               |                                                                                                                                      | <code>9000</code>                                                                                                                                                |
| storageClass.name          |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| persistence.size           |                                                                                                                                      | <code>10Gi</code>                                                                                                                                                |
| nodeSelector               |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| tolerations                |                                                                                                                                      | <code>[]</code>                                                                                                                                                  |
| affinity                   |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| minio.auth.accessKeyId     |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| minio.auth.secretAccessKey |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| minio.tls.enable           |                                                                                                                                      | <code>true</code>                                                                                                                                                |
| minio.tls.mount            |                                                                                                                                      | <code>false</code>                                                                                                                                               |
| minio.tls.issuer.name      |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| minio.tls.issuer.kind      |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| minio.tls.secret.name      |                                                                                                                                      | <code>""</code>                                                                                                                                                  |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i minio appscode/minio -n ace --create-namespace --version=v2025.4.30 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i minio appscode/minio -n ace --create-namespace --version=v2025.4.30 --values values.yaml
```
