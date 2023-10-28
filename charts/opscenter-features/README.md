# ByteBuilders Opscenter Configurator

[ByteBuilders Opscenter Configurator by AppsCode](https://github.com/bytebuilders/installer) - ByteBuilders Opscenter Configurator

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable
$ helm repo update
$ helm search repo appscode/opscenter-features --version=v2023.10.18
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.10.18
```

## Introduction

This chart deploys a ByteBuilders Opscenter Configurator on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `opscenter-features`:

```bash
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.10.18
```

The command deploys a ByteBuilders Opscenter Configurator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `opscenter-features`:

```bash
$ helm uninstall opscenter-features -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `opscenter-features` chart and their default values.

|                  Parameter                   |       Description       |                              Default                               |
|----------------------------------------------|-------------------------|--------------------------------------------------------------------|
| nameOverride                                 |                         | <code>""</code>                                                    |
| fullnameOverride                             |                         | <code>""</code>                                                    |
| image.registryFQDN                           |                         | <code>""</code>                                                    |
| image.proxies.appscode                       | r.appscode.com          | <code>r.appscode.com</code>                                        |
| image.proxies.dockerHub                      | company/bin:tag         | <code>""</code>                                                    |
| image.proxies.dockerLibrary                  | alpine, nginx etc.      | <code>""</code>                                                    |
| image.proxies.ghcr                           | ghcr.io/company/bin:tag | <code>ghcr.io</code>                                               |
| image.proxies.quay                           | quay.io/company/bin:tag | <code>quay.io</code>                                               |
| image.proxies.kubernetes                     | registry.k8s.io/bin:tag | <code>registry.k8s.io</code>                                       |
| registry.credentials                         |                         | <code>{}</code>                                                    |
| helm.repositories.appscode-charts-legacy.url |                         | <code>https://charts.appscode.com/stable</code>                    |
| helm.repositories.appscode-charts-oci.url    |                         | <code>oci://r.appscode.com/charts</code>                           |
| helm.repositories.aws-ebs-csi-driver.url     |                         | <code>https://kubernetes-sigs.github.io/aws-ebs-csi-driver</code>  |
| helm.repositories.cluster-autoscaler.url     |                         | <code>https://kubernetes.github.io/autoscaler</code>               |
| helm.repositories.crossplane.url             |                         | <code>https://charts.crossplane.io/stable</code>                   |
| helm.repositories.falcosecurity.url          |                         | <code>https://falcosecurity.github.io/charts</code>                |
| helm.repositories.flux.url                   |                         | <code>https://fluxcd-community.github.io/helm-charts</code>        |
| helm.repositories.gatekeeper.url             |                         | <code>https://open-policy-agent.github.io/gatekeeper/charts</code> |
| helm.repositories.jetstack.url               |                         | <code>https://charts.jetstack.io</code>                            |
| helm.repositories.kedacore.url               |                         | <code>https://kedacore.github.io/charts</code>                     |
| helm.repositories.nats.url                   |                         | <code>https://nats-io.github.io/k8s/helm/charts</code>             |
| helm.repositories.prometheus-community.url   |                         | <code>https://prometheus-community.github.io/helm-charts</code>    |
| clusterManagers                              |                         | <code>[]</code>                                                    |
| capi.provider                                |                         | <code>""</code>                                                    |
| capi.namespace                               |                         | <code>""</code>                                                    |
| capi.clusterName                             |                         | <code>""</code>                                                    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.10.18 --set image.proxies.appscode=r.appscode.com
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i opscenter-features appscode/opscenter-features -n kubeops --create-namespace --version=v2023.10.18 --values values.yaml
```
