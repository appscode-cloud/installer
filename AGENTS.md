# AGENTS.md

This file provides guidance to coding agents (e.g. Claude Code, claude.ai/code) when working with code in this repository.

## Repository purpose

Go module `go.bytebuilders.dev/installer` — the **umbrella Helm chart repo** for the AppsCode Container Engine (ACE) platform. Bundles every ACE component (acaas, ace, ace-installer, accounts-ui, acerproxy, aceshifter, billing, billing-ui, …) plus all the surrounding install bundles. Also exposes a Go API package describing chart values for downstream programs.

Sibling pattern to `kubeops.dev/installer`, `kubevault.dev/installer`, etc. — but covering the full ACE catalog rather than a single product family.

## Architecture

- `charts/` — one subdirectory per Helm chart. Standard layout (`Chart.yaml`, `values.yaml`, `templates/`, generated `doc.yaml` / `README.md` / `values.openapiv3_schema.yaml`).
- `apis/installer/v1alpha1/` — Go types backing chart values. Used for OpenAPI / values-schema generation and as a typed surface for downstream programs.
- `catalog/` — image catalog driven by `kmodules.xyz/image-packer`.
- `cmd/`, `pkg/` — codegen + installer helpers.
- `hack/scripts/` — release / codegen scripts (`update-catalog.sh`, `update-chart-dependencies.sh`, `import-crds.sh`, `ct.sh`, etc.).
- `options.yaml`, `features.md`, `DEVELOPMENT.md` — feature catalog + dev guide.
- `tests/`, `lintconf.yaml` — chart-testing setup.
- `vendor/` — checked-in Go deps.

## Common commands

- `make gen` — full regen (clientset + manifests + values schemas + chart docs). Run after `apis/installer/v1alpha1/*_types.go` changes.
- `make manifests` — CRDs / values schemas / chart docs.
- `make gen-values-schema` — regenerate `values.openapiv3_schema.yaml`.
- `make gen-chart-doc` — per-chart `README.md`.
- `make update-charts` — refresh chart metadata.
- `make fmt`, `make lint`, `make unit-tests` / `make test` — standard.
- `make ct` — chart-testing.
- `make verify` — module-tidy verification.
- `make add-license` / `make check-license` — manage license headers.

Helpers (invoked outside Make):

- `./hack/scripts/update-catalog.sh` — regenerate `catalog/` from `imagelist.yaml`.
- `./hack/scripts/import-crds.sh` — pull CRDs from sibling repos into chart `crds/` dirs.

## Conventions

- Module path is `go.bytebuilders.dev/installer` (vanity URL); imports must use that.
- Edit `apis/installer/v1alpha1/*_types.go` to change a chart's values surface, then run `make gen` so the generated clientset, `values.openapiv3_schema.yaml`, and per-chart `README.md` stay in sync.
- Do not hand-edit `zz_generated.*.go`, chart `README.md` files, `values.openapiv3_schema.yaml`, or anything under `catalog/` except `imagelist.yaml`.
- License: `LICENSE.md`. Sign off commits (`git commit -s`).
- Vendor directory is checked in; keep `go mod tidy && go mod vendor` clean.
- CRDs for charts are imported via `import-crds.sh`; don't hand-author `charts/*/crds/*.yaml`.
- `-certified` charts mirror the standard charts for Red Hat certification — bumps must apply to both.
- Adding a new chart: create `charts/<name>/`, add a values-schema Go type under `apis/installer/v1alpha1/`, list images in `imagelist.yaml`, then run `make gen`.
