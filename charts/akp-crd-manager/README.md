# CRD Manager

[CRD Manager by AppsCode](https://github.com/appscode-cloud/crd-manager) - Third-party CRD Installer

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/akp-crd-manager --version=v2026.9.11
$ helm upgrade -i akp-crd-manager appscode/akp-crd-manager -n kubeops --create-namespace --version=v2026.9.11
```

## Introduction

This chart deploys a CRD Manager operator on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.20+

## Installing the Chart

To install/upgrade the chart with the release name `akp-crd-manager`:

```bash
$ helm upgrade -i akp-crd-manager appscode/akp-crd-manager -n kubeops --create-namespace --version=v2026.9.11
```

The command deploys a CRD Manager operator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `akp-crd-manager`:

```bash
$ helm uninstall akp-crd-manager -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `akp-crd-manager` chart and their default values.

|            Parameter            |                                                                                                                   Description                                                                                                                   |                                                                    Default                                                                     |
|---------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| registryFQDN                    | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                                                                                            | <code>ghcr.io</code>                                                                                                                           |
| image.registry                  | Docker registry used to pull app container image                                                                                                                                                                                                | <code>appscode</code>                                                                                                                          |
| image.repository                | App container image                                                                                                                                                                                                                             | <code>akp-crd-manager</code>                                                                                                                   |
| image.tag                       | Overrides the image tag whose default is the chart appVersion.                                                                                                                                                                                  | <code>""</code>                                                                                                                                |
| imagePullSecrets                | Specify an array of imagePullSecrets. Secrets must be manually created in the namespace. <br> Example: <br> `helm template charts/kubedb-ops-manager \` <br> `--set imagePullSecrets[0].name=sec0 \` <br> `--set imagePullSecrets[1].name=sec1` | <code>[]</code>                                                                                                                                |
| imagePullPolicy                 | Container image pull policy                                                                                                                                                                                                                     | <code>IfNotPresent</code>                                                                                                                      |
| nameOverride                    |                                                                                                                                                                                                                                                 | <code>""</code>                                                                                                                                |
| fullnameOverride                |                                                                                                                                                                                                                                                 | <code>""</code>                                                                                                                                |
| podAnnotations                  |                                                                                                                                                                                                                                                 | <code>{}</code>                                                                                                                                |
| podSecurityContext              |                                                                                                                                                                                                                                                 | <code>{}</code>                                                                                                                                |
| securityContext                 | Security options this container should run with                                                                                                                                                                                                 | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| resources                       |                                                                                                                                                                                                                                                 | <code>{}</code>                                                                                                                                |
| nodeSelector                    |                                                                                                                                                                                                                                                 | <code>{}</code>                                                                                                                                |
| tolerations                     |                                                                                                                                                                                                                                                 | <code>[]</code>                                                                                                                                |
| affinity                        |                                                                                                                                                                                                                                                 | <code>{}</code>                                                                                                                                |
| ttlSecondsAfterFinished         |                                                                                                                                                                                                                                                 | <code>120</code>                                                                                                                               |
| serviceAccount.create           | Specifies whether a service account should be created                                                                                                                                                                                           | <code>true</code>                                                                                                                              |
| serviceAccount.annotations      | Annotations to add to the service account                                                                                                                                                                                                       | <code>{}</code>                                                                                                                                |
| serviceAccount.name             | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                                                                                                                          | <code></code>                                                                                                                                  |
| featureGates.CertManager        |                                                                                                                                                                                                                                                 | <code>true</code>                                                                                                                              |
| featureGates.EnvoyGateway       |                                                                                                                                                                                                                                                 | <code>true</code>                                                                                                                              |
| featureGates.FluxCD             |                                                                                                                                                                                                                                                 | <code>false</code>                                                                                                                             |
| featureGates.GatewayAPI         |                                                                                                                                                                                                                                                 | <code>true</code>                                                                                                                              |
| featureGates.PrometheusOperator |                                                                                                                                                                                                                                                 | <code>true</code>                                                                                                                              |
| distro.openshift                |                                                                                                                                                                                                                                                 | <code>false</code>                                                                                                                             |
| distro.ubi                      |                                                                                                                                                                                                                                                 | <code>""</code>                                                                                                                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i akp-crd-manager appscode/akp-crd-manager -n kubeops --create-namespace --version=v2026.9.11 --set registryFQDN=ghcr.io
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i akp-crd-manager appscode/akp-crd-manager -n kubeops --create-namespace --version=v2026.9.11 --values values.yaml
```
