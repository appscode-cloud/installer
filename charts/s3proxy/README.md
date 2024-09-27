# MinIO

[MinIO](https://github.com/appscode-cloud) - MinIO Demo Deployment

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/s3proxy --version=v2024.9.30
$ helm upgrade -i s3proxy appscode/s3proxy -n ace --create-namespace --version=v2024.9.30
```

## Introduction

This chart deploys a MinIO on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `s3proxy`:

```bash
$ helm upgrade -i s3proxy appscode/s3proxy -n ace --create-namespace --version=v2024.9.30
```

The command deploys a MinIO on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `s3proxy`:

```bash
$ helm uninstall s3proxy -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `s3proxy` chart and their default values.

|               Parameter               |                                                             Description                                                              |                                                                             Default                                                                              |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| replicaCount                          |                                                                                                                                      | <code>1</code>                                                                                                                                                   |
| registryFQDN                          | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image} | <code>ghcr.io</code>                                                                                                                                             |
| image.registry                        | Docker registry used to pull app container image                                                                                     | <code>appscode</code>                                                                                                                                            |
| image.repository                      | App container image                                                                                                                  | <code>s3proxy</code>                                                                                                                                             |
| image.tag                             | Overrides the image tag whose default is the chart appVersion.                                                                       | <code>sha-a82ca68</code>                                                                                                                                         |
| image.pullPolicy                      |                                                                                                                                      | <code>IfNotPresent</code>                                                                                                                                        |
| imagePullSecrets                      |                                                                                                                                      | <code>[]</code>                                                                                                                                                  |
| nameOverride                          |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| fullnameOverride                      |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| podAnnotations                        |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| podSecurityContext                    |                                                                                                                                      | <code>{"fsGroup":65534}</code>                                                                                                                                   |
| securityContext                       | Security options this container should run with                                                                                      | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| ingress.enabled                       |                                                                                                                                      | <code>false</code>                                                                                                                                               |
| ingress.className                     |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| ingress.annotations                   |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| ingress.domain                        | kubernetes.io/ingress.class: nginx kubernetes.io/tls-acme: "true"                                                                    | <code>""</code>                                                                                                                                                  |
| resources                             |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| service.type                          |                                                                                                                                      | <code>ClusterIP</code>                                                                                                                                           |
| service.port                          |                                                                                                                                      | <code>4224</code>                                                                                                                                                |
| storageClass.name                     |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| persistence.size                      |                                                                                                                                      | <code>10Gi</code>                                                                                                                                                |
| nodeSelector                          |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| tolerations                           |                                                                                                                                      | <code>[]</code>                                                                                                                                                  |
| affinity                              |                                                                                                                                      | <code>{}</code>                                                                                                                                                  |
| s3proxy.auth.accessKeyId              |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| s3proxy.auth.secretAccessKey          |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| s3proxy.tls.enable                    |                                                                                                                                      | <code>true</code>                                                                                                                                                |
| s3proxy.tls.issuer.name               |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| s3proxy.tls.issuer.kind               |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| s3proxy.tls.secret.name               |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| s3proxy.tls.jksPasswordSecretRef.name |                                                                                                                                      | <code>""</code>                                                                                                                                                  |
| s3proxy.tls.jksPasswordSecretRef.key  |                                                                                                                                      | <code>""</code>                                                                                                                                                  |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i s3proxy appscode/s3proxy -n ace --create-namespace --version=v2024.9.30 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i s3proxy appscode/s3proxy -n ace --create-namespace --version=v2024.9.30 --values values.yaml
```
