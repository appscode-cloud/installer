# Trust Console

The `trustconsole` chart installs the Trust Console (hub and UI) next to AKP v2 (b3 running `[iam] MODE = v2_only`, with
platform-ui and cluster-ui). It is a sibling of the `kubepatch` chart and is built on it: the Postgres, the NATS in operator
mode, the Casdoor, the b3 StatefulSet with its init containers, the credentials and the self-signed certificate are the same
templates under the name `trustconsole`. It does not depend on the `ace` chart (no KubeDB, Redis, Cadence or setup job).

PostgreSQL 18 or newer is what this is run and documented against; the chart does not check the version.

## Layout

One Casdoor with one organization and an application per product (`akp`, `trust-console`) signs people in. Each product
embeds iam and keeps its own `iam_*` tables in its own database (`akp`, `trustconsole`), so an account exists once per
product, linked to the same Casdoor subject.

| Host | Path | Served by |
|---|---|---|
| `<host>` | `/id`, `/console` | platform-ui, cluster-ui |
| `<host>` | `/api`, `/accounts` (and `/iam` with federation or SCIM) | b3 |
| `<host>` | `/nats` | NATS WebSocket (placeholder) |
| `trust.<host>` | `/trust` | Trust Console UI |
| `trust.<host>` | `/api` | Trust Console hub (the prefix is stripped; `WatchPosture` has its own stream rule) |
| `casdoor.<host>` | `/` | Casdoor |

The Trust Console has its own host because the hub's API prefix `/api` is AKP's too. Routing is Gateway API (Voyager Gateway,
GatewayClass `ace`); no Traefik. `routing.mode=ingress` and `none` are as in kubepatch.

## What the hub needs

| Dependency | In the chart | If missing |
|---|---|---|
| Postgres | database `trustconsole` in the chart's Postgres (or yours) | the hub does not start |
| Casdoor | the chart's, application `trust-console` | the hub does not start |
| OpenFGA | `openfga` (Deployment, database `openfga`) | the hub does not start |
| Valkey | `valkey` (Deployment, no volume) | the hub does not start |
| iam keys | `trust-iam-csrf-key` in the credentials Secret | the hub does not start |
| NATS | not wired: the hub opens NATS without credentials and b3's NATS is in operator mode | signal ingest is off |
| Cadence, object storage | not run | workflows and evidence bundles that need them are off |

The console's first administrator is the Casdoor user `casdoor.admin.username` (`CONSOLE_BOOTSTRAP_ADMINS`); the same user is
AKP's first site administrator (`b3 admin iam-bootstrap-admin`). Both products see the same Casdoor subject.

## Install

```sh
helm dependency update charts/trustconsole
helm install trustconsole charts/trustconsole -n trustconsole --create-namespace -f charts/trustconsole/profiles/k3s-test.yaml
```

`global.platform.host` is the AKP host; the console is at `trust.<host>` and Casdoor at `casdoor.<host>` unless
`trustConsole.host` and `casdoor.host` say otherwise. The self-signed certificate covers all three names.
`profiles/production.yaml` refuses generated credentials, a self-signed certificate, the chart's Postgres and images without
a digest.

## The k3s demo (`profiles/k3s-test.yaml`)

It runs next to the kubepatch release on the same k3s (10.2.0.5, namespace `trustconsole`) and touches nothing of it.

- The kubepatch Gateway holds port 443 of the node. This release has a Gateway of its own whose listener is on 8443
  (`routing.gateway.listenerPort`) while every public URL stays on 443 (`routing.httpsPort`). platform-ui and cluster-ui build
  their API addresses without a port, so they cannot be used on 8443: a browser must reach the Gateway as `:443`. For a test,
  Chrome's `--host-resolver-rules="MAP *.appscode.test 10.2.0.5:8443"` or `curl --connect-to host:443:10.2.0.5:8443` do it; a
  load balancer or a DNAT does it for people.
- Names: put `trustconsole.appscode.test`, `trust.trustconsole.appscode.test` and `casdoor.trustconsole.appscode.test` on the
  node in `/etc/hosts`. Not nip.io: b3 sets its cookies on the last two labels of the host and nip.io is a public suffix.
- Images: b3, platform-ui and cluster-ui are the ones the kubepatch demo imported (`kubepatch-a3c72f5a32-dev2`,
  `kubepatch-6e9d41b92c`, `kubepatch-eae279409c`). The Trust Console images are built from trust-console
  `design/platform-and-akp-console` by `hack/trustconsole/build-images.sh` and imported with `k3s ctr`; OpenFGA and Valkey
  are pulled by `k3s ctr images pull`.
- `hack/trustconsole/teardown.sh --yes` on the node removes what the demo made.

## Known gaps

- **No cluster in AKP.** In v2_only on b3 `a3c72f5a32` an organization cannot be made: `akp.org.v2.OrganizationService/
  CreateOrganization` fails with `relation "org" does not exist` (the `org` and `ac_user` tables are not created in v2_only),
  and `ValidateImport` with `org does not exist`. So no cluster can be imported into AKP v2, and the console's cluster list
  (`ClusterService`, a name, a role and a region) is not linked to AKP clusters: the hub has no AKP client yet
  (`design/iam-and-akp-console.md` section 6). Once b3 can make an organization, import the cluster in AKP (a read-only
  ServiceAccount kubeconfig is enough to validate it) and declare the same name in the console.
- **No shared iam session.** The hub embeds iam with its own tables, so the session cookies (`trust-console-session`,
  `akp_iam_session`) are separate. What is shared is the Casdoor session and the Casdoor subject: signing in at one product
  and then the other does not ask for the password again. A shared session needs the hub in iam service mode, which the hub
  does not have.
- **AKP's sign-in form does not work in v2_only** (kubepatch's finding): `POST /api/v1/user/signin` is the way in; platform-ui
  and cluster-ui load with that session.
- platform-ui and cluster-ui build API URLs without the port: see the demo above.
- The two UIs and b3 are the kubepatch demo's local builds, not released images.

## Structure

The hub and the UI are not rendered by this chart: it depends on the `trust-console-api` and `trust-console-ui` charts (see `docs/product-line.md`), which the ace chart can enable too. This chart keeps what they need around them (Postgres, NATS in operator mode, Casdoor, the Gateway, the Secrets and the first-administrator jobs). Values that were `trustConsole.*` are now `trust-console-api.*` and `trust-console-ui.*`; the settings the sub-charts share with this chart (`global.platform.host`, `global.platform.httpsPort`, `global.credentials.secretName`, the Casdoor organization and application) are checked against each other in `templates/validate.yaml`.
