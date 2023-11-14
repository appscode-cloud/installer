{{/*
Expand the name of the chart.
*/}}
{{- define "ace-ocm-addons.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ace-ocm-addons.fullname" -}}
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
{{- define "ace-ocm-addons.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ace-ocm-addons.labels" -}}
helm.sh/chart: {{ include "ace-ocm-addons.chart" . }}
{{ include "ace-ocm-addons.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ace-ocm-addons.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ace-ocm-addons.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ace-ocm-addons.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ace-ocm-addons.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
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
