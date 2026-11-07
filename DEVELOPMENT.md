# catalog

## Generate Image Catalog

Uses [image-packer](https://github.com/kmodules/image-packer)

```bash
./hack/scripts/update-catalog.sh
```

## Installer charts

Edit `charts/akp-installer` as the source chart. `make update-legacy-chart`
regenerates `charts/ace-installer` as a compatibility copy with the old chart
name; do not edit the copy directly. Existing releases can continue using it.
Switching a release to the AKP chart can change names and labels derived from
the chart name, so assess the rendered manifests before migrating.

Run `make update-certified-charts` to regenerate the AKP certified and CRD-only
charts. Run `make gen` after changing the installer API or its chart values.

## AKP OLM bundle

The bundle uses `installer.akp.appscode.com/v1alpha1`, kind `AkpInstaller`,
and reconciles the AKP chart with a Helm operator. The cluster must already
have the Flux source-controller and helm-controller CRDs and controllers, and
the `ClusterChartPreset` CRD (available in `akp-installer-certified-crds`).
The chart still relies on Flux to reconcile its HelmReleases.

With Docker, Helm, kustomize, yq, and operator-sdk installed:

```bash
make operator-build
make bundle
make bundle-build
```

`BUNDLE_VERSION` defaults to the AKP chart version without the `v` prefix.
Override `IMG`, `BUNDLE_IMG`, `BUNDLE_VERSION`, `CHANNELS`, and
`DEFAULT_CHANNEL` as needed. Publish the operator image referenced by `IMG`
before deploying the bundle; `make operator-push` and `make bundle-push`
publish the respective images. `make bundle` regenerates the CRD and validates
the bundle, but does not deploy or test reconciliation on a cluster.
After the operator image has been pushed, `make bundle-replace-image-digest
PREV_VERSION=v2026.1.1` resolves the CSV image references to digests, populates
`relatedImages`, and optionally sets the previous CSV to replace. Run it before
`make bundle-build` when an image-digest bundle is required.

The example custom resource is in `config/samples/installer_v1alpha1_akpinstaller.yaml`.
Its omitted optional values are supplied by the Helm chart. The operator needs
cluster-wide permissions to manage the chart's cluster-scoped resources and
the precheck hook's RBAC.

The API group rename creates new Kubernetes resource types. Existing resources
in the former group are not converted automatically and must be migrated
before the old CRDs are removed.
