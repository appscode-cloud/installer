{{- define "trustconsole.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 50 | trimSuffix "-" -}}
{{- else if contains "trustconsole" .Release.Name -}}
{{- .Release.Name | trunc 50 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-trustconsole" .Release.Name | trunc 50 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "trustconsole.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/part-of: trustconsole
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* trustconsole.selector: dict "root" . "component" "x" */}}
{{- define "trustconsole.selector" -}}
app.kubernetes.io/name: {{ .component }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
{{- end -}}

{{/* platform-ui reaches b3 as <release>-platform-api, so b3 takes that name. */}}
{{- define "trustconsole.b3name" -}}{{ printf "%s-platform-api" .Release.Name }}{{- end -}}

{{- define "trustconsole.host" -}}
{{- required "global.platform.host is required" .Values.global.platform.host -}}
{{- end -}}

{{- define "trustconsole.casdoorHost" -}}
{{- default (printf "casdoor.%s" (include "trustconsole.host" .)) .Values.casdoor.host -}}
{{- end -}}

{{- define "trustconsole.portSuffix" -}}
{{- if ne (int .Values.routing.httpsPort) 443 }}:{{ .Values.routing.httpsPort }}{{ end -}}
{{- end -}}

{{- define "trustconsole.publicUrl" -}}
{{- printf "https://%s%s" (include "trustconsole.host" .) (include "trustconsole.portSuffix" .) -}}
{{- end -}}

{{- define "trustconsole.casdoorPublicUrl" -}}
{{- printf "https://%s%s" (include "trustconsole.casdoorHost" .) (include "trustconsole.portSuffix" .) -}}
{{- end -}}

{{/* image: dict "root" . "image" <{repository,tag,digest}> ; a digest wins over the tag */}}
{{- define "trustconsole.image" -}}
{{- $registry := .root.Values.global.imageRegistry -}}
{{- $repo := ternary (printf "%s/%s" $registry .image.repository) .image.repository (ne $registry "") -}}
{{- if .image.digest -}}
{{ $repo }}@{{ .image.digest }}
{{- else -}}
{{ $repo }}:{{ .image.tag }}
{{- end -}}
{{- end -}}

{{- define "trustconsole.imagePullSecrets" -}}
{{- with .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range . }}
- name: {{ . }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "trustconsole.pgHost" -}}
{{- if .Values.postgres.external.enabled -}}
{{- required "postgres.external.host is required" .Values.postgres.external.host -}}
{{- else -}}
{{- printf "%s-postgres" (include "trustconsole.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "trustconsole.pgPort" -}}
{{- ternary .Values.postgres.external.port 5432 .Values.postgres.external.enabled -}}
{{- end -}}

{{- define "trustconsole.pgSslmode" -}}
{{- ternary .Values.postgres.external.sslmode "disable" .Values.postgres.external.enabled -}}
{{- end -}}

{{- define "trustconsole.natsUrl" -}}
{{- printf "nats://%s-nats.%s.svc:4222" (include "trustconsole.fullname" .) .Release.Namespace -}}
{{- end -}}

{{- define "trustconsole.credentialsSecret" -}}
{{/* The trust-console-api sub-chart names it the same way: global.credentials.secretName, or <release>-credentials. */}}
{{- default (printf "%s-credentials" .Release.Name) .Values.credentials.existingSecret -}}
{{- end -}}

{{- define "trustconsole.tlsSecret" -}}
{{- default (printf "%s-tls" (include "trustconsole.fullname" .)) .Values.tls.existingSecret -}}
{{- end -}}

{{/* Names the platform-ui / cluster-ui subcharts give their Services: <release>-<chart>. */}}
{{- define "trustconsole.svc.platformUi" -}}{{ printf "%s-platform-ui" .Release.Name }}{{- end -}}
{{- define "trustconsole.svc.clusterUi" -}}{{ printf "%s-cluster-ui" .Release.Name }}{{- end -}}

{{/* The routes of the AKP host, shared by the Gateway API and Ingress renderings: list of dicts {path, svc, port}. */}}
{{- define "trustconsole.routes" -}}
{{- $fn := include "trustconsole.fullname" . -}}
{{- $r := list -}}
{{- if .Values.b3.enabled -}}
{{- $r = append $r (dict "path" "/api" "svc" (include "trustconsole.b3name" .) "port" 80 "timeout" "55s") -}}
{{- $r = append $r (dict "path" "/accounts" "svc" (include "trustconsole.b3name" .) "port" 80 "timeout" "55s") -}}
{{- if or .Values.b3.iam.federation.enabled .Values.b3.iam.scim.enabled -}}
{{- $r = append $r (dict "path" "/iam" "svc" (include "trustconsole.b3name" .) "port" 80) -}}
{{- end -}}
{{- end -}}
{{- if .Values.nats.enabled -}}
{{- /* Placeholder: browsers reach NATS over WebSocket here once the UI uses it. */ -}}
{{- $r = append $r (dict "path" "/nats" "svc" (printf "%s-nats" $fn) "port" 8080) -}}
{{- end -}}
{{- if index .Values "cluster-ui" "enabled" -}}
{{- $r = append $r (dict "path" "/console" "svc" (include "trustconsole.svc.clusterUi" .) "port" 80) -}}
{{- end -}}
{{- if index .Values "platform-ui" "enabled" -}}
{{- $r = append $r (dict "path" "/id" "svc" (include "trustconsole.svc.platformUi" .) "port" 80) -}}
{{- end -}}
{{- toJson $r -}}
{{- end -}}

{{/* The value of a key of an existing Secret, "" when there is none (helm template). */}}
{{- define "trustconsole.secretKey" -}}
{{- if .name -}}
{{- $s := lookup "v1" "Secret" .root.Release.Namespace .name -}}
{{- if $s -}}{{ index $s.data .key | b64dec }}{{- end -}}
{{- end -}}
{{- end -}}

{{/* The host of the Trust Console: its own, because the hub's API prefix /api is AKP's too. */}}
{{- define "trustconsole.trustHost" -}}
{{- default (printf "trust.%s" (include "trustconsole.host" .)) .Values.trustConsole.host -}}
{{- end -}}

{{- define "trustconsole.trustPublicUrl" -}}
{{- printf "https://%s%s" (include "trustconsole.trustHost" .) (include "trustconsole.portSuffix" .) -}}
{{- end -}}

{{- define "trustconsole.casdoorName" -}}{{ printf "%s-casdoor" .Release.Name }}{{- end -}}

{{- define "trustconsole.parentRefs" }}
parentRefs:
{{- if .root.Values.routing.gateway.create }}
- group: gateway.networking.k8s.io
  kind: Gateway
  name: {{ include "trustconsole.fullname" .root }}
  namespace: {{ .root.Release.Namespace }}
  sectionName: {{ ternary "https" "http" (ne .root.Values.tls.mode "none") }}
{{- else }}
{{- toYaml .root.Values.routing.gateway.parentRefs | nindent 0 }}
{{- end }}
{{- end }}

{{/* The b3 probe: GetBranding answers without a session. */}}
{{- define "trustconsole.b3probe" -}}
["curl", "-fsS", "-o", "/dev/null", "-m", "4", "-X", "POST", "-H", "Content-Type: application/json", "-d", "{}", "http://localhost:3003/api/v2/akp.branding.v2.BrandingService/GetBranding"]
{{- end -}}

{{/* The image of a sub-chart that follows the registryFQDN / image.{registry,repository,tag,digest} convention. */}}
{{- define "trustconsole.subchartImage" -}}
{{- $repo := printf "%s/%s" (list .registryFQDN .image.registry | compact | join "/") .image.repository -}}
{{- if .image.digest -}}
{{ $repo }}@{{ .image.digest }}
{{- else -}}
{{ $repo }}:{{ required "the image tag is required" .image.tag }}
{{- end -}}
{{- end -}}
