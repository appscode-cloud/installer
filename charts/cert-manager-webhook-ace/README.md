# cert-manager webhook

[cert-manager webhook for AppsCode DNS Proxy](https://github.com/bytebuilders) - A webhook to use AppsCode DNS Proxy for Cloudfare as a DNS issuer for cert-manager

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/cert-manager-webhook-ace --version=v2023.03.23
$ helm upgrade -i cert-manager-webhook-ace appscode/cert-manager-webhook-ace -n cert-manager --create-namespace --version=v2023.03.23
```

## Introduction

This chart deploys a cert-manager webhook on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `cert-manager-webhook-ace`:

```bash
$ helm upgrade -i cert-manager-webhook-ace appscode/cert-manager-webhook-ace -n cert-manager --create-namespace --version=v2023.03.23
```

The command deploys a cert-manager webhook on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `cert-manager-webhook-ace`:

```bash
$ helm uninstall cert-manager-webhook-ace -n cert-manager
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `cert-manager-webhook-ace` chart and their default values.

|           Parameter            |                                                                                            Description                                                                                            |                Default                |
|--------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|
| groupName                      | groupName for the webhook, issuers and clusterIssuers must match this                                                                                                                             | <code>webhook.dns.appscode.com</code> |
| registryFQDN                   | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                                              | <code>ghcr.io</code>                  |
| image.registry                 | Docker registry used to pull app container image                                                                                                                                                  | <code>appscode</code>                 |
| image.repository               | App container image                                                                                                                                                                               | <code>cert-manager-webhook-ace</code> |
| image.tag                      | Overrides the image tag whose default is the chart appVersion.                                                                                                                                    | <code>""</code>                       |
| image.pullPolicy               |                                                                                                                                                                                                   | <code>IfNotPresent</code>             |
| imagePullSecrets               |                                                                                                                                                                                                   | <code>[]</code>                       |
| replicaCount                   | Number of webhook replicas                                                                                                                                                                        | <code>1</code>                        |
| nameOverride                   | Override the name of the created resources                                                                                                                                                        | <code>""</code>                       |
| fullnameOverride               | Override the full name of the created resources                                                                                                                                                   | <code>""</code>                       |
| serviceAccount.create          | If true, create a new service account                                                                                                                                                             | <code>true</code>                     |
| serviceAccount.name            | Service account to be used. If not set and serviceAccount.create is true, a name is generated using the fullname template                                                                         | <code></code>                         |
| certManager.namespace          | cert-manager's namespace                                                                                                                                                                          | <code>cert-manager</code>             |
| certManager.serviceAccountName | cert-manager's serviceAccountName                                                                                                                                                                 | <code>cert-manager</code>             |
| service.type                   | service type for the webhook API server                                                                                                                                                           | <code>ClusterIP</code>                |
| service.port                   | port for the webhook API server                                                                                                                                                                   | <code>443</code>                      |
| podSecurityContext             | Optional pod context. The yaml block should adhere to the [PodSecurityContext spec](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#securitycontext-v1-core)      | <code>{}</code>                       |
| securityContext                | Optional security context. The yaml block should adhere to the [SecurityContext spec](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podsecuritycontext-v1-core) | <code>{}</code>                       |
| resources                      | CPU/memory resource requests/limits                                                                                                                                                               | <code>{}</code>                       |
| nodeSelector                   | Node labels for pod assignment                                                                                                                                                                    | <code>{}</code>                       |
| tolerations                    | Node tolerations for pod assignment                                                                                                                                                               | <code>[]</code>                       |
| affinity                       | Node affinity for pod assignment                                                                                                                                                                  | <code>{}</code>                       |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i cert-manager-webhook-ace appscode/cert-manager-webhook-ace -n cert-manager --create-namespace --version=v2023.03.23 --set groupName=webhook.dns.appscode.com
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i cert-manager-webhook-ace appscode/cert-manager-webhook-ace -n cert-manager --create-namespace --version=v2023.03.23 --values values.yaml
```
