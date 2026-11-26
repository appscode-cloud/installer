# Product lines and AKP modes

Two independent inputs, in ace-options and in the ace values:

- `ProductLine`: which products the install runs: `AKP` (default), `TrustConsole`, `KubePatch`, or `AKP_Plus` (all
  three behind one Casdoor sign-in).
- `akp.mode` (options) / `global.akp.mode` (ace values): how people sign in to AKP. Read on the AKP line only.

The installer (lib-selfhost) turns options into ace values; the ace chart deploys what the line needs and refuses a
values file that does not fit it (`templates/validate.yaml`). `apis/installer/v1.ProductLine` has the same rules for Go
programs: `Components()`, `AkpMode()`, `NeedsCasdoor()`.

## AKP modes

b3's `[iam] MODE` is `v1_only`, `dual` or `v2_only`.

| `akp.mode` | b3 `[iam]` | Casdoor | UI images |
|---|---|---|---|
| empty (default) | not written, b3's default | – | the chart's tag (today's render, byte for byte) |
| `v1_only` | `MODE = v1_only` | – | `v1OnlyImageTag` (ace v2026.10.30's UIs, AKP v1 API only) |
| `dual` | full `[iam]` section | ✓ | `appVersion` |
| `v2_only` | full `[iam]` section | ✓ | `appVersion` |

A UI chart picks its tag as `image.tag`, else `v1OnlyImageTag` when the mode is `v1_only`, else `appVersion`.

On `AKP_Plus` the mode is always `v2_only`; any other value is refused. On `TrustConsole` and `KubePatch` b3 web does not
run and setting a mode is refused.

## Components per line

| component | AKP | TrustConsole | KubePatch | AKP_Plus |
|---|---|---|---|---|
| db (KubeDB Postgres + Pgpool) | ✓ | ✓ | ✓ | ✓ |
| gateway | ✓ | ✓ | ✓ | ✓ |
| casdoor | `dual`/`v2_only`, or an external one | ✓ | ✓ | ✓ |
| platform-api, platform-ui, cluster-ui | ✓ | – | – | ✓ |
| kubedb-ui, grafana, perses, trickster, s3proxy, cadence, pgoutbox, outbox-syncer, platform-opscenter, *-alerts | ✓ | – | – | ✓ |
| cache (Redis) | ✓ | ✓ (the hub's Valkey) | – | ✓ |
| openfga | ✓ | ✓ | – | ✓ |
| trust-console-api, trust-console-ui | – | ✓ | – | ✓ |
| patch-console-api, patch-console-ui | – | – | ✓ | ✓ |
| cleaner, cluster backup, console importer, Grafana config, setup job | ✓ | – | – | ✓ |

ace's own templates follow `ace.feature` (templates/_helpers.tpl); `disableFeatures` turns a feature off on any line.
The AKP line itself is not constrained, so the default render and `ace.sample.yaml` keep working.

## Casdoor

`charts/casdoor` is a sub-chart of ace (`casdoor.enabled`). It runs on ace's Postgres (database `casdoor.database.name`,
created by the init script) and is served at `casdoor.<global.platform.host>` (it cannot live under a path). It takes
its passwords, client secrets and applications as values, set by the installer. The applications and users are seeded
into an empty Casdoor database only. On AKP, an external Casdoor works too: set `settings.iam.casdoor.*` and leave
`casdoor.enabled` off.

## The consoles

- The hubs share b3's database (`settings.db.databaseName`): ace makes `<release>-<hub>-database` with the URL unless
  the hub's `database.secretName` is set.
- The patch console is served at `/patch` on the platform host. On KubePatch, `/` redirects to `/patch/`.
- The Trust Console has its own host, `trust.<global.platform.host>`, because its hub's `/api` prefix is AKP's too.
- Casdoor and the consoles are routed on the Gateway only (`gateway.enabled`).

## IP installs

An IP has no subdomains, so on `global.platform.hostType: ip` Casdoor and the Trust Console each get an HTTPS listener of
their own on the ace Gateway, with the same certificate (its IP SAN covers every port):

| | domain | IP |
|---|---|---|
| Casdoor | `https://casdoor.<host>` | `https://<ip>:8443` |
| Trust Console | `https://trust.<host>` | `https://<ip>:9443` |

Envoy Gateway adds the listener ports to its LoadBalancer Service, so 8443 and 9443 must be open next to 443. The sub-charts
cannot compute these URLs, so on an IP ace refuses a values file unless they are set: `casdoor.publicUrl`,
`settings.iam.casdoor.publicUrl` (AKP in dual/v2_only), `trust-console-api.publicUrl`, `trust-console-api.casdoor.publicUrl`
and `patch-console-api.casdoor.publicUrl`. The installer sets them, along with the Casdoor redirect URIs.

Browsers share cookies across the ports of one IP: products on different ports must not use the same cookie name.

## Standalone charts

`charts/kubepatch`, `charts/trustconsole` and `charts/akp-prereqs` (with `hack/kubepatch`, `hack/trustconsole`,
`hack/akp-v2-demo`) stay as standalone demo installs. They are not part of the installer path.
