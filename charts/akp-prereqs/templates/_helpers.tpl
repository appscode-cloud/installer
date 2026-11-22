{{- define "akp-prereqs.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/part-of: akp
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* dict "root" . "component" "x" */}}
{{- define "akp-prereqs.selector" -}}
app.kubernetes.io/name: {{ .component }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
{{- end -}}

{{- define "akp-prereqs.host" -}}
{{- required "global.platform.host is required" .Values.global.platform.host -}}
{{- end -}}

{{- define "akp-prereqs.portSuffix" -}}
{{- if ne (int .Values.global.httpsPort) 443 }}:{{ .Values.global.httpsPort }}{{ end -}}
{{- end -}}

{{- define "akp-prereqs.casdoorHost" -}}
{{- default (printf "casdoor.%s" (include "akp-prereqs.host" .)) .Values.casdoor.host -}}
{{- end -}}

{{- define "akp-prereqs.publicUrl" -}}
{{- printf "https://%s%s" (include "akp-prereqs.host" .) (include "akp-prereqs.portSuffix" .) -}}
{{- end -}}

{{- define "akp-prereqs.casdoorPublicUrl" -}}
{{- printf "https://%s%s" (include "akp-prereqs.casdoorHost" .) (include "akp-prereqs.portSuffix" .) -}}
{{- end -}}

{{/* image: dict "root" . "image" <{repository,tag,digest}> ; a digest wins over the tag */}}
{{- define "akp-prereqs.image" -}}
{{- if .image.digest -}}
{{ .image.repository }}@{{ .image.digest }}
{{- else -}}
{{ .image.repository }}:{{ .image.tag }}
{{- end -}}
{{- end -}}

{{- define "akp-prereqs.imagePullSecrets" -}}
{{- with .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end -}}

{{- define "akp-prereqs.credentials" -}}{{ printf "%s-credentials" .Release.Name }}{{- end -}}
{{- define "akp-prereqs.natsCreds" -}}{{ printf "%s-nats-creds" .Release.Name }}{{- end -}}
{{- define "akp-prereqs.postgres" -}}{{ printf "%s-postgres" .Release.Name }}{{- end -}}
{{- define "akp-prereqs.casdoor" -}}{{ printf "%s-casdoor" .Release.Name }}{{- end -}}
