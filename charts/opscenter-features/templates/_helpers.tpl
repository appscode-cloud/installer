{{/*
Expand the name of the chart.
*/}}
{{- define "opscenter-features.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "opscenter-features.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "opscenter-features.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "opscenter-features.labels" -}}
helm.sh/chart: {{ include "opscenter-features.chart" . }}
{{ include "opscenter-features.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "opscenter-features.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opscenter-features.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Registry Proxy Templates
*/}}
{{- define "registry.dockerHub" -}}
{{ .Values.image.proxies.dockerHub }}
{{- end }}

{{- define "registry.dockerLibrary" -}}
{{ default .Values.image.proxies.dockerHub .Values.image.proxies.dockerLibrary }}
{{- end }}

{{- define "registry.ghcr" -}}
{{ .Values.image.proxies.ghcr }}
{{- end }}

{{- define "registry.quay" -}}
{{ .Values.image.proxies.quay }}
{{- end }}

{{- define "registry.kubernetes" -}}
{{ .Values.image.proxies.kubernetes }}
{{- end }}

{{- define "registry.appscode" -}}
{{ .Values.image.proxies.appscode }}
{{- end }}

{{/*
Image Templates
*/}}
{{- define "image.dockerHub" -}}
{{ list .Values.image.proxies.dockerHub ._repo | compact | join "/" }}
{{- end }}

{{- define "image.dockerLibrary" -}}
{{ list (default .Values.image.proxies.dockerHub .Values.image.proxies.dockerLibrary) ._repo | compact | join "/" }}
{{- end }}

{{- define "image.ghcr" -}}
{{ list .Values.image.proxies.ghcr ._repo | compact | join "/" }}
{{- end }}

{{- define "image.quay" -}}
{{ list .Values.image.proxies.quay ._repo | compact | join "/" }}
{{- end }}

{{- define "image.kubernetes" -}}
{{ list .Values.image.proxies.kubernetes ._repo | compact | join "/" }}
{{- end }}

{{- define "image.appscode" -}}
{{ list .Values.image.proxies.appscode ._repo | compact | join "/" }}
{{- end }}

{{- define "kubectl.image" -}}
{{ list .Values.image.proxies.ghcr "appscode/kubectl-nonroot:1.34" | compact | join "/" }}
{{- end }}

{{- define "distro.rancher" -}}
{{- ternary "true" "false" (or (has "Rancher" .Values.clusterMetadata.clusterManagers) (and (.Capabilities.APIVersions.Has "management.cattle.io/v3") (not (empty (lookup "management.cattle.io/v3" "Cluster" "" "local"))))) -}}
{{- end }}

{{/*
Returns whether the OpenShift distribution is used
*/}}
{{- define "distro.openshift" -}}
{{- or (.Capabilities.APIVersions.Has "project.openshift.io/v1/Project") .Values.distro.openshift -}}
{{- end }}

{{/*
Returns if ubi images are to be used
*/}}
{{- define "operator.ubi" -}}
{{ ternary "-ubi" "" (list "operator" "all" | has .Values.distro.ubi) }}
{{- end }}

{{- define "opscenter-features.credPaths" -}}
stash-presets:
- kubestash.encryptionSecret
- kubestash.backend.s3.auth.AWS_ACCESS_KEY_ID
- kubestash.backend.s3.auth.AWS_SECRET_ACCESS_KEY
- kubestash.backend.azure.auth.AZURE_ACCOUNT_KEY
- kubestash.backend.gcs.auth.GOOGLE_SERVICE_ACCOUNT_JSON_KEY
service-gateway-presets:
- infra.tls.ca.key
- infra.tls.certificate.key
- infra.tls.jks.password
- infra.tls.jks.keystore
- infra.dns.auth.cloudflare.token
- infra.dns.auth.route53.AWS_ACCESS_KEY_ID
- infra.dns.auth.route53.AWS_SECRET_ACCESS_KEY
- infra.dns.auth.cloudDNS.GOOGLE_SERVICE_ACCOUNT_JSON_KEY
- infra.dns.auth.azureDNS.servicePrincipalAppPassword
- cluster.tls.ca.key
prom-label-proxy:
- infra.tls.ca.key
- infra.tls.certificate.key
- infra.tls.jks.password
- infra.tls.jks.keystore
service-backend:
- server.oidc.clientSecret
- server.cookie.signingKey
- server.cookie.encryptionKey
inbox-server:
- james.secret.jwtPrivateKey
- james.secret.dkimPrivateKey
- james.env.jamesKeyStorePassword
- postgresql.auth.password
{{- end -}}

{{- define "opscenter-features.profileCredPaths" -}}
{{- $paths := list "licenseServer.token" -}}
{{- range $child, $childPaths := include "opscenter-features.credPaths" . | fromYaml -}}
  {{- range $childPaths -}}
    {{- $paths = append $paths (printf "helm.releases.%s.values.%s" $child .) -}}
  {{- end -}}
{{- end -}}
{{- toYaml $paths -}}
{{- end -}}

{{/*
Removes dotted .paths from .vals in place. Pass a deepCopy: .Values is shared across templates and the cred Secret reads it.
*/}}
{{- define "opscenter-features.unsetPaths" -}}
{{- $vals := .vals -}}
{{- range .paths -}}
  {{- $keys := splitList "." . -}}
  {{- $parent := $vals -}}
  {{- range initial $keys -}}
    {{- if kindIs "map" $parent -}}
      {{- $parent = get $parent . -}}
    {{- end -}}
  {{- end -}}
  {{- if kindIs "map" $parent -}}
    {{- $_ := unset $parent (last $keys) -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Renders the subtree of .vals holding only the non-empty dotted .paths.
*/}}
{{- define "opscenter-features.pickPaths" -}}
{{- $vals := .vals -}}
{{- $out := dict -}}
{{- range .paths -}}
  {{- $keys := splitList "." . -}}
  {{- $v := $vals -}}
  {{- range $keys -}}
    {{- if kindIs "map" $v -}}
      {{- $v = get $v . -}}
    {{- else -}}
      {{- $v = "" -}}
    {{- end -}}
  {{- end -}}
  {{- if not (empty $v) -}}
    {{- $cur := $out -}}
    {{- range initial $keys -}}
      {{- if not (hasKey $cur .) -}}
        {{- $_ := set $cur . dict -}}
      {{- end -}}
      {{- $cur = get $cur . -}}
    {{- end -}}
    {{- $_ := set $cur (last $keys) $v -}}
  {{- end -}}
{{- end -}}
{{- toYaml $out -}}
{{- end -}}
