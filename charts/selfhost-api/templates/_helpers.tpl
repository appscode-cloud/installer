{{/*
Expand the name of the chart.
*/}}
{{- define "selfhost-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "selfhost-api.fullname" -}}
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
{{- define "selfhost-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "selfhost-api.labels" -}}
helm.sh/chart: {{ include "selfhost-api.chart" . }}
{{ include "selfhost-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "selfhost-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "selfhost-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "appscode.serviceAccountName" -}}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}

{{/*
Returns the registry used for image docker image
*/}}
{{- define "image.registry" -}}
{{- list .Values.registryFQDN .Values.image.registry | compact | join "/" }}
{{- end }}

{{- define "appscode.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets -}}
imagePullSecrets:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Returns the enabled monitoring agent name
*/}}
{{- define "monitoring.agent" -}}
{{- .Values.monitoring.agent }}
{{- end }}

{{/*
Returns whether the ServiceMonitor will be labeled with custom label
*/}}
{{- define "monitoring.apply-servicemonitor-label" -}}
{{- ternary "false" "true" ( empty .Values.monitoring.serviceMonitor.labels ) -}}
{{- end }}

{{/*
Returns the ServiceMonitor labels
*/}}
{{- define "monitoring.servicemonitor-label" -}}
{{- range $key, $val := .Values.monitoring.serviceMonitor.labels }}
{{ $key }}: {{ $val }}
{{- end }}
{{- end }}

{{- define "settings.platformConfigSecretName" -}}
{{- default .Values.settings.secretName.platformConfig (dig "settings" "secretName" "platformConfig" "" (.Values.global | default dict)) }}
{{- end }}

{{- define "settings.platformUserConfigSecretName" -}}
{{- default .Values.settings.secretName.platformUserConfig (dig "settings" "secretName" "platformUserConfig" "" (.Values.global | default dict)) }}
{{- end }}

{{- define "settings.platformSystemConfigSecretName" -}}
{{- default .Values.settings.secretName.platformSystemConfig (dig "settings" "secretName" "platformSystemConfig" "" (.Values.global | default dict)) }}
{{- end }}

{{- define "settings.objstoreSecretName" -}}
{{- default .Values.settings.secretName.objstore (dig "settings" "secretName" "objstore" "" (.Values.global | default dict)) }}
{{- end }}

{{- define "settings.caProviderClass" -}}
{{- default .Values.settings.caProviderClass (dig "settings" "caProviderClass" "" (.Values.global | default dict)) -}}
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
