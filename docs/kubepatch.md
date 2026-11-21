# Kubepatch

Kubepatch is the patch console (hub and UI) and AKP v2 (b3 running `[iam] MODE = v2_only`, with platform-ui and
cluster-ui), served from **one host**. One Casdoor, with one application per product, signs people in. The
chart is `charts/kubepatch`. It does not depend on the `ace` chart (no KubeDB, OpenFGA, Redis, Cadence or setup job).

## Layout

| Path on the host | Served by |
|---|---|
| `/patch` (and `/patch/api`, which the console's nginx proxies to the hub) | patch console UI |
| `/api`, `/accounts`, `/iam` (only with federation or SCIM) | b3 |
| `/console` | cluster-ui |
| `/id` | platform-ui |
| `/` | redirect to `routing.rootRedirect` (`/id/`) |
| `casdoor.<host>` | Casdoor (its own host: Casdoor cannot live under a path) |

`routing.mode` is `gateway` (Gateway API: one Gateway, one HTTPRoute per host; the default), `ingress` (one Ingress)
or `none`. Postgres 18 (databases `akp`, `patchconsole`, `casdoor`), NATS with JetStream, Casdoor, b3, the patch console
and the two UIs are in the chart. `postgres.external.enabled` points at your own Postgres instead.

## Install

```sh
helm dependency update charts/kubepatch      # copies platform-ui and cluster-ui in
helm install kubepatch charts/kubepatch -n kubepatch --create-namespace \
  -f charts/kubepatch/profiles/k3s-test.yaml --set global.platform.host=<ip>.nip.io
```

`global.platform.host` is the one public name (a DNS name, not an address; `<ip>.nip.io` works for a test). The chart
makes a self-signed certificate for it and for `casdoor.<host>`. Every secret is generated once (`lookup`, kept on
uninstall) unless `credentials.existingSecret` names yours; the keys are listed in `values.yaml`.

Production: `profiles/production.yaml` (`production: true` refuses generated credentials, a self-signed certificate,
the chart's Postgres and any image without a digest; the sub-chart images are pinned as `<tag>@sha256:<digest>`).

## Test on a single-node k3s

1. The Gateway API CRDs and a Gateway controller (Envoy Gateway / Voyager Gateway) with a GatewayClass named
   `routing.gateway.className` (`ace`). For a throwaway cluster in Docker, `hack/kubepatch/k3s-in-docker.sh up`.
2. Images: b3 and the patch console are not published. Build them and import into k3s with
   `hack/kubepatch/load-images.sh` (`build`, `pull`, `save`, `import`; set `TARGET=user@host` or `DOCKER_K3S=<name>`).
   Nothing is pushed anywhere and no registry credential is used.
3. `helm install` with `profiles/k3s-test.yaml` as above. Open `https://<host>/id/`, `https://<host>/patch/`.

## First administrator

Casdoor seeds the organization (`casdoor.organization`), the two applications and the user `casdoor.admin.username`;
its password is the key `admin-password` of the credentials Secret. Two post-install Jobs link that user to an
administrator in each product: for AKP, an `iam_account` (site administrator, id from `akp_account_id_seq`) with an
`iam_identity` row for the Casdoor user; for the console, `patch-console iam bootstrap --org`.

The console reads AKP's clusters with an iam API token: sign in to AKP as the administrator, make a token, put it in a
Secret (`kubectl create secret generic <name> --from-literal=token=...`) and set `patchConsole.akp.tokenSecret`.

## Choices

- **Not ace.** ace brings KubeDB Postgres and Redis, Cadence, OpenFGA and a setup job. In `v2_only` none of them is needed.
- **Redis is not run.** b3's `[session]` and `[cache]` are `memory`, right for one replica; set `b3.session` and
  `b3.cache` to Redis for more.
- **Cadence is not run.** `b3 worker` (and so `b3.worker.enabled`) runs Cadence workflows; without it those workflows
  (cluster operations dispatched by the API) do not run. Point `b3.cadence.host` at a Cadence to turn it on.
- **b3 is templated here**, not taken from `charts/platform-api`: that chart probes `/api/v1/version`, which v2_only does not mount (probes use `/healthz`).
- **One Casdoor, one organization, two applications.** Users are shared. Second factors (`casdoor.mfa.rule`) are an
  organization setting, so both applications follow it; separate rules per product need a second organization. Step-up needs
  Casdoor `ghcr.io/appscode/casdoor:v4.29.0-3391e5fe`.
- **Console routes**: `/patch` goes to the console's nginx, which proxies `/patch/api` to the hub. This needs the console
  of the `shared-host` change (API under `/patch/api`; before it the UI calls `/api`, which is AKP's).
- The patch console's own Helm chart is not a dependency: its pieces are templated here so `global.platform.host` is the
  only place the address is written. The delta from `charts/patch-console` of patch-console master: no
  NetworkPolicy, ServiceMonitor, Ingress/HTTPRoute (the umbrella routes), the migration runs as an init container of the hub.

## Known gaps

- **b3 on `connectgrpc` does not start on an empty database in `v2_only`** (commit 09233644f9): `InitOrgAuthSources` and
  `MigrateOrgTypeForOrganizations` read identity tables (`org_auth_source`, `ac_user`) that v2_only never creates.
- **b3 needs NATS in operator mode**: `b3 api` waits for an admin NATS connection made from an operator, system and admin
  account that `b3 dev` (the ace setup job) creates. This chart runs plain NATS with JetStream; operator-mode NATS and the
  setup step are not done.
- b3 refuses to start without an inbox server address; none runs, b3 logs that it does not answer.
- b3 logs `[kms] MASTER_KEY_URL` at start.
- Platform settings edited in b3's UI are written back as Secrets (`ace-user-config`, `ace-system-config`): not supported, all settings are in app.ini.
- `npm ci` of the console UI image fails on the alpine base (rolldown's musl binding is skipped); `load-images.sh` builds it on a glibc node.
- The images of b3, patch-console and patch-console-ui are not in `catalog/imagelist.yaml`: they are unpublished (the catalog test needs multi-arch published images); Casdoor is amd64 only.

## Uninstall

```sh
helm uninstall kubepatch -n kubepatch
kubectl -n kubepatch delete pvc --all                  # Postgres, NATS and b3 data
kubectl -n kubepatch delete secret kubepatch-credentials kubepatch-tls   # kept by helm.sh/resource-policy
```
