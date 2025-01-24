{{/*
Expand the name of the chart.
*/}}
{{- define "acaas.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "acaas.fullname" -}}
{{- if .Values.global.fullnameOverride }}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.global.nameOverride }}
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
{{- define "acaas.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "acaas.labels" -}}
helm.sh/chart: {{ include "acaas.chart" . }}
{{ include "acaas.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "acaas.selectorLabels" -}}
app.kubernetes.io/name: {{ include "acaas.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "settings.platformConfigSecretName" -}}
{{- default .Values.settings.secretName.platformConfig .Values.global.settings.secretName.platformConfig }}
{{- end }}

{{- define "settings.objstoreSecretName" -}}
{{- default .Values.settings.secretName.objstore .Values.global.settings.secretName.objstore }}
{{- end }}

{{- define "settings.caProviderClass" -}}
{{- default .Values.settings.caProviderClass .Values.global.settings.caProviderClass -}}
{{- end }}

{{- define "settings.spreadsheetSecretName" -}}
{{- default .Values.settings.secretName.spreadsheet .Values.global.settings.secretName.spreadsheet }}
{{- end }}
