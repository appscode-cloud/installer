{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "s3proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "s3proxy.fullname" -}}
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
{{- define "s3proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "s3proxy.labels" -}}
helm.sh/chart: {{ include "s3proxy.chart" . }}
{{ include "s3proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "s3proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "s3proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Returns the registry used for image docker image
*/}}
{{- define "s3proxy.registry" -}}
{{- list .Values.registryFQDN .Values.image.registry | compact | join "/" }}
{{- end }}

{{- define "appscode.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets -}}
imagePullSecrets:
{{- toYaml . | nindent 2 }}
{{- end }}
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
