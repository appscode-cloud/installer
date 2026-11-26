# Product lines and AKP modes

This is the reference for how the `ace` chart decides which products an install runs and how people sign in to them.
The three demo documents (`docs/kubepatch.md`, `docs/trustconsole.md`, `docs/akp-v2-demo.md`) describe standalone demo
installs; this file describes the installer path.

## Terms

- **AKP**: the Kubernetes platform ace has always installed. Its backend is **b3** (the `platform-api` chart); its web
  frontends are platform-ui (`/id`) and cluster-ui (`/console`). "**b3 web**" below means b3's API server with those UIs.
- **iam**: the identity module embedded in b3 and in each console hub. It keeps its own `iam_*` tables and trusts an
  external identity provider.
- **Casdoor**: that identity provider (https://casdoor.org). People sign in on Casdoor's hosted pages; Casdoor redirects
  back to the product with a code. One Casdoor *organization* holds the users; each product is a Casdoor *application*
  with its own client id and secret.
- **Console**: the patch console (product KubePatch) or the Trust Console. Each console is two charts: a **hub** (the API
  server, `patch-console-api` / `trust-console-api`) and a UI (`patch-console-ui` / `trust-console-ui`).
- **Product line** (`ProductLine`): which products one install runs.
- **AKP mode**: b3's `[iam] MODE`, how people sign in to AKP: `v1_only` (b3's own accounts), `v2_only` (Casdoor only),
  `dual` (both).

## The install path

```
ace-options  ──>  lib-selfhost  ──>  ace HelmRelease values  ──>  charts/ace (+ sub-charts)
```

- **ace-options** is what a person chooses. Its Go type is `AceOptionsSpec`; the two inputs that matter here are
  `ProductLine` and `akp.mode` (`apis/installer/v1/ace_options_types.go:60`, `:62`, `:181`), plus `casdoor.enabled`
  (`:79`).
- **lib-selfhost** turns options into ace values. It lives outside this repository; what it writes is not verified here.
- **charts/ace** deploys what the line needs and refuses a values file that does not fit it
  (`charts/ace/templates/validate.yaml`). Go programs get the same rules from `apis/installer/v1.ProductLine`:
  `Components()`, `AkpMode()`, `NeedsCasdoor()` (`apis/installer/v1/console_types.go:60-78`).

Example: the options

```yaml
ProductLine: AKP
akp:
  mode: v2_only
```

become the ace values `ProductLine: AKP` and `global.akp.mode: v2_only` (`apis/installer/v1/ace_ace_types.go:56`, `:262`).

## Product lines

| `ProductLine` | Products | b3 web |
|---|---|---|
| `AKP` (default) | AKP | yes |
| `TrustConsole` | the Trust Console | no |
| `KubePatch` | the patch console | no |
| `AKP_Plus` | AKP, the Trust Console and the patch console, behind one Casdoor sign-in | yes |

Source: `charts/ace/templates/_helpers.tpl:312` (`ace.productLine`), `apis/installer/v1/console_types.go:46-58`.

TrustConsole and KubePatch do not run b3 web: ace refuses `platform-api`, `platform-ui` and `cluster-ui` there. For
example, `helm template ace charts/ace -f charts/ace/profiles/trustconsole.yaml --set platform-api.enabled=true` fails
with `ProductLine TrustConsole does not use platform-api: set platform-api.enabled to false`.

The console hubs are run from the `patch-console` and `trust-console` images today
(`charts/patch-console-api/values.yaml:16`, `charts/trust-console-api/values.yaml:17`). b3 is planned to gain
`b3 kubepatch` and `b3 trustconsole` subcommands that take their place (unverified: not in this repository).

## AKP modes

`global.akp.mode` (options: `akp.mode`) is read on lines that run AKP only (`charts/ace/templates/_helpers.tpl:343`):

| Line | Accepted `global.akp.mode` | Mode b3 runs |
|---|---|---|
| `AKP` | empty, `v1_only`, `dual`, `v2_only` | the one given |
| `AKP_Plus` | empty or `v2_only` | always `v2_only`: one Casdoor sign-in for every product |
| `TrustConsole`, `KubePatch` | empty only | none (no b3) |

What each mode changes on the AKP line:

