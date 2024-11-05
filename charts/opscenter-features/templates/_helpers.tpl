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
{{ list .Values.image.proxies.ghcr "appscode/kubectl-nonroot:1.31" | compact | join "/" }}
{{- end }}

{{- define "clustermanager.openshift" -}}
{{- ternary "true" "false" (.Capabilities.APIVersions.Has "project.openshift.io/v1/Project") -}}
{{- end }}

{{- define "clustermanager.rancher" -}}
{{- ternary "true" "false" (or (has "Rancher" .Values.clusterMetadata.clusterManagers) (and (.Capabilities.APIVersions.Has "management.cattle.io/v3") (not (empty (lookup "management.cattle.io/v3" "Cluster" "" "local"))))) -}}
{{- end }}
