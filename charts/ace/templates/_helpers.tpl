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

{{- define "geoipdb.registry" -}}
{{- list .Values.global.registryFQDN (default .Values.geoipdb.registry .Values.global.registry) | compact | join "/" }}
{{- end }}

{{- define "gotenberg.registry" -}}
{{- list .Values.global.registryFQDN (default .Values.gotenberg.registry .Values.global.registry) | compact | join "/" }}
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
{{- if .Values.settings.db.host -}}
{{- .Values.settings.db.host -}}
{{- else if .Values.settings.pgpool.enabled -}}
{{- printf "%s-pgpool.%s.svc:9999" (include "ace.fullname" .) .Release.Namespace -}}
{{- else -}}
{{- printf "%s-db.%s.svc:5432" (include "ace.fullname" .) .Release.Namespace -}}
{{- end -}}
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
Replicates "cadence.fullname" of the cadence chart, so that the ace chart can
refer to the resources created by the cadence chart.
*/}}
{{- define "ace.cadenceFullname" -}}
{{- if .Values.cadence.fullnameOverride -}}
{{- .Values.cadence.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "cadence" .Values.cadence.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Determine cadence frontend host name
*/}}
{{- define "settings.cadence.host" -}}
{{- .Values.settings.cadence.host | default (printf "%s-frontend.%s.svc" (include "ace.cadenceFullname" .) .Release.Namespace) -}}
{{- end -}}

{{/*
Overrides "cadence.databaseSecrets" of the cadence chart (the parent chart's
definition wins), so that the cadence chart does not create its
<cadence fullname>-<service>-secrets from config.persistence.database.sql.password.
templates/cadence/cadence-db-secret.yaml creates them from settings.db.auth.password.
*/}}
{{- define "cadence.databaseSecrets" -}}
{{- $_ := set . "databaseSecrets" list -}}
{{- end -}}

{{/*
Gateway-native FQDN for the ace deployment.
Only used during the ingress→gateway migration window so
phase-2 testers can hit the gateway directly while ingress still owns the main host.
*/}}
{{- define "ace.gateway.fqdn" -}}
{{- printf "ace.ace.%s" .Values.global.platform.host -}}
{{- end }}

{{/*
True iff both ingress and gateway are enabled — i.e. the chart is rendered for
ingress→gateway migration phase 2. Used to gate the inclusion of the gateway-native
FQDN in cert SANs and HTTPRoute hostnames; new gateway-only deployments and
ingress-only deployments do not need it.
*/}}
{{- define "ace.gateway.migrationActive" -}}
{{- and (index .Values "ingress-nginx" "enabled") (index .Values "gateway" "enabled") -}}
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

{{/*
The products this install runs: AKP (the default), TrustConsole, KubePatch or AKP_Plus (all three).
*/}}
{{- define "ace.productLine" -}}
{{- $pl := default "AKP" .Values.ProductLine -}}
{{- if not (has $pl (list "AKP" "TrustConsole" "KubePatch" "AKP_Plus")) -}}
{{- fail (printf "ProductLine must be AKP, TrustConsole, KubePatch or AKP_Plus, not %q" $pl) -}}
{{- end -}}
{{- $pl -}}
{{- end }}

{{/* "true" or nothing: dict "root" . "product" "AKP"|"TrustConsole"|"KubePatch". */}}
{{- define "ace.hasProduct" -}}
{{- $pl := include "ace.productLine" .root -}}
{{- if or (eq $pl .product) (eq $pl "AKP_Plus") }}true{{ end -}}
{{- end }}

{{/*
Whether the product line has a feature of ace's own templates: dict "root" . "name" <feature>.
Prints "true" or nothing. `disableFeatures` turns a feature off in any line (the ones that need an operator the cluster
does not have: db, cache, clusterBackup, caProviderClass). AKP and AKP_Plus have all of them; TrustConsole keeps the
database and the cache (its hub's Valkey is the Redis protocol), KubePatch the database.
*/}}
{{- define "ace.feature" -}}
{{- $pl := include "ace.productLine" .root -}}
{{- $line := dict "TrustConsole" (list "db" "cache") "KubePatch" (list "db") -}}
{{- if and (or (eq $pl "AKP") (eq $pl "AKP_Plus") (has .name (get $line $pl))) (not (has .name (default (list) .root.Values.disableFeatures))) -}}true{{- end -}}
{{- end }}

