# GitHub Webhook

[GitHub Webhook by AppsCode](https://github.com/appscode-cloud) - GitHub Webhook

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/gh-ci-webhook --version=v2025.9.15
$ helm upgrade -i gh-ci-webhook appscode/gh-ci-webhook -n ace --create-namespace --version=v2025.9.15
```

## Introduction

This chart deploys a GitHub Webhook server on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.29+

## Installing the Chart

To install/upgrade the chart with the release name `gh-ci-webhook`:

```bash
$ helm upgrade -i gh-ci-webhook appscode/gh-ci-webhook -n ace --create-namespace --version=v2025.9.15
```

The command deploys a GitHub Webhook server on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `gh-ci-webhook`:

```bash
$ helm uninstall gh-ci-webhook -n ace
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `gh-ci-webhook` chart and their default values.

|                 Parameter                  |                                                                                           Description                                                                                            |                   Default                   |
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| replicaCount                               | This will set the replicaset count more information can be found here: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/                                                     | <code>1</code>                              |
| image.repository                           |                                                                                                                                                                                                  | <code>ghcr.io/appscode/gh-ci-webhook</code> |
| image.pullPolicy                           | This sets the pull policy for images.                                                                                                                                                            | <code>IfNotPresent</code>                   |
| image.tag                                  | Overrides the image tag whose default is the chart appVersion.                                                                                                                                   | <code>""</code>                             |
| imagePullSecrets                           | This is for the secrets for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ | <code>[]</code>                             |
| nameOverride                               | This is to override the chart name.                                                                                                                                                              | <code>""</code>                             |
| fullnameOverride                           |                                                                                                                                                                                                  | <code>""</code>                             |
| serviceAccount.create                      | Specifies whether a service account should be created                                                                                                                                            | <code>true</code>                           |
| serviceAccount.automount                   | Automatically mount a ServiceAccount's API credentials?                                                                                                                                          | <code>true</code>                           |
| serviceAccount.annotations                 | Annotations to add to the service account                                                                                                                                                        | <code>{}</code>                             |
| serviceAccount.name                        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                                                                           | <code>""</code>                             |
| podAnnotations                             | This is for setting Kubernetes Annotations to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/                               | <code>{}</code>                             |
| podLabels                                  | This is for setting Kubernetes Labels to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/                                         | <code>{}</code>                             |
| podSecurityContext                         |                                                                                                                                                                                                  | <code>{}</code>                             |
| securityContext                            |                                                                                                                                                                                                  | <code>{}</code>                             |
| service.type                               | This sets the service type more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types                                | <code>ClusterIP</code>                      |
| service.port                               | This sets the ports more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#field-spec-ports                                                        | <code>80</code>                             |
| ingress.enabled                            |                                                                                                                                                                                                  | <code>false</code>                          |
| ingress.className                          |                                                                                                                                                                                                  | <code>""</code>                             |
| ingress.annotations                        |                                                                                                                                                                                                  | <code>{}</code>                             |
| ingress.tls                                |                                                                                                                                                                                                  | <code>[]</code>                             |
| resources                                  |                                                                                                                                                                                                  | <code>{}</code>                             |
| livenessProbe                              | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/     | <code>{}</code>                             |
| readinessProbe                             | httpGet: path: / port: http                                                                                                                                                                      | <code>{}</code>                             |
| autoscaling.enabled                        |                                                                                                                                                                                                  | <code>false</code>                          |
| autoscaling.minReplicas                    |                                                                                                                                                                                                  | <code>1</code>                              |
| autoscaling.maxReplicas                    |                                                                                                                                                                                                  | <code>100</code>                            |
| autoscaling.targetCPUUtilizationPercentage |                                                                                                                                                                                                  | <code>80</code>                             |
| volumes                                    | Additional volumes on the output Deployment definition.                                                                                                                                          | <code>[]</code>                             |
| volumeMounts                               | Additional volumeMounts on the output Deployment definition.                                                                                                                                     | <code>[]</code>                             |
| nodeSelector                               |                                                                                                                                                                                                  | <code>{}</code>                             |
| tolerations                                |                                                                                                                                                                                                  | <code>[]</code>                             |
| affinity                                   |                                                                                                                                                                                                  | <code>{}</code>                             |
| args                                       |                                                                                                                                                                                                  | <code>[]</code>                             |
| envVars                                    |                                                                                                                                                                                                  | <code>{}</code>                             |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i gh-ci-webhook appscode/gh-ci-webhook -n ace --create-namespace --version=v2025.9.15 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i gh-ci-webhook appscode/gh-ci-webhook -n ace --create-namespace --version=v2025.9.15 --values values.yaml
```
