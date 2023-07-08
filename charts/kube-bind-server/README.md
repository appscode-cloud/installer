# kube-bind Server

[kube-bind Server by AppsCode](https://github.com/bytebuilders/kube-bind-server) - kube-bind Server for Kubernetes

## TL;DR;

```bash
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search repo appscode/kube-bind-server --version=v2023.03.23
$ helm upgrade -i kube-bind-server appscode/kube-bind-server -n kubeops --create-namespace --version=v2023.03.23
```

## Introduction

This chart deploys a kube-bind Server on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.21+

## Installing the Chart

To install/upgrade the chart with the release name `kube-bind-server`:

```bash
$ helm upgrade -i kube-bind-server appscode/kube-bind-server -n kubeops --create-namespace --version=v2023.03.23
```

The command deploys a kube-bind Server on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `kube-bind-server`:

```bash
$ helm uninstall kube-bind-server -n kubeops
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `kube-bind-server` chart and their default values.

|            Parameter             |                                                                                                                     Description                                                                                                                      |                                                                                            Default                                                                                             |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| nameOverride                     | Overrides name template                                                                                                                                                                                                                              | <code>""</code>                                                                                                                                                                                |
| fullnameOverride                 | Overrides fullname template                                                                                                                                                                                                                          | <code>""</code>                                                                                                                                                                                |
| replicaCount                     |                                                                                                                                                                                                                                                      | <code>1</code>                                                                                                                                                                                 |
| registryFQDN                     | Docker registry fqdn used to pull docker images Set this to use docker registry hosted at ${registryFQDN}/${registry}/${image}                                                                                                                       | <code>ghcr.io</code>                                                                                                                                                                           |
| image.registry                   | Docker registry used to pull operator image                                                                                                                                                                                                          | <code>appscode</code>                                                                                                                                                                          |
| image.repository                 | Name of operator container image                                                                                                                                                                                                                     | <code>kube-bind-server</code>                                                                                                                                                                  |
| image.tag                        | Overrides the image tag whose default is the chart appVersion.                                                                                                                                                                                       | <code>""</code>                                                                                                                                                                                |
| image.resources                  | Compute Resources required by the operator container                                                                                                                                                                                                 | <code>{}</code>                                                                                                                                                                                |
| image.securityContext            | Security options this container should run with                                                                                                                                                                                                      | <code>{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}</code> |
| imagePullSecrets                 | Specify an array of imagePullSecrets. Secrets must be manually created in the namespace. <br> Example: <br> `helm template charts/stash \` <br> `--set imagePullSecrets[0].name=sec0 \` <br> `--set imagePullSecrets[1].name=sec1`                   | <code>[]</code>                                                                                                                                                                                |
| imagePullPolicy                  | Container image pull policy                                                                                                                                                                                                                          | <code>Always</code>                                                                                                                                                                            |
| serviceAccount.create            | Specifies whether a service account should be created                                                                                                                                                                                                | <code>true</code>                                                                                                                                                                              |
| serviceAccount.annotations       | Annotations to add to the service account                                                                                                                                                                                                            | <code>{}</code>                                                                                                                                                                                |
| serviceAccount.name              | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                                                                                                                               | <code>""</code>                                                                                                                                                                                |
| podAnnotations                   |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                                                                |
| podSecurityContext               |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                                                                |
| nodeSelector                     |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                                                                |
| tolerations                      |                                                                                                                                                                                                                                                      | <code>[]</code>                                                                                                                                                                                |
| affinity                         |                                                                                                                                                                                                                                                      | <code>{}</code>                                                                                                                                                                                |
| monitoring.agent                 | Name of monitoring agent (one of "prometheus.io", "prometheus.io/operator", "prometheus.io/builtin")                                                                                                                                                 | <code>""</code>                                                                                                                                                                                |
| monitoring.serviceMonitor.labels | Specify the labels for ServiceMonitor. Prometheus crd will select ServiceMonitor using these labels. Only usable when monitoring agent is `prometheus.io/operator`.                                                                                  | <code>{}</code>                                                                                                                                                                                |
| server.oidc.clientID             | issuer client ID                                                                                                                                                                                                                                     | <code>""</code>                                                                                                                                                                                |
| server.oidc.clientSecret         | issuer client Secret                                                                                                                                                                                                                                 | <code>""</code>                                                                                                                                                                                |
| server.oidc.issuerURL            |                                                                                                                                                                                                                                                      | <code>"https://accounts.appscode.ninja/"</code>                                                                                                                                                |
| server.oidc.callbackURL          |                                                                                                                                                                                                                                                      | <code>"https://bind.appscode.ninja/callback"</code>                                                                                                                                            |
| server.namespacePrefix           | the sync namespace created in the provider side will be named like bb-<some-hash>                                                                                                                                                                    | <code>"bb-"</code>                                                                                                                                                                             |
| server.providerPrettyName        | the name of the provider                                                                                                                                                                                                                             | <code>"Appscode"</code>                                                                                                                                                                        |
| server.consumerScope             | How consumers access the service provider cluster. In Kubernetes, "namespaced" allows namespace isolation. In kcp, "cluster" allows workspace isolation, and with that allows cluster-scoped resources to bind, and it is generally more performant. | <code>"Namespaced"</code>                                                                                                                                                                      |
| server.external.address          | The external address for the service provider cluster, including https:// and port. If not specified, service account's hosts are used.                                                                                                              | <code>""</code>                                                                                                                                                                                |
| server.external.serverName       | The external (TLS) server name used by consumers to talk to the service provider cluster. This can be useful to select the right certificate via SNI.                                                                                                | <code>""</code>                                                                                                                                                                                |
| server.external.CAFile           | The external CA file for the service provider cluster. If not specified, service account's CA is used.                                                                                                                                               | <code>""</code>                                                                                                                                                                                |
| server.cookie.signingKey         | The key which is used to sign cookies, base64 encoded. Valid lengths are 32 or 64 bytes.                                                                                                                                                             | <code>""</code>                                                                                                                                                                                |
| server.cookie.encryptionKey      | The key which is used to encrypt cookies, base64 encoded, optional. Valid lengths are 16, 24, or 32 bytes selecting AES-128, AES-192, or AES-256.                                                                                                    | <code>""</code>                                                                                                                                                                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i kube-bind-server appscode/kube-bind-server -n kubeops --create-namespace --version=v2023.03.23 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i kube-bind-server appscode/kube-bind-server -n kubeops --create-namespace --version=v2023.03.23 --values values.yaml
```
