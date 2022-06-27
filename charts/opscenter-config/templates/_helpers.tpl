{{/*
Expand the name of the chart.
*/}}
{{- define "opscenter-config.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "opscenter-config.fullname" -}}
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
{{- define "opscenter-config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "opscenter-config.labels" -}}
helm.sh/chart: {{ include "opscenter-config.chart" . }}
{{ include "opscenter-config.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "opscenter-config.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opscenter-config.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "opscenter-config.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "opscenter-config.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Returns the appscode license
*/}}
{{- define "appscode.license" -}}
{{- default .Values.global.license .Values.license }}
{{- end }}

{{/*
Returns the registry used for image docker image
*/}}
{{- define "image.registry" -}}
{{- list (default .Values.registryFQDN .Values.global.registryFQDN) (default .Values.image.registry .Values.global.registry) | compact | join "/" }}
{{- end }}

{{/*
Returns the registry used for cleaner docker image
*/}}
{{- define "cleaner.registry" -}}
{{- list (default .Values.registryFQDN .Values.global.registryFQDN) (default .Values.cleaner.registry .Values.global.registry) | compact | join "/" }}
{{- end }}

{{/*
Returns the appscode image pull secrets
*/}}
{{- define "appscode.imagePullSecrets" -}}
{{- with .Values.global.imagePullSecrets -}}
imagePullSecrets:
{{- toYaml . | nindent 2 }}
{{- else -}}
imagePullSecrets:
{{- toYaml $.Values.imagePullSecrets | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Returns the enabled monitoring agent name
*/}}
{{- define "monitoring.agent" -}}
{{- default .Values.monitoring.agent .Values.global.monitoring.agent }}
{{- end }}

{{/*
Returns whether the ServiceMonitor will be labeled with custom label
*/}}
{{- define "monitoring.apply-servicemonitor-label" -}}
{{- ternary "false" "true" (and (empty .Values.global.monitoring.serviceMonitor.labels) (empty .Values.monitoring.serviceMonitor.labels) ) -}}
{{- end }}

{{/*
Returns the ServiceMonitor labels
*/}}
{{- define "monitoring.servicemonitor-label" -}}
{{- range $key, $val := .Values.monitoring.serviceMonitor.labels }}
{{ $key }}: {{ $val }}
{{- else }}
{{- range $key, $val := .Values.global.monitoring.serviceMonitor.labels }}
{{ $key }}: {{ $val }}
{{- end }}
{{- end }}
{{- end }}
