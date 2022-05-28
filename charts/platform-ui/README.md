# Platform UI

[Platform UI by AppsCode](https://github.com/bytebuilders) - ByteBuilders Platform UI

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/platform-ui --version=0.1.0
$ helm upgrade -i platform-ui appscode/platform-ui -n kubeops --create-namespace --version=0.1.0
```

## Introduction

This chart deploys a Platform UI on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+

## Installing the Chart

To install/upgrade the chart with the release name `platform-ui`:

```bash
$ helm upgrade -i platform-ui appscode/platform-ui -n kubeops --create-namespace --version=0.1.0
```

The command deploys a Platform UI on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `platform-ui`:

```bash
$ helm uninstall platform-ui -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `platform-ui` chart and their default values.

|                 Parameter                  |                                                             Description                                                              |         Default          |
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|--------------------------|
| replicaCount                               |                                                                                                                                      | <code>1</code>           |
| registryFQDN                               | Docker registry fqdn used to pull app related images. Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image} | <code>""</code>          |
| image.registry                             | Docker registry used to pull app container image                                                                                     | <code>appscode</code>    |
| image.repository                           | App container image                                                                                                                  | <code>platform-ui</code> |
| image.tag                                  | Overrides the image tag whose default is the chart appVersion.                                                                       | <code>""</code>          |
| image.pullPolicy                           |                                                                                                                                      | <code>Always</code>      |
| imagePullSecrets                           |                                                                                                                                      | <code>[]</code>          |
| nameOverride                               |                                                                                                                                      | <code>""</code>          |
| fullnameOverride                           |                                                                                                                                      | <code>""</code>          |
| serviceAccount.name                        |                                                                                                                                      | <code>""</code>          |
| podAnnotations                             |                                                                                                                                      | <code>{}</code>          |
| podSecurityContext                         |                                                                                                                                      | <code>{}</code>          |
| securityContext                            |                                                                                                                                      | <code>{}</code>          |
| service.type                               |                                                                                                                                      | <code>ClusterIP</code>   |
| service.port                               |                                                                                                                                      | <code>80</code>          |
| resources                                  |                                                                                                                                      | <code>{}</code>          |
| autoscaling.enabled                        |                                                                                                                                      | <code>false</code>       |
| autoscaling.minReplicas                    |                                                                                                                                      | <code>1</code>           |
| autoscaling.maxReplicas                    |                                                                                                                                      | <code>100</code>         |
| autoscaling.targetCPUUtilizationPercentage |                                                                                                                                      | <code>80</code>          |
| nodeSelector                               |                                                                                                                                      | <code>{}</code>          |
| tolerations                                |                                                                                                                                      | <code>[]</code>          |
| affinity                                   |                                                                                                                                      | <code>{}</code>          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i platform-ui appscode/platform-ui -n kubeops --create-namespace --version=0.1.0 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i platform-ui appscode/platform-ui -n kubeops --create-namespace --version=0.1.0 --values values.yaml
```
