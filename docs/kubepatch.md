# Kubepatch

Kubepatch is the patch console (hub and UI) and AKP v2 (b3 running `[iam] MODE = v2_only`, with platform-ui and
cluster-ui), served from **one host**. One Casdoor, with one application per product, signs people in. NATS runs in
operator mode, as b3 needs it. The chart is `charts/kubepatch`; it does not depend on the `ace` chart (no KubeDB,
OpenFGA, Redis, Cadence or setup job).

## Layout

| Path on the host | Served by |
|---|---|
| `/patch` (and `/patch/api`, which the console's nginx proxies to the hub) | patch console UI |
| `/api`, `/accounts`, `/iam` (only with federation or SCIM) | b3 |
| `/console` | cluster-ui |
| `/id` | platform-ui |
| `/nats` | NATS WebSocket (placeholder route: the UIs do not use it yet) |
| `/` | redirect to `routing.rootRedirect` (`/id/`) |
| `casdoor.<host>` | Casdoor (its own host: Casdoor cannot live under a path) |

`routing.mode` is `gateway` (Gateway API: one Gateway, one HTTPRoute per host; the default), `ingress` (one Ingress)
or `none`. Postgres 18 (databases `akp`, `patchconsole`, `casdoor`), NATS with JetStream, Casdoor, b3, the patch console
and the two UIs are in the chart. `postgres.external.enabled` points at your own Postgres instead.

## b3 start-up order (`docs/iam-modes.md`, "A fresh install in v2_only" in b3)

The b3 pod runs init containers in this order, then `b3 api`:

1. `b3 migrate`: the product tables.
2. `b3 dev --setup-config`: records the NATS operator, system and admin accounts (the creds are in Secret
   `<release>-nats-creds`) and their streams. In v2_only it must stop there.
3. `b3 admin iam-bootstrap-admin --name <admin>`: the first site administrator, who needs the NATS account of step 2. iam
   links the account to the Casdoor user of the same name at the first sign-in (`CASDOOR_ADOPT_BY_NAME`).

## NATS in operator mode

A hook Job (`<release>-nats-keys`, image `natsio/nats-box`) makes the operator, the system account `SYS` with user `sys`
and the account `ADMIN` with user `admin` with `nsc`, once, and writes two Secrets through the API: `<release>-nats-creds`
(`Operator.creds`, `SYS.creds`, `sys.creds`, `ADMIN.creds`, `admin.creds`, the JWTs) and `<release>-nats-server`
(`nats.conf` with the operator JWT, the system account and a full account resolver on the PVC). The seeds are in no value,
no template and no log. The Secrets are not Helm's, so they outlive the release: `hack/kubepatch/teardown.sh` removes
them. NATS has a WebSocket listener (8080, TLS ends at the gateway) in the Service, and `/nats` routes to it.

## Install

```sh
helm dependency update charts/kubepatch
helm install kubepatch charts/kubepatch -n kubepatch --create-namespace \
  -f charts/kubepatch/profiles/k3s-test.yaml
```

`global.platform.host` is the one public name (a DNS name, not an address). The chart makes a self-signed certificate
for it and for `casdoor.<host>`. Every secret is generated once (`lookup`, kept on uninstall) unless
`credentials.existingSecret` names yours. Production: `profiles/production.yaml` (`production: true` refuses generated
credentials, a self-signed certificate, the chart's Postgres and images without a digest).

## The k3s demo (`profiles/k3s-test.yaml`)

1. Gateway: `helm install voyager-gateway oci://ghcr.io/appscode-charts/voyager-gateway --version v2026.10.10 -n
   voyager-gateway-system --create-namespace -f <values>` with the controller name `gateway.voyagermesh.com/ace`,
   `crd-manager.featureGates.GatewayOfficial=false` and `updateExistingCRDs=false` (k3s owns the Gateway API CRDs), then
   `kubectl apply -f hack/kubepatch/gateway.yaml` (an EnvoyProxy and the GatewayClass `ace`: without `parametersRef` the
   Voyager infrastructure runner panics). ServiceLB publishes the Gateway's Service on 80 and 443.
2. Images: `hack/kubepatch/load-images.sh all` on a build host (docker, buildx, an ssh agent that can read the private
   repositories) builds b3, the patch console and the two UIs, pulls the rest, saves a tarball and imports it with
   `sudo k3s ctr images import` over ssh (`TARGET=ubuntu@host`), then names each image by digest too, so the profile's
   digest pins resolve. Nothing is pushed.
3. `helm install` as above. Browse `https://kubepatch.10.2.0.5.nip.io/id/` (a self-signed certificate; the nip.io names
   resolve to the host, or put both names in `/etc/hosts`).
4. Everything the demo created is listed in `hack/kubepatch/teardown.sh` (`--yes` removes it).

## Findings of the demo (what does not work yet)

- **platform-ui and cluster-ui 3.1.0 do not work with b3 v2_only**: they call `GET /api/v1/user`, `/api/v1/branding`,
  `/api/v1/user/settings/*`, which v2_only does not mount (404), and land on `/id/404`. platform-ui `feat/iam-ui`
  (6e9d41b92c) and cluster-ui `feat/akp-v2-client` (eae279409c) call the v2 API and load once signed in; the profile uses
  them.
- **No UI can sign in to AKP in v2_only.** The sign-in form of platform-ui sends the browser to `/accounts/user/login`,
  which v2_only does not serve (it answers `302 /id/404`). Signing in works at the API: `POST /api/v1/user/signin` (the
  external-console contract route) with `{"username","password"}` sets the iam session cookies, and with them `/id/`
  (Overview) and `/console/` (Kubernetes) load. `iam.identity.v1.SignInService/Password` answers a session id and a CSRF
  token in the body and sets no cookie.
- b3 sets its cookies with `Domain=nip.io` for a `*.nip.io` host (the last two labels); nip.io is on the public suffix list.
- b3 serves neither `/healthz` nor `/api/v1/version` in v2_only: the probes are `exec curl` of the Connect call
  `akp.branding.v2.BrandingService/GetBranding`.
- `b3 dev` creates the first user and organization through `ac_user` (fails in v2_only), and `b3 admin
  iam-bootstrap-admin` leaves the KMS keeper unregistered, so with NATS on it cannot open the NATS admin connection. The
  demo image carries two small patches (`hack/kubepatch/b3-dev.patch`); both belong in b3's `fix-v2-only-cold-boot`.
- The AKP cluster directory of the patch console needs an iam token with a scope and an organization (none yet: `b3 dev` was
  to make the site organization). The hub runs with the `table` directory.
- The console (`patch-console` sign-in through Casdoor, with the application's redirect URI) works in a browser.

## Choices

- **Not ace.** In v2_only none of KubeDB, Redis, Cadence, OpenFGA or the setup job is needed. Cadence is not run
  (`b3.worker.enabled` is off): `b3 worker` workflows do not run.
- **b3 is templated here**, not taken from `charts/platform-api` (that chart probes `/api/v1/version`).
- **One Casdoor, one organization, two applications**; the second-factor rule is an organization setting.
- The patch console is templated here (not a sub-chart) so `global.platform.host` is the only place the address is
  written; its hub does not join the operator-mode NATS (agents report over HTTPS).

## Uninstall

`hack/kubepatch/teardown.sh --yes` on the host.
