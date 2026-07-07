# Catalog Notes

## Files

Chart/image lists (inputs, consumed by `update-catalog.sh` and `cve-report.yml`):

- `imagelist.yaml` — master list of application images.
- `ace.yaml` — Just 3 core chart (ace-installer, ace, service-gateway).
- `feature-charts.yaml` — Feature charts, used on cluster-ui feature pages.
- `editor-charts.yaml` — Editor charts, used on kubedb-ui pages.
- `reusable-ui-charts.yaml` — shared UI component charts, helpers for editor-charts.yaml file.

Operational scripts (move/import chart images between registries):

- `export-images.sh` — pulls chart images from `ghcr.io/appscode-charts/*`, saves as local `.tar` files.
- `import-images.sh` — extracts a tarball and `crane push`es each `.tar` into `$IMAGE_REGISTRY`.
- `copy-images.sh` — direct `crane cp` from `ghcr.io/appscode-charts/*` to `$IMAGE_REGISTRY` (no tarball step).
- `import-into-k3s.sh` — extracts a tarball and `k3s ctr images import`s each `.tar` into local k3s containerd.
- `sync-gcp-mp-images.sh` — `crane cp`s the 3 core ACE images into `$IMAGE_REGISTRY:$TAG` for GCP Marketplace sync.

## Which script to use

| Scenario | Script(s) |
|---|---|
| Mirror images to your own registry, direct network path | `copy-images.sh` |
| Air-gapped: move images via tarball | `export-images.sh` then `import-images.sh` |
| Air-gapped k3s cluster specifically | `export-images.sh` then `import-into-k3s.sh` |
| GCP Marketplace listing sync | `sync-gcp-mp-images.sh` |
