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
{{ prepend (list ._repo) (list .Values.image.proxies.dockerHub .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "registry.dockerLibrary" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.dockerLibrary .Values.image.proxies.dockerHub .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "registry.ghcr" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.ghcr .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "registry.quay" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.quay .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "registry.kubernetes" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.kubernetes .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "registry.appscode" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.appscode .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{/*
Image Templates
*/}}
{{- define "image.dockerHub" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.dockerHub .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "image.dockerLibrary" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.dockerLibrary .Values.image.proxies.dockerHub .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "image.ghcr" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.ghcr .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "image.quay" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.quay .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "image.kubernetes" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.kubernetes .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}

{{- define "image.appscode" -}}
{{ prepend (list ._repo) (list .Values.image.proxies.appscode .Values.image.registryFQDN | compact | first) | compact | join "/" }}
{{- end }}