{{/*
The identity mode of AKP (b3's [iam] MODE): v1_only, dual or v2_only, or nothing when `global.akp.mode` is
unset (b3's own default, which is what ace has always run). The mode is read on AKP only: AKP_Plus is v2_only (one
Casdoor sign-in for every product), and TrustConsole and KubePatch do not run b3 web.
*/}}
{{- define "ace.akpMode" -}}
{{- $pl := include "ace.productLine" . -}}
{{- $mode := dig "akp" "mode" "" .Values.global -}}
{{- if and $mode (not (has $mode (list "v1_only" "dual" "v2_only"))) -}}
{{- fail (printf "global.akp.mode must be v1_only, dual or v2_only, not %q" $mode) -}}
{{- end -}}
{{- if eq $pl "AKP" -}}
{{- $mode -}}
{{- else if eq $pl "AKP_Plus" -}}
{{- if and $mode (ne $mode "v2_only") -}}
{{- fail (printf "ProductLine AKP_Plus runs AKP in v2_only, not global.akp.mode %s" $mode) -}}
{{- end -}}
v2_only
{{- else if $mode -}}
{{- fail (printf "global.akp.mode is for the AKP line; ProductLine %s does not run AKP" $pl) -}}
{{- end -}}
{{- end }}

{{/* trust.<global.platform.host>: the Trust Console's hub shares AKP's /api prefix, so it has a host of its own. */}}
{{- define "ace.trustConsoleHost" -}}
{{- printf "trust.%s" .Values.global.platform.host -}}
{{- end }}

{{- define "ace.casdoorHost" -}}
{{- printf "casdoor.%s" .Values.global.platform.host -}}
{{- end }}

{{/* Gateway listener ports of Casdoor and the Trust Console when global.platform.hostType is ip. */}}
{{- define "ace.casdoorPort" -}}8443{{- end }}
{{- define "ace.trustConsolePort" -}}9443{{- end }}

{{- define "ace.casdoorPublicUrl" -}}
{{- if eq .Values.global.platform.hostType "ip" -}}
{{- printf "https://%s:%s" .Values.global.platform.host (include "ace.casdoorPort" .) -}}
{{- else -}}
{{- printf "https://%s" (include "ace.casdoorHost" .) -}}
{{- end -}}
{{- end }}

{{- define "ace.trustConsolePublicUrl" -}}
{{- if eq .Values.global.platform.hostType "ip" -}}
{{- printf "https://%s:%s" .Values.global.platform.host (include "ace.trustConsolePort" .) -}}
{{- else -}}
{{- printf "https://%s" (include "ace.trustConsoleHost" .) -}}
{{- end -}}
{{- end }}

{{/*
parentRefs and hostnames of a route that needs a host of its own: dict "root" . "listener" <ip listener> "host" <domain host>.
On an IP, the route attaches to its own listener; on a domain, to https with its hostname.
*/}}
{{- define "ace.gateway.ownHost" -}}
parentRefs:
- group: gateway.networking.k8s.io
  kind: Gateway
  name: {{ include "ace.fullname" .root }}
  namespace: {{ .root.Release.Namespace }}
  {{- if eq .root.Values.global.platform.hostType "ip" }}
  sectionName: {{ .listener }}
  {{- else }}
  sectionName: https
hostnames:
- {{ .host }}
  {{- end }}
{{- end }}

{{/* TLS of an HTTPS listener of the ace Gateway. */}}
{{- define "ace.gateway.tls" -}}
tls:
  mode: Terminate
  certificateRefs:
  - group: ""
    kind: Secret
    name: {{ include "ace.fullname" . }}-gw-cert
    namespace: {{ .Release.Namespace }}
{{- $gwCert := lookup "v1" "Secret" .Release.Namespace (printf "%s-gw-cert" (include "ace.fullname" .)) }}
{{- $legacyCert := lookup "v1" "Secret" .Release.Namespace (printf "%s-ingress-cert" (include "ace.fullname" .)) }}
{{- /* The legacy cert is a non-renewing snapshot; serving it next to gw-cert breaks Envoy once it expires. */}}
{{- if and $legacyCert (not $gwCert) }}
  - group: ""
    kind: Secret
    name: {{ include "ace.fullname" . }}-ingress-cert
    namespace: {{ .Release.Namespace }}
{{- end }}
{{- end }}

{{/* postgres://user:pass@host/<settings.db.databaseName>: the database the console hubs share with b3. */}}
{{- define "ace.consoleDatabaseUrl" -}}
{{- $a := .Values.settings.db.auth -}}
{{- printf "postgres://%s:%s@%s/%s?sslmode=disable" (urlquery $a.username) (urlquery $a.password) (include "settings.database.host" .) .Values.settings.db.databaseName -}}
{{- end }}
