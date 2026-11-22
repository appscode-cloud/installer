{{- define "patch-console-ui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* <release>-<chart>, or the release name when it already has the chart's name. */}}
{{- define "patch-console-ui.fullname" -}}
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

{{- define "patch-console-ui.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "patch-console-ui.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "patch-console-ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "patch-console-ui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* A digest wins over the tag, so a pinned image cannot drift. */}}
{{- define "patch-console-ui.image" -}}
{{- $repo := printf "%s/%s" (list .Values.registryFQDN .Values.image.registry | compact | join "/") .Values.image.repository -}}
{{- if .Values.image.digest -}}
{{ $repo }}@{{ .Values.image.digest }}
{{- else -}}
{{ $repo }}:{{ .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}
{{- end }}

{{- define "patch-console-ui.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
{{- range . }}
- name: {{ . }}
{{- end }}
{{- end }}
{{- end }}

{{- define "patch-console-ui.serviceAccountName" -}}
{{- default (include "patch-console-ui.fullname" .) .Values.serviceAccount.name }}
{{- end }}

{{/* https://<global.platform.host>[:<global.platform.httpsPort>] */}}
{{- define "patch-console-ui.baseUrl" -}}
{{- $g := (default dict .Values.global).platform | default dict -}}
{{- $port := int (default 443 $g.httpsPort) -}}
{{- printf "https://%s%s" (required "global.platform.host (or clusterUi.baseUrl) is required" $g.host) (ternary "" (printf ":%d" $port) (eq $port 443)) -}}
{{- end }}
