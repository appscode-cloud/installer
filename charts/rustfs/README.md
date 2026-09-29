# RustFS

[RustFS](https://github.com/appscode-cloud) - RustFS Demo Deployment

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/rustfs --version=v2026.9.11
$ helm upgrade -i rustfs appscode/rustfs -n ace --create-namespace --version=v2026.9.11
```

## Introduction

This chart deploys a RustFS on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `rustfs`:

```bash
$ helm upgrade -i rustfs appscode/rustfs -n ace --create-namespace --version=v2026.9.11
```

The command deploys a RustFS on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `rustfs`:

```bash
$ helm uninstall rustfs -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `rustfs` chart and their default values.

|          Parameter          |                                                             Description                                                              |                                                                                       Default                                                                                       |
|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| replicaCount                |                                                                                                                                      | <code>1</code>                                                                                                                                                                      |
| registryFQDN                | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image} | <code>ghcr.io</code>                                                                                                                                                                |
| image.registry              | Docker registry used to pull app container image                                                                                     | <code>appscode-images</code>                                                                                                                                                        |
| image.repository            | App container image                                                                                                                  | <code>rustfs</code>                                                                                                                                                                 |
| image.tag                   | Overrides the image tag whose default is the chart appVersion.                                                                       | <code>""</code>                                                                                                                                                                     |
| image.pullPolicy            |                                                                                                                                      | <code>IfNotPresent</code>                                                                                                                                                           |
| imagePullSecrets            |                                                                                                                                      | <code>[]</code>                                                                                                                                                                     |
| nameOverride                |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |
| fullnameOverride            |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |
| podAnnotations              |                                                                                                                                      | <code>{}</code>                                                                                                                                                                     |
| podSecurityContext          |                                                                                                                                      | <code>{"fsGroup":10001}</code>                                                                                                                                                      |
| securityContext             | Security options this container should run with                                                                                      | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsGroup":10001,"runAsNonRoot":true,"runAsUser":10001,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| ingress.enabled             |                                                                                                                                      | <code>false</code>                                                                                                                                                                  |
| ingress.className           |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |
| ingress.annotations         |                                                                                                                                      | <code>{}</code>                                                                                                                                                                     |
| ingress.domain              | kubernetes.io/ingress.class: nginx kubernetes.io/tls-acme: "true"                                                                    | <code>""</code>                                                                                                                                                                     |
| gateway.annotations         |                                                                                                                                      | <code>{}</code>                                                                                                                                                                     |
| gateway.enabled             |                                                                                                                                      | <code>false</code>                                                                                                                                                                  |
| gateway.tls.enabled         |                                                                                                                                      | <code>true</code>                                                                                                                                                                   |
| gateway.tls.secret.name     |                                                                                                                                      | <code>"ace-cert"</code>                                                                                                                                                             |
| gateway.hosts               |                                                                                                                                      | <code>[]</code>                                                                                                                                                                     |
| resources                   |                                                                                                                                      | <code>{}</code>                                                                                                                                                                     |
| service.type                |                                                                                                                                      | <code>ClusterIP</code>                                                                                                                                                              |
| service.port                |                                                                                                                                      | <code>9000</code>                                                                                                                                                                   |
| storageClass.name           |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |
| persistence.size            |                                                                                                                                      | <code>10Gi</code>                                                                                                                                                                   |
| nodeSelector                |                                                                                                                                      | <code>{}</code>                                                                                                                                                                     |
| tolerations                 |                                                                                                                                      | <code>[]</code>                                                                                                                                                                     |
| affinity                    |                                                                                                                                      | <code>{}</code>                                                                                                                                                                     |
| rustfs.auth.accessKeyId     |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |
| rustfs.auth.secretAccessKey |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |
| rustfs.tls.enable           |                                                                                                                                      | <code>true</code>                                                                                                                                                                   |
| rustfs.tls.mount            |                                                                                                                                      | <code>false</code>                                                                                                                                                                  |
| rustfs.tls.issuer.name      |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |
| rustfs.tls.issuer.kind      |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |
| rustfs.tls.secret.name      |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |
| distro.openshift            |                                                                                                                                      | <code>false</code>                                                                                                                                                                  |
| distro.ubi                  |                                                                                                                                      | <code>""</code>                                                                                                                                                                     |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i rustfs appscode/rustfs -n ace --create-namespace --version=v2026.9.11 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i rustfs appscode/rustfs -n ace --create-namespace --version=v2026.9.11 --values values.yaml
```
