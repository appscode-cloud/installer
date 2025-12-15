{{/*
Expand the name of the chart.
*/}}
{{- define "ace.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ace.fullname" -}}
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
{{- define "ace.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ace.labels" -}}
helm.sh/chart: {{ include "ace.chart" . }}
{{ include "ace.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ace.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ace.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Offshoot labels
*/}}
{{- define "ace.offshootLabels" -}}
helm.sh/chart: {{ include "ace.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "appscode.serviceAccountName" -}}
{{- if .Values.global.serviceAccount.create }}
{{- default (include "ace.fullname" .) .Values.global.serviceAccount.name }}
{{- else if .Values.serviceAccount }}
{{- default "default" .Values.serviceAccount.name }}
{{- else }}
{{- "default" }}
{{- end }}
{{- end }}

{{/*
Returns the appscode license
*/}}
{{- define "appscode.license" -}}
{{- default .Values.global.license .Values.license }}
{{- end }}

{{/*
Returns the registry used for app docker image
*/}}
{{- define "image.registry" -}}
{{- list .Values.global.registryFQDN (default .Values.image.registry .Values.global.registry) | compact | join "/" }}
{{- end }}

{{/*
Returns the registry used for kubectl docker image
*/}}
{{- define "kubectl.registry" -}}
{{- list .Values.global.registryFQDN (default .Values.kubectl.registry .Values.global.registry) | compact | join "/" }}
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
{{- .Values.global.monitoring.agent -}}
{{- end }}

{{/*
Returns whether the ServiceMonitor will be labeled with custom label
*/}}
{{- define "monitoring.apply-servicemonitor-label" -}}
{{- ternary "false" "true" (empty .Values.global.monitoring.serviceMonitor.labels) -}}
{{- end }}

{{/*
Returns the ServiceMonitor labels
*/}}
{{- define "monitoring.servicemonitor-label" -}}
{{- range $key, $val := .Values.global.monitoring.serviceMonitor.labels }}
{{ $key }}: {{ $val }}
{{- end }}
{{- end }}

{{- define "settings.platformConfigSecretName" -}}
{{- printf "%s-config" (include "ace.fullname" .) -}}
{{- end }}

{{- define "settings.platformUserConfigSecretName" -}}
{{- printf "%s-user-config" (include "ace.fullname" .) -}}
{{- end }}

{{- define "settings.platformSystemConfigSecretName" -}}
{{- printf "%s-system-config" (include "ace.fullname" .) -}}
{{- end }}


{{- define "settings.grafanaConfigSecretName" -}}
{{- printf "%s-grafana-config" (include "ace.fullname" .) -}}
{{- end }}

{{- define "settings.objstoreSecretName" -}}
{{- if not (.Values.global.infra.objstore.enableCredLess) }}
{{- printf "%s-objstore-cred" (include "ace.fullname" .) -}}
{{- end }}
{{- end }}

{{- define "settings.natsSecretName" -}}
{{- printf "%s-nats-cred" (include "ace.fullname" .) -}}
{{- end }}

{{- define "settings.natsMountPath" -}}
{{- .Values.settings.nats.mountPath }}
{{- end }}

{{/*
Determine database host name
*/}}
{{- define "settings.database.host" -}}
{{- printf "%s-db.%s.svc:5432" (include "ace.fullname" .) .Release.Namespace -}}
{{- end -}}

{{- define  "settings.oauth2JWTSecret" -}}
{{ .Values.settings.security.oauth2JWTSecret | default (randAlphaNum 43) }}
{{- end -}}

{{- define  "settings.csrfSecretkey" -}}
{{ .Values.settings.security.csrfSecretKey | default (randAlphaNum 64) }}
{{- end -}}

{{- define "settings.cache.host" -}}
{{- printf "network=tcp,addr=%s-cache.%s.svc:6379,password='%s',db=1,pool_size=100,idle_timeout=180,prefix=cache-" (include "ace.fullname" .) .Release.Namespace .Values.settings.cache.auth.password -}}
{{- end -}}

{{- define "settings.session.host" -}}
{{- printf "network=tcp,addr=%s-cache.%s.svc:6379,password='%s',db=0,pool_size=100,idle_timeout=180,prefix=session-" (include "ace.fullname" .) .Release.Namespace .Values.settings.cache.auth.password -}}
{{- end -}}


{{- define "grafana.cache.host" -}}
{{- printf "addr=%s-cache.%s.svc:6379,password='%s',db=1,pool_size=100" (include "ace.fullname" .) .Release.Namespace .Values.settings.cache.auth.password -}}
{{- end -}}

{{- define "grafana.session.host" -}}
{{- printf "addr=%s-cache.%s.svc:6379,password='%s',db=0,pool_size=100" (include "ace.fullname" .) .Release.Namespace .Values.settings.cache.auth.password -}}
{{- end -}}

{{- define  "settings.kms.masterKeyURL" -}}
{{- if .Values.global.infra.kms.masterKeyURL -}}
{{- .Values.global.infra.kms.masterKeyURL -}}
{{- else -}}
{{- printf "base64key://%s" (randAlphaNum 64) -}}
{{- end -}}
{{- end -}}

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
{{ ternary "-ubi" "" (list "operator" "all" | has .Values.distro.ubi) }}
{{- end }}
