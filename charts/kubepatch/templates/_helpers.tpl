{{- define "kubepatch.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 50 | trimSuffix "-" -}}
{{- else if contains "kubepatch" .Release.Name -}}
{{- .Release.Name | trunc 50 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-kubepatch" .Release.Name | trunc 50 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "kubepatch.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/part-of: kubepatch
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* kubepatch.selector: dict "root" . "component" "x" */}}
{{- define "kubepatch.selector" -}}
app.kubernetes.io/name: {{ .component }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
{{- end -}}

{{/* platform-ui reaches b3 as <release>-platform-api, so b3 takes that name. */}}
{{- define "kubepatch.b3name" -}}{{ printf "%s-platform-api" .Release.Name }}{{- end -}}

{{- define "kubepatch.host" -}}
{{- required "global.platform.host is required" .Values.global.platform.host -}}
{{- end -}}

{{- define "kubepatch.casdoorHost" -}}
{{- default (printf "casdoor.%s" (include "kubepatch.host" .)) .Values.casdoor.host -}}
{{- end -}}

{{- define "kubepatch.portSuffix" -}}
{{- if ne (int .Values.routing.httpsPort) 443 }}:{{ .Values.routing.httpsPort }}{{ end -}}
{{- end -}}

{{- define "kubepatch.publicUrl" -}}
{{- printf "https://%s%s" (include "kubepatch.host" .) (include "kubepatch.portSuffix" .) -}}
{{- end -}}

{{- define "kubepatch.casdoorPublicUrl" -}}
{{- printf "https://%s%s" (include "kubepatch.casdoorHost" .) (include "kubepatch.portSuffix" .) -}}
{{- end -}}

{{/* image: dict "root" . "image" <{repository,tag,digest}> ; a digest wins over the tag */}}
{{- define "kubepatch.image" -}}
{{- $registry := .root.Values.global.imageRegistry -}}
{{- $repo := ternary (printf "%s/%s" $registry .image.repository) .image.repository (ne $registry "") -}}
{{- if .image.digest -}}
{{ $repo }}@{{ .image.digest }}
{{- else -}}
{{ $repo }}:{{ .image.tag }}
{{- end -}}
{{- end -}}

{{- define "kubepatch.imagePullSecrets" -}}
{{- with .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range . }}
- name: {{ . }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "kubepatch.pgHost" -}}
{{- if .Values.postgres.external.enabled -}}
{{- required "postgres.external.host is required" .Values.postgres.external.host -}}
{{- else -}}
{{- printf "%s-postgres" (include "kubepatch.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "kubepatch.pgPort" -}}
{{- ternary .Values.postgres.external.port 5432 .Values.postgres.external.enabled -}}
{{- end -}}

{{- define "kubepatch.pgSslmode" -}}
{{- ternary .Values.postgres.external.sslmode "disable" .Values.postgres.external.enabled -}}
{{- end -}}

{{- define "kubepatch.natsUrl" -}}
{{- printf "nats://%s-nats.%s.svc:4222" (include "kubepatch.fullname" .) .Release.Namespace -}}
{{- end -}}

{{- define "kubepatch.credentialsSecret" -}}
{{/* The patch console sub-charts name it the same way: global.credentials.secretName, or <release>-credentials. */}}
{{- default (printf "%s-credentials" .Release.Name) .Values.credentials.existingSecret -}}
{{- end -}}

{{- define "kubepatch.tlsSecret" -}}
{{- default (printf "%s-tls" (include "kubepatch.fullname" .)) .Values.tls.existingSecret -}}
{{- end -}}

{{/* Names the platform-ui / cluster-ui subcharts give their Services: <release>-<chart>. */}}
{{- define "kubepatch.svc.platformUi" -}}{{ printf "%s-platform-ui" .Release.Name }}{{- end -}}
{{- define "kubepatch.svc.clusterUi" -}}{{ printf "%s-cluster-ui" .Release.Name }}{{- end -}}

{{- define "kubepatch.casdoorName" -}}{{ printf "%s-casdoor" .Release.Name }}{{- end -}}

{{/* The console's own nginx serves /patch and proxies /patch/api to the hub. The routes are shared by the Gateway API and Ingress renderings: list of dicts {path, svc, port}. */}}
{{- define "kubepatch.routes" -}}
{{- $fn := include "kubepatch.fullname" . -}}
{{- $r := list -}}
{{- if (index .Values "patch-console-ui" "enabled") -}}
{{- $r = append $r (dict "path" "/patch" "svc" (printf "%s-patch-console-ui" .Release.Name) "port" 80) -}}
{{- end -}}
{{- if .Values.b3.enabled -}}
{{- $r = append $r (dict "path" "/api" "svc" (include "kubepatch.b3name" .) "port" 80 "timeout" "55s") -}}
{{- $r = append $r (dict "path" "/accounts" "svc" (include "kubepatch.b3name" .) "port" 80 "timeout" "55s") -}}
{{- if or .Values.b3.iam.federation.enabled .Values.b3.iam.scim.enabled -}}
{{- $r = append $r (dict "path" "/iam" "svc" (include "kubepatch.b3name" .) "port" 80) -}}
{{- end -}}
{{- end -}}
{{- if .Values.nats.enabled -}}
{{- /* Placeholder: browsers reach NATS over WebSocket here once the UI uses it. */ -}}
{{- $r = append $r (dict "path" "/nats" "svc" (printf "%s-nats" $fn) "port" 8080) -}}
{{- end -}}
{{- if index .Values "cluster-ui" "enabled" -}}
{{- $r = append $r (dict "path" "/console" "svc" (include "kubepatch.svc.clusterUi" .) "port" 80) -}}
{{- end -}}
{{- if index .Values "platform-ui" "enabled" -}}
{{- $r = append $r (dict "path" "/id" "svc" (include "kubepatch.svc.platformUi" .) "port" 80) -}}
{{- end -}}
{{- toJson $r -}}
{{- end -}}

{{/* The value of a key of an existing Secret, "" when there is none (helm template). */}}
{{- define "kubepatch.secretKey" -}}
{{- if .name -}}
{{- $s := lookup "v1" "Secret" .root.Release.Namespace .name -}}
{{- if $s -}}{{ index $s.data .key | b64dec }}{{- end -}}
{{- end -}}
{{- end -}}

{{- define "kubepatch.patchEnv" }}
- name: HTTP_ADDR
  value: ":8080"
- name: PATCH_CONSOLE_DATABASE_URL_FILE
  value: /var/run/secrets/patch-console/database/url
{{- end }}

{{- define "kubepatch.parentRefs" }}
parentRefs:
{{- if .root.Values.routing.gateway.create }}
- group: gateway.networking.k8s.io
  kind: Gateway
  name: {{ include "kubepatch.fullname" .root }}
  namespace: {{ .root.Release.Namespace }}
  sectionName: {{ ternary "https" "http" (ne .root.Values.tls.mode "none") }}
{{- else }}
{{- toYaml .root.Values.routing.gateway.parentRefs | nindent 0 }}
{{- end }}
{{- end }}

{{/* The b3 probe: GetBranding answers without a session. */}}
{{- define "kubepatch.b3probe" -}}
["curl", "-fsS", "-o", "/dev/null", "-m", "4", "-X", "POST", "-H", "Content-Type: application/json", "-d", "{}", "http://localhost:3003/api/v2/akp.branding.v2.BrandingService/GetBranding"]
{{- end -}}

{{/* The image of a sub-chart that follows the registryFQDN / image.{registry,repository,tag,digest} convention. */}}
{{- define "kubepatch.subchartImage" -}}
{{- $repo := printf "%s/%s" (list .registryFQDN .image.registry | compact | join "/") .image.repository -}}
{{- if .image.digest -}}
{{ $repo }}@{{ .image.digest }}
{{- else -}}
{{ $repo }}:{{ required "the image tag is required" .image.tag }}
{{- end -}}
{{- end -}}
