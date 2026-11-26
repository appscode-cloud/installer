# AKP v2 demo: the ace chart in `v2_only`, on a single-node k3s

This document describes a **standalone demo install** (PR #1432): `charts/ace/profiles/akp-v2-demo.yaml`,
`charts/akp-prereqs` and the scripts in `hack/akp-v2-demo/`. It is not the installer path, which is described in
`docs/product-line.md`; read that first for the terms used here (product line, AKP mode, b3, iam, Casdoor).

## What the demo is

"AKP v2" is not a product line: it is `ProductLine: AKP` with `global.akp.mode: v2_only`. b3 then runs
`[iam] MODE = v2_only`: **iam** (b3's embedded identity module) signs people in only on **Casdoor**'s hosted pages, and
platform-ui and cluster-ui are the frontends. Traffic goes through the Gateway of **Voyager Gateway** (Envoy Gateway
based, no Traefik), and NATS runs in **operator mode**. There is no Trust Console and no patch console.

Unlike the kubepatch and trustconsole demos, this one uses the `ace` chart itself, with the profile above. The demo
cluster is a bare k3s: no KubeDB, KubeStash, cert-manager or lib-selfhost, which ace normally relies on. The rest of
this document is about filling that gap.

## Design choice

| Piece | Where it comes from |
|---|---|
| b3 (`platform-api`), platform-ui, cluster-ui, Grafana, Perses, Cadence, NATS, the Gateway and its routes | the `ace` chart and its sub-charts, values in `charts/ace/profiles/akp-v2-demo.yaml` |
| Postgres 18, Casdoor (one organization, one application), the NATS operator/system/admin identities, the Gateway certificate | `charts/akp-prereqs` (a separate release, installed first, same namespace) |
| the credentials as ace values (database password, Casdoor client secret, KMS key, NATS identities, NATS server operator config) | `hack/akp-v2-demo/ace-values.sh`, a values file that is never printed (mode 0600) |
| Voyager Gateway (controller, GatewayClass `ace`, EnvoyProxy) | `hack/akp-v2-demo/install.sh gateway`; k3s keeps its own Gateway API CRDs |
| images | `hack/akp-v2-demo/load-images.sh` (b3, platform-ui, cluster-ui are built; Casdoor, Postgres, NATS are pulled) |

The profile turns off the ace features whose operators the cluster lacks: `disableFeatures: [db, cache, clusterBackup,
cleaner, consoleImporter]` (`charts/ace/profiles/akp-v2-demo.yaml:9`).

Why a separate `akp-prereqs` release and not a sub-chart of ace: ace takes the NATS identities and the Casdoor client
secret as **values** (`settings.nats.*`, `settings.iam.casdoor.clientSecret`, the NATS server's operator JWT), so they
must exist before ace is rendered; a sub-chart's hook Job runs after the render. On a cluster without KubeDB,
cert-manager and lib-selfhost, `akp-prereqs` makes the database, the certificate and those credentials.

ace now has a Casdoor sub-chart of its own (`charts/casdoor`, `docs/product-line.md`), added after this demo. The demo
does not use it: it keeps `casdoor.enabled` off and points `settings.iam.casdoor.endpoint` at akp-prereqs' Casdoor
(`http://akp-prereqs-casdoor.akp.svc:8000`, `charts/ace/profiles/akp-v2-demo.yaml:178`), which the AKP line allows. ace's
Casdoor would also need its database made by ace's init script, which is part of the `db` feature the demo turns off
(`charts/ace/templates/db/init-script.yaml:1`, `:20-21`). The profile still renders on the current chart (checked with
`helm template` and a client secret set).

## What #1432 added to ace

Default renders were unchanged by it: `helm template` of `charts/ace` with default values and with `ace.sample.yaml`
gave the same output before and after (checked at the time with the random secrets masked; not re-checked here).

ace chart:

- `disableFeatures` (list, default empty): leaves out ace's own templates by feature name (`db`, `cache`,
  `clusterBackup`, `cleaner`, `consoleImporter`, `grafanaConfig`, `cadence`, `setupJob`) in any product line. `db` is the
  KubeDB Postgres, Pgpool, archiver, backup and init-script templates.
- `settings.db.host`: a Postgres that is not ace's KubeDB one (host:port).
- `settings.iam.casdoor.publicUrl`: `[iam] CASDOOR_PUBLIC_URL`, Casdoor as the browser reaches it (the hosted sign-in
  redirect).
- Gateway routes: `<settings.iam.publicPath>` (`/iam`, iam's hosted `/casdoor/login` and `/casdoor/callback`) goes to b3
  in `dual` and `v2_only` (`charts/ace/templates/gateway/route-main.yaml:60`); in `v2_only` the home route redirects `/` to
  `/id/` (there is no `/accounts/selfhost-home`, `charts/ace/templates/gateway/route-home.yaml:31`).
- the setup Job is not rendered in `v2_only` (`charts/ace/templates/platform/setup-job.yaml:1`; the same steps are init
  containers of the API pod, see below), and the setup config leaves out `syncPersesAccounts` there (`b3 dev` would read
  `ac_user`).
- the Grafana config uses Grafana's own database for its remote cache and an in-memory session when the `cache` feature
  is off.

platform-api chart:

- `v2_only` (read from `global.akp.mode`): the probes are an exec `curl` of the Connect call
  `akp.branding.v2.BrandingService/GetBranding` (b3 serves neither `/healthz` nor `/api/v1/version` there), and the init
  containers are b3's order for a fresh install: `b3 migrate`, `b3 dev --setup-config` (records the NATS accounts),
  `b3 admin iam-bootstrap-admin` (the first site administrator) (`charts/platform-api/templates/statefulset.yaml:206`,
  `charts/platform-api/templates/_helpers.tpl:166`).
- `iam.bootstrapAdmin.*`, `settings.secretName.setupConfig`, `extraInitContainers` (runs before the chart's own).

Go types for the new values are in `apis/installer/v1`; schemas and READMEs are regenerated by `make gen`.

## Run it

On a build host (docker, an ssh agent that can read the private repositories) build and import the images; on the k3s
host install. The demo host is `akp.10.2.0.73.nip.io` (Casdoor at `casdoor.akp.10.2.0.73.nip.io`): nip.io resolves both
names to 10.2.0.73, so no hosts-file step is needed (check with `getent hosts akp.10.2.0.73.nip.io`).

Cookies: iam's hosted sign-in sets `akp_iam_session` (HttpOnly, Secure, SameSite=Lax) and `_csrf` (Secure,
SameSite=Lax) **host-only**, which any browser accepts. b3's v1 session middleware also sets `i_like_ace` and `lang` with
`Domain=nip.io` (it derives the cookie domain from the host, no setting); headless Chromium 1.65 kept them, and v2_only
does not use them. If a browser rejects them the sign-in is unaffected. A name under a domain of your own avoids the
question.

```sh
# build host
TARGET=ubuntu@10.2.0.73 hack/akp-v2-demo/load-images.sh all
# k3s host, from a checkout (or a copy of charts/ and hack/akp-v2-demo/)
hack/akp-v2-demo/install.sh all          # gateway, prereqs, ace
```

`HOST=<name> hack/akp-v2-demo/install.sh ...` uses another name; then change it in `charts/ace/profiles/akp-v2-demo.yaml`
and `hack/akp-v2-demo/prereqs-values.yaml` too (the Casdoor URL and the sign-in URL are in the profile).
By IP: `curl -k -H 'Host: akp.10.2.0.73.nip.io' https://10.2.0.73/...`.

The first site administrator is `admin`; its password is in Secret `akp-prereqs-credentials` (key `admin-password`) and
is the password of the Casdoor user `admin`. Other Secrets: `akp-prereqs-nats-creds` (the NATS identities),
`ace-gw-cert`.

Order in a fresh install matters in one place: Grafana and Perses create their tables in b3's database (`org`, `user`,
`perses_users`, ...), and b3 writes the first administrator to them **only if they exist** (in `v2_only` nothing syncs
them later: `b3 dev --sync-grafana-users` reads `ac_user`). The platform-api pod therefore waits for those tables
(`extraInitContainers` in the profile) before `iam-bootstrap-admin`. Without it, `CreateOrganization` fails with
`pq: relation "org" does not exist` (Grafana not started yet) or `user does not exist [... name: admin ...]`
(administrator made before Grafana). This explains the `org does not exist` of the Trust Console demo
(`docs/trustconsole.md`): it is not the site organization step (`b3 dev` in `v2_only` makes none).

## Findings (what does not work, or is not b3's yet)

Found with the images built by `hack/akp-v2-demo/load-images.sh`; whether later releases fix them is unverified.

- Changing the host of a running install: delete Secret `ace-gw-cert` (the certificate is made once, for the host),
  upgrade both releases with the new host, and restart the pods. The Casdoor application is seeded only into an empty
  Casdoor database (`initDataNewOnly`; ace's `charts/casdoor` behaves the same): to change its redirect URI, recreate that
  database; then delete the old link (`delete from iam_identity where account_id = '1'`) or sign-in is refused with "the
  account is linked to another Casdoor user".
- **CSRF cookie name.** iam's hosted sign-in sets `iam_csrf`; platform-ui, cluster-ui and ui-modules (`akp-v2-iam`) read
  `_csrf` for `X-Csrf-Token`. After a completed sign-in every AKP v2 call answers `missing or invalid CSRF token` and the
  UI loops back to sign-in. The demo b3 image carries a one-line patch (`hack/akp-v2-demo/b3-csrf-cookie.patch`,
  `CSRFCookie: "_csrf"`, tag suffix `-csrf`); the right fix is in b3 or the UIs, not here.
- `b3 dev --sync-grafana-users` and the cluster-import task read `ac_user`, which `v2_only` does not have:
  **ImportCluster registers the cluster (provider Generic, with a kubeconfig; endpoint, version, nodes are read) but its
  install task fails** with `pq: relation "ac_user" does not exist`. ValidateImport and CreateOrganization work. Import
  also needs Cadence and `components.fluxCd: true`.
- UIs call `GET /api/v1/user/settings/pagination`, which `v2_only` does not serve (404, harmless).
- `[storage] BUCKET_URL` is still `gs://ace-data` (ace's default); b3 logs it and keeps going.
- Adding Grafana by `helm upgrade` to an existing release: ace writes `skip_migrations = true` on upgrade, so Grafana
  does not make its tables. Install it from the start (as `install.sh` does).
- A change of `[iam]` or `[cadence]` in the config Secret does not restart b3: `kubectl delete pod <release>-platform-api-0`.
- `charts/akp-prereqs`: one Postgres pod, a self-signed certificate, generated credentials. Not for production.

These findings are about AKP in `v2_only`, so they apply to the installer's `AKP` line in `v2_only` and to `AKP_Plus` as
well, not to `TrustConsole` or `KubePatch` (no b3 web there).

## Teardown

`hack/akp-v2-demo/teardown.sh --yes` on the k3s host (without `--yes` it prints what it would remove). It removes both
releases, the PVCs, the Secrets Helm does not own, Voyager Gateway and its cluster-scoped objects, and the imported
images. k3s' Gateway API CRDs stay.
