# nats BackendTLSPolicy hostname — open question

Context for a later session. Working tree change in question:

```diff
--- a/charts/ace/templates/gateway/route-nats.yaml
+++ b/charts/ace/templates/gateway/route-nats.yaml
@@ -68,7 +68,7 @@ spec:
   {{ if eq (index .Values "global" "platform" "hostType") "ip" }}
     hostname: {{ include "ace.fullname" . }}-nats
   {{- else }}
-    hostname: {{ printf "ace.ace.%s" .Values.global.platform.host }}
+    hostname: {{ printf "%s" .Values.global.platform.host }}
   {{- end }}
```

## The two uses of `ace.ace.<host>` are different things

`ace.ace.<host>` appears in two unrelated roles. The migration gate applies to one, not the other.

1. **HTTPRoute `hostnames`** — `route-main.yaml:22-24`, `route-home.yaml:22-23`,
   `route-nats.yaml:22-24`. Client-facing hostnames the route accepts. Gating on
   `ace.gateway.migrationActive` is correct: it is an extra hostname phase-2 testers
   use while ingress still owns the main host.

2. **BackendTLSPolicy `hostname`** — `route-nats.yaml:71`. The SNI / verification name
   the gateway uses when *dialing the nats backend over TLS*. It must match a SAN on the
   cert nats serves. Nothing to do with migration state.

So the answer to "is `ace.ace` only needed when migration is active?" is **no** for case 2.

## Where `ace.ace.<host>` comes from

It is `gateway.domain` from the service-gateway chart, not an arbitrary prefix:

- `charts/service-gateway/templates/gateway-tls/certificate.yaml:31-35` — in
  `hostType: domain`, `<tenant>-gw-cert`'s only `dnsNames` entry and its `commonName`
  are `include "gateway.domain"`.
- `charts/service-gateway/templates/_helpers.tpl:64-72` — `gateway.domain` is:
  - `infra.host` when `gatewayClass.annotations.mode == "hosted"`;
  - otherwise `<clusterMetadata.name>.<Release.Namespace minus "-gw">.<infra.host>`
    → literally `ace.ace.<host>` for the ace namespace on a cluster named `ace`.

Confirmed by history: commit `42e7df1e` ("Fix cert for nats", #1248) changed this
hostname from plain host to `ace.ace.%s` **in the same commit** that rewrote that
certificate's SANs.

## Consequence of the working-tree change

`hostname: {{ .Values.global.platform.host }}` is correct **only in hosted mode**.
In self-hosted / non-hosted mode the served cert has only `ace.ace.<host>` as a SAN, so
backend TLS verification fails (SAN mismatch) — unless something outside this repo
re-points nats' serving cert.

## Unverified / caveats

- **Which secret nats actually mounts as its serving cert is not verifiable in this
  repo.** nats TLS is "configured in lib-selfhost" (comment near `charts/ace/values.yaml`
  nats section), which lives outside this module. The conclusion above assumes nats
  serves `ace-gw-cert`. [inferred] — verify in lib-selfhost before acting.
- `ace.ace.` hardcodes `clusterMetadata.name == "ace"`. If the hub cluster is named
  anything else, `gateway.domain` differs and **both** the old and the new value are
  wrong. The ace chart has no `clusterMetadata` value, so it cannot derive this today.
- The BackendTLSPolicy block renders whenever `gateway.enabled`, regardless of issuer.
  With `letsencrypt`, `caCertificateRefs` is the ISRG root (`gateway/acme-ca.yaml`), but
  the cert is still requested for `gateway.domain` — so the expected SAN is unchanged.
- Stale comment: the `ace.gateway.fqdn` helper doc
  (`charts/ace/templates/_helpers.tpl:218-222`) says the FQDN gates "cert SANs and
  HTTPRoute hostnames", but `charts/ace/templates/ingress/certificate.yaml` never
  includes it. The cert-SAN half of that comment is wrong.

## Candidate fix (not applied)

If hosted deployments are the target, make it conditional instead of unconditional:

```gotemplate
{{- if eq .Values.global.platform.deploymentType "Hosted" }}
    hostname: {{ .Values.global.platform.host }}
{{- else }}
    hostname: {{ include "ace.gateway.fqdn" . }}
{{- end }}
```

Note this assumes `global.platform.deploymentType == "Hosted"` corresponds to
service-gateway's `gatewayClass.annotations.mode == "hosted"`. **That correlation is not
verified** — check it before applying.

## Next steps

1. Confirm in lib-selfhost which secret the nats server serves in gateway mode.
2. Confirm `deploymentType: Hosted` ⇔ gatewayClass `mode: hosted`.
3. Then either apply the conditional above, or plumb `clusterMetadata.name` into the ace
   chart and derive the FQDN properly as `<cluster>.<ns>.<host>`.
