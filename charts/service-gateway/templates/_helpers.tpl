{{/*
Expand the name of the chart.
*/}}
{{- define "service-gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "service-gateway.fullname" -}}
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
{{- define "service-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "service-gateway.labels" -}}
helm.sh/chart: {{ include "service-gateway.chart" . }}
{{ include "service-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "service-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "service-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
The name of the tenant.
*/}}
{{- define "tenant.name" -}}
{{- ternary (trimSuffix "-gw" .Release.Namespace) .Release.Namespace (hasSuffix "-gw" .Release.Namespace) }}
{{- end }}

{{/*
The domain name used for the gateway.
<clusterName>.<orgName / "ace">.<domain>
*/}}
{{- define "gateway.domain" -}}
{{- if eq (dig "mode" "" (.Values.gatewayClass.annotations | default dict)) "hosted" -}}
{{- .Values.infra.host -}}
{{- else if and (eq .Values.infra.hostType "domain") (eq .Release.Namespace "ace") -}}
{{- .Values.infra.host -}}
{{- else -}}
{{- $ns := trimSuffix "-gw" .Release.Namespace -}}
{{- $useClusterName := or (eq $ns "ace") (eq .Values.infra.tenantSpreadPolicy "multi") -}}
{{- $prefix := ternary (printf "%s.%s" .Values.clusterMetadata.name $ns) $ns $useClusterName -}}
{{- printf "%s.%s" $prefix .Values.infra.host -}}
{{- end -}}
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
