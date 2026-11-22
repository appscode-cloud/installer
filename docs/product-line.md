# Product lines and AKP modes

ace is installed as one of three product lines, chosen with the top-level value `ProductLine` (the key is written with a
capital `P`, as the owner asked; the schema generator takes the Go json tag as it is):

| `ProductLine`  | What it is | AKP mode | Sub-charts of ace it needs | Own templates of ace it keeps |
|----------------|------------|----------|----------------------------|-------------------------------|
| `AKP` (default) | everything ace installs today | `global.akp.mode` (empty, `v1_only`, `dual`, `v2_only`) | none | all |
| `TrustConsole` | iam + AKP v2 + the Trust Console | always `v2_only` | `platform-ui`, `cluster-ui`, `platform-api`, `openfga`, `trust-console-api`, `trust-console-ui` | the cache (Redis; the hub's Valkey is the same protocol), the database, the gateway |
| `KubePatch`    | iam + AKP v2 + the patch console | always `v2_only` | `platform-ui`, `cluster-ui`, `platform-api`, `patch-console-api`, `patch-console-ui` | the database, the gateway |

Helm cannot compute whether a sub-chart is enabled from a sibling value, so the line works at three levels:

1. ace's own templates ask `ace.feature` (templates/_helpers.tpl): the Redis cache, Cadence's database secret and schema job,
   the cleaner, the cluster backup, the console importer, the Grafana config and the setup job are rendered only on the lines
   that use them. On `AKP` all of them are, so the default render is unchanged (checked with `helm template`, see below). Where the cache is off, b3's
   `[session]` and `[cache]` are `memory`, as in the kubepatch and trustconsole charts.
2. `profiles/kubepatch.yaml` and `profiles/trustconsole.yaml` set the sub-charts the line needs (and turn off `cadence`,
   `postgres-alerts` and `redis-alerts`, which are on in values.yaml).
3. `templates/validate.yaml` refuses a values file that does not fit the line (a needed sub-chart disabled, an AKP-only one
   enabled, a console hub without its `database.secretName`, `dual`/`v2_only` without Casdoor settings). The AKP line is not constrained.

`apis/installer/v1.ProductLine.Components()` has the same sets for Go programs; lib-selfhost uses it.

## AKP modes and the UI images

b3's `[iam] MODE` is `v1_only`, `dual` or `v2_only`. The ace chart did not express it before: `global.akp.mode` does now.

- empty (the default): nothing is written, b3 keeps its own default, the UIs keep the chart's tag. Today's render, byte for byte.
- `v1_only`: `[iam] MODE = v1_only`; platform-ui, cluster-ui, kubedb-ui, billing-ui and accounts-ui run the last release of
  ace v2026.10.30 (`v1OnlyImageTag` of each UI chart: 2.5.0, and v2026.10.30 for accounts-ui), which speak only AKP's v1 API.
- `dual` and `v2_only`: the full `[iam]` section is written (`settings.iam.casdoor`, required) and the UIs use the chart's
  `appVersion`, the new UI release. People sign in only on the hosted pages of Casdoor (iam).

A UI chart picks its tag as `image.tag`, else `v1OnlyImageTag` when `global.akp.mode` is `v1_only`, else `appVersion`.
The new UI releases that speak AKP v2 are being made elsewhere: until their `appVersion` is bumped in these charts, `dual`
and `v2_only` get the current 3.1.0, which calls the v1 API (platform-ui and cluster-ui builds of `feat/iam-ui` and
`feat/akp-v2-client` are what the k3s demos run, through `image.tag`).

## The console charts

`patch-console-api`, `patch-console-ui`, `trust-console-api` and `trust-console-ui` are ordinary charts (`registryFQDN`,
`image.{registry,repository,tag,digest}`), dependencies of ace (disabled by default) and of the `kubepatch` and `trustconsole`
charts. They read `global.platform.host`, `global.platform.httpsPort` and `global.credentials.secretName` and take every secret
as an existing Secret.

The `kubepatch` and `trustconsole` charts stay as the standalone installs (they also run Postgres, NATS in operator mode,
Casdoor, the Gateway and the first-administrator jobs, which ace does not have). They no longer render the hub and the UI
themselves: they depend on the console charts, so the two installs run the same templates. Their k3s test flows
(`profiles/k3s-test.yaml`, `hack/kubepatch`, `hack/trustconsole`) are unchanged except for the value names:
`patchConsole.{image,ui,hub,akp,blobStore}` is now `patch-console-api.*` / `patch-console-ui.*`, `trustConsole.*` is
`trust-console-api.*` / `trust-console-ui.*`, Services are `<release>-patch-console-api` and so on, the Casdoor Service is
`<release>-casdoor`, and the hub's database Secret is `<release>-patch-console-api-database`.

## What ace does not do yet

ace does not run Casdoor, create the hubs' databases or Secrets, or run NATS in operator mode: with a product line you bring
Casdoor (`settings.iam.casdoor`), the Postgres 18+ databases (`database.secretName`), and the credentials Secret. Postgres 18+ is
documented, not enforced. Use the `kubepatch` or `trustconsole` chart when you want those run for you.
