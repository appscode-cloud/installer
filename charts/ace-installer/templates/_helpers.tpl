{{/*
Expand the name of the chart.
*/}}
{{- define "ace-installer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ace-installer.fullname" -}}
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
{{- define "ace-installer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ace-installer.labels" -}}
helm.sh/chart: {{ include "ace-installer.chart" . }}
{{ include "ace-installer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ace-installer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ace-installer.name" . }}
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

{{/*
Returns the registry used for app docker image
*/}}
{{- define "precheck.image.registry" -}}
{{- list .Values.image.proxies.ghcr .Values.precheck.image.registry | compact | join "/" }}
{{- end }}

{{/*
Returns the registry used for tester docker image
*/}}
{{- define "tester.image.registry" -}}
{{- list .Values.image.proxies.ghcr .Values.tester.image.registry | compact | join "/" }}
{{- end }}

{{/*
Returns the in-cluster address (host:port) of the registry proxy service. This
must match the regcache subchart's fullname (templates/_helpers.tpl in the
regcache chart), since the subchart names its Service after it.
*/}}
{{- define "regcache.serviceAddress" -}}
{{- $name := default "regcache" .Values.regcache.nameOverride -}}
{{- $fullname := "" -}}
{{- if .Values.regcache.fullnameOverride -}}
{{- $fullname = .Values.regcache.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if contains $name .Release.Name -}}
{{- $fullname = .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $fullname = printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- printf "%s.%s.svc:%v" $fullname .Release.Namespace (default 5000 .Values.regcache.service.port) -}}
{{- end }}

{{/*
When the in-cluster registry proxy is enabled, rewrites the appscode-wizards-oci
HelmRepository (if present) to pull through the proxy instead of directly from
ghcr.io. The proxy serves plain HTTP, hence insecure. Mutates the passed repos
dict in place; expects a dict with keys "top" (root ctx) and "repos".
*/}}
{{- define "ace-installer.applyRegcache" -}}
{{- $top := .top -}}
{{- if $top.Values.regcache.enabled -}}
{{- with (dig "appscode-wizards-oci" dict .repos) -}}
{{- $_ := set . "url" (printf "oci://%s/appscode-charts" (include "regcache.serviceAddress" $top)) -}}
{{- $_ := set . "type" "oci" -}}
{{- $_ := set . "insecure" true -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Returns whether the OpenShift distribution is used
*/}}
{{- define "distro.openshift" -}}
{{- or (.Capabilities.APIVersions.Has "project.openshift.io/v1/Project") (dig "distro" "openshift" false (.Values.options | fromYaml)) -}}
{{- end }}

{{/*
Returns if ubi images are to be used
*/}}
{{- define "operator.ubi" -}}
{{ ternary "-ubi" "" (list "operator" "all" | has (dig "distro" "ubi" "" (.Values.options | fromYaml))) }}
{{- end }}