| `global.akp.mode` | b3 `[iam]` section | Needs Casdoor | platform-ui / cluster-ui tag |
|---|---|---|---|
| empty (default) | not written: b3's own default | no | chart `appVersion` |
| `v1_only` | `MODE = v1_only` only | no | `v1OnlyImageTag` (the last UI release that speaks only AKP's v1 API) |
| `dual` | `MODE` and the `CASDOOR_*` settings | yes | chart `appVersion` |
| `v2_only` | `MODE` and the `CASDOOR_*` settings | yes | chart `appVersion` |

Sources: `charts/ace/templates/platform/config.yaml:119-141`, `charts/cluster-ui/templates/_helpers.tpl:90-98` (the
same helper is in platform-ui, kubedb-ui, accounts-ui, billing-ui). `image.tag` overrides the tag in every mode.

In `dual` and `v2_only`, ace requires `settings.iam.casdoor.endpoint`, `.organization` and `.clientSecret`
(`charts/ace/templates/validate.yaml:23-27`). `endpoint` has no default (`charts/ace/values.yaml:401`): with ace's own
Casdoor it is `http://<release>-casdoor.<namespace>.svc:8000`.

In `v2_only` ace also leaves out the setup Job (`charts/ace/templates/platform/setup-job.yaml:1`) and redirects `/` to
`/id/` (`charts/ace/templates/gateway/route-home.yaml:31`).

**`AKP_Plus` requires `global.akp.mode: v2_only` to be set.** ace does not fill it in, because the sub-charts read
`global.akp.mode` themselves: with it empty, b3's config would say `MODE = v2_only` while the platform-api chart kept its
`/api/v1/version` probes and v1 init containers (`charts/platform-api/templates/statefulset.yaml:206`,
`charts/platform-api/templates/_helpers.tpl:166`), which b3 does not serve in `v2_only`. An empty or other mode fails the
render (`charts/ace/templates/_helpers.tpl`, `ace.akpMode`).

## What each line enables

`validate.yaml` checks the sub-charts: a line **needs** some and **refuses** others (`charts/ace/templates/validate.yaml:11-22`).
`AKP` is not constrained, so the default render and `ace.sample.yaml` keep working.

| Sub-chart | AKP | TrustConsole | KubePatch | AKP_Plus |
|---|---|---|---|---|
| casdoor | optional | needed | needed | needed |
| openfga | optional | needed | refused | needed |
| platform-api, platform-ui, cluster-ui | optional | refused | refused | needed |
| kubedb-ui, grafana, perses, trickster, s3proxy, cadence, pgoutbox, outbox-syncer, platform-opscenter, postgres-alerts, redis-alerts | optional | refused | refused | optional |
| trust-console-api, trust-console-ui | optional | needed | refused | needed |
| patch-console-api, patch-console-ui | optional | refused | needed | needed |

ace's own templates are grouped in features (`ace.feature`, `charts/ace/templates/_helpers.tpl:332`):

| Feature | AKP, AKP_Plus | TrustConsole | KubePatch |
|---|---|---|---|
| `db` (KubeDB Postgres, Pgpool, init script) | yes | yes | yes |
| `cache` (KubeDB Redis) | yes | yes: the Trust Console hub's Valkey (same protocol) | no |
| `cleaner`, `clusterBackup`, `consoleImporter`, `grafanaConfig`, `cadence`, `setupJob` | yes | no | no |

`disableFeatures` turns a feature off on any line, for a cluster without the operator behind it. The setup Job is also
left out in `v2_only`, so `AKP_Plus` never runs it.

Casdoor and the consoles are routed on the Gateway only: with any of them on, ace requires `gateway.enabled`
(`charts/ace/templates/validate.yaml:33-35`). The AKP routes (`route-main`, `ingress-main`, the AKP
`BackendTrafficPolicy`) are rendered only on lines with AKP (`charts/ace/templates/gateway/route-main.yaml:1`).

Starting points: `charts/ace/profiles/kubepatch.yaml` and `charts/ace/profiles/trustconsole.yaml` (Casdoor and the
Gateway on, no platform-*). There is no `AKP_Plus` profile.

## Casdoor in ace

`charts/casdoor` is a sub-chart of ace (`casdoor.enabled`, `charts/ace/Chart.yaml:45`):

- **Database**: on ace's Postgres. ace's init script creates `casdoor.database.name` (default `casdoor`) when Casdoor is
  on (`charts/ace/templates/db/init-script.yaml:20-21`). The sub-chart cannot read ace's helpers, so
  `casdoor.database.host`/`port`/`password` are set as values; the profiles use ace's Pgpool, `ace-pgpool.ace.svc:9999`.
- **One organization** (`casdoor.organization`, `charts/casdoor/values.yaml:60-65`) holds every user; each product is an
  application in `casdoor.applications` (name, client id, client secret, redirect URIs). Each product's own Casdoor
  settings must name that organization (`settings.iam.casdoor.organization`, `trust-console-api.casdoor.organization`,
  `patch-console-api.casdoor.organization`); ace does not check that they agree.
- **Seeded once**: applications and users are written into an empty Casdoor database only (`initDataNewOnly`,
  `charts/casdoor/templates/secret.yaml:117`). Changing `casdoor.applications` later changes nothing in a running
  Casdoor.
- **Secrets as values**: `adminPassword`, the database password and the client secrets are values, set by the installer.
  The client secret of an application must equal the one its product is given (b3: `settings.iam.casdoor.clientSecret`;
  the hubs: keys `trust-casdoor-client-secret` / `patch-casdoor-client-secret` of the credentials Secret
  `global.credentials.secretName`).
- **External Casdoor** (AKP only): leave `casdoor.enabled` off and point `settings.iam.casdoor.*` at it. The lines with a
  console need ace's (`validate.yaml:13-15`).

Casdoor cannot be served under a path such as `https://<host>/casdoor`; upstream has no supported setting for it
(https://github.com/casdoor/casdoor/discussions/2941). So Casdoor gets a host of its own on a domain and a port of its
own on an IP (next sections).

## The consoles in ace

- **Database**: the hubs share b3's database (`settings.db.databaseName`, default `bb`). For each enabled hub, ace makes
  the Secret `<release>-<hub>-database` (e.g. `ace-patch-console-api-database`) with key `url`,
  `postgres://<user>:<password>@<db host>/<database>?sslmode=disable`, unless the hub's `database.secretName` is set
  (`charts/ace/templates/db/console-database.yaml`, `charts/ace/templates/_helpers.tpl:430`). With the `db` feature off,
  `database.secretName` is required (`validate.yaml:28-32`).
- **Credentials**: the credentials Secret (`global.credentials.secretName`) is made outside ace. Keys:
  `patch-iam-root-key`, `patch-casdoor-client-secret` (patch console); `trust-casdoor-client-secret`,
  `trust-iam-csrf-key` (Trust Console) (comments in `charts/ace/profiles/*.yaml`).

## Routing on a domain

With `global.platform.hostType: domain` and `global.platform.host: ace.example.com`:

| Product | URL | Why |
|---|---|---|
| AKP | `https://ace.example.com/` (`/id`, `/console`, `/api`, ...) | |
| patch console | `https://ace.example.com/patch/` | its UI's nginx serves `/patch` and proxies `/patch/api` to the hub |
| Trust Console | `https://trust.ace.example.com/trust/` | its hub's API prefix `/api` is AKP's too |
| Casdoor | `https://casdoor.ace.example.com/` | it cannot live under a path |

All are on the Gateway listener `https` (443). On `KubePatch`, `/` redirects to `/patch/`
(`charts/ace/templates/gateway/route-patch-console.yaml:20-32`); on every line with the Trust Console, `trust.<host>/`
redirects to `/trust/` (`charts/ace/templates/gateway/route-trust-console.yaml:14-24`).
Hosts: `charts/ace/templates/_helpers.tpl:362-368`.

**Certificate gap.** The Gateway serves `ace-gw-cert`, which `charts/service-gateway` issues
(values via service-gateway-presets → GatewayConfig → catalog-manager). On a domain that certificate has only the
platform host in `dnsNames` (`charts/service-gateway/templates/gateway-tls/certificate.yaml:34-45`), so
`casdoor.<host>` and `trust.<host>` get a certificate that does not match them. Adding those names is not done yet.
DNS for both names must also point at the Gateway.

## Routing on an IP

An IP has no subdomains, so on `global.platform.hostType: ip` Casdoor and the Trust Console each get an HTTPS listener of
their own on the ace Gateway, with the same certificate (`charts/ace/templates/gateway/gateway.yaml:19-32`). Its IP SAN
(`certificate.yaml:22-24`) matches on every port, because certificates are not tied to a port.

| | domain (`ace.example.com`) | IP (`10.2.0.9`) |
|---|---|---|
| AKP, patch console | `https://ace.example.com/`, `/patch/` | `https://10.2.0.9/`, `/patch/` |
| Casdoor | `https://casdoor.ace.example.com` | `https://10.2.0.9:8443` (listener `casdoor`) |
| Trust Console | `https://trust.ace.example.com` | `https://10.2.0.9:9443` (listener `trust-console`) |

Ports: `charts/ace/templates/_helpers.tpl:371-372`. Ports 8443 and 9443 must be reachable next to 443; Envoy Gateway
publishes each listener port on the Gateway's Service (unverified here).

The sub-charts cannot compute these URLs (their defaults are `casdoor.<host>` / `trust.<host>`), so on an IP ace refuses
a values file unless each is set to the value above (`charts/ace/templates/validate.yaml:36-57`):

```yaml
casdoor:
  publicUrl: https://10.2.0.9:8443
settings:
  iam:
    casdoor:
      publicUrl: https://10.2.0.9:8443   # AKP in dual / v2_only
trust-console-api:
  publicUrl: https://10.2.0.9:9443
  casdoor:
    publicUrl: https://10.2.0.9:8443
patch-console-api:
  casdoor:
    publicUrl: https://10.2.0.9:8443
```

Otherwise rendering fails with, e.g., `global.platform.hostType is ip: set casdoor.publicUrl to https://10.2.0.9:8443`.
The installer is to set them, along with the Casdoor redirect URIs.

Browsers do not isolate cookies by port (https://www.rfc-editor.org/rfc/rfc6265#section-8.5): products on different
ports of one IP must not use the same cookie name.

## Standalone demo charts

`charts/kubepatch`, `charts/trustconsole` and `charts/akp-prereqs`, with `hack/kubepatch`, `hack/trustconsole` and
`hack/akp-v2-demo`, are standalone demo installs, kept as they are. They are not the installer path:

- `docs/kubepatch.md`: the patch console next to AKP v2, without ace.
- `docs/trustconsole.md`: the Trust Console next to AKP v2, without ace.
- `docs/akp-v2-demo.md`: ace with `ProductLine: AKP` and `global.akp.mode: v2_only` on a bare k3s, with `akp-prereqs`
  standing in for KubeDB, cert-manager and lib-selfhost.

"AKP v2" in those documents means `ProductLine: AKP` with mode `v2_only`; it is not a product line.
