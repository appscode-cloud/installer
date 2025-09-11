# Cluster Importer

[Cluster Importer by AppsCode](https://github.com/appscode-cloud) - ACE Cluster Importer

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/cluster-importer --version=v2025.9.15
$ helm upgrade -i cluster-importer appscode/cluster-importer -n ace-system --create-namespace --version=v2025.9.15
```

## Introduction

This chart deploys a Cluster Importer on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `cluster-importer`:

```bash
$ helm upgrade -i cluster-importer appscode/cluster-importer -n ace-system --create-namespace --version=v2025.9.15
```

The command deploys a Cluster Importer on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `cluster-importer`:

```bash
$ helm uninstall cluster-importer -n ace-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `cluster-importer` chart and their default values.

|           Parameter            |                                                             Description                                                              |                                                                    Default                                                                     |
|--------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| registryFQDN                   | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image} | <code>ghcr.io</code>                                                                                                                           |
| image.registry                 | Docker registry used to pull app container image                                                                                     | <code>appscode</code>                                                                                                                          |
| image.repository               | App container image                                                                                                                  | <code>ace</code>                                                                                                                               |
| image.tag                      | Overrides the image tag whose default is the chart appVersion.                                                                       | <code>""</code>                                                                                                                                |
| image.pullPolicy               |                                                                                                                                      | <code>Always</code>                                                                                                                            |
| imagePullSecrets               |                                                                                                                                      | <code>[]</code>                                                                                                                                |
| nameOverride                   |                                                                                                                                      | <code>""</code>                                                                                                                                |
| fullnameOverride               |                                                                                                                                      | <code>""</code>                                                                                                                                |
| args                           |                                                                                                                                      | <code>[]</code>                                                                                                                                |
| podAnnotations                 |                                                                                                                                      | <code>{}</code>                                                                                                                                |
| podSecurityContext             |                                                                                                                                      | <code>{}</code>                                                                                                                                |
| securityContext                | Security options this container should run with                                                                                      | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| resources                      |                                                                                                                                      | <code>{}</code>                                                                                                                                |
| nodeSelector                   |                                                                                                                                      | <code>{}</code>                                                                                                                                |
| tolerations                    |                                                                                                                                      | <code>[]</code>                                                                                                                                |
| affinity                       |                                                                                                                                      | <code>{}</code>                                                                                                                                |
| kubeconfigSecretKeyRef.name    |                                                                                                                                      | <code>""</code>                                                                                                                                |
| kubeconfigSecretKeyRef.key     |                                                                                                                                      | <code>""</code>                                                                                                                                |
| platform.baseURL               |                                                                                                                                      | <code>""</code>                                                                                                                                |
| platform.token                 |                                                                                                                                      | <code>""</code>                                                                                                                                |
| platform.tokenSecretName       |                                                                                                                                      | <code>""</code>                                                                                                                                |
| platform.caBundle              |                                                                                                                                      | <code>""</code>                                                                                                                                |
| platform.insecureSkipTLSVerify |                                                                                                                                      | <code>false</code>                                                                                                                             |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i cluster-importer appscode/cluster-importer -n ace-system --create-namespace --version=v2025.9.15 --set registryFQDN=ghcr.io
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i cluster-importer appscode/cluster-importer -n ace-system --create-namespace --version=v2025.9.15 --values values.yaml
```
