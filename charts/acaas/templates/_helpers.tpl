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

{{- define "settings.platformUserConfigSecretName" -}}
{{- default .Values.settings.secretName.platformUserConfig .Values.global.settings.secretName.platformUserConfig }}
{{- end }}

{{- define "settings.platformSystemConfigSecretName" -}}
{{- default .Values.settings.secretName.platformSystemConfig .Values.global.settings.secretName.platformSystemConfig }}
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

{{/*
Returns whether the OpenShift distribution is used
*/}}
{{- define "distro.openshift" -}}
{{- or (.Capabilities.APIVersions.Has "project.openshift.io/v1/Project") .Values.global.distro.openshift (and .Values.distro .Values.distro.openshift) -}}
{{- end }}

{{/*
Returns if ubi images are to be used
*/}}
{{- define "operator.ubi" -}}
{{ ternary "-ubi" "" (list "operator" "all" | has (default (dig "ubi" "" (default dict .Values.distro)) .Values.global.distro.ubi)) }}
{{- end }}

{{/*
Gateway API kinds are served at different versions depending on which CRD bundle the cluster
vendor ships (v1.3–v1.7, standard or experimental), and some vendors (OpenShift) omit them.
Returns the first of .versions the cluster serves for .kind, or "" when the kind is absent.
*/}}
{{- define "gatewayAPI.servedVersion" -}}
{{- $ctx := .ctx -}}
{{- $kind := .kind -}}
{{- range .versions -}}
{{- if $ctx.Capabilities.APIVersions.Has (printf "gateway.networking.k8s.io/%s/%s" . $kind) -}}
{{- . -}}
{{- break -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "gatewayAPI.tcpRouteVersion" -}}
{{- include "gatewayAPI.servedVersion" (dict "ctx" . "kind" "TCPRoute" "versions" (list "v1" "v1alpha2")) -}}
{{- end -}}

{{- define "gatewayAPI.backendTLSPolicyVersion" -}}
{{- include "gatewayAPI.servedVersion" (dict "ctx" . "kind" "BackendTLSPolicy" "versions" (list "v1" "v1alpha3")) -}}
{{- end -}}
