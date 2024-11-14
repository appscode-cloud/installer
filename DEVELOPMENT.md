# catalog

## Generate Image Catalog

Uses [image-packer](https://github.com/kmodules/image-packer)

```bash
image-packer list --root-dir=charts --output-dir=catalog

image-packer list-feature-charts --root-dir=charts --output-dir=catalog

image-packer list-editor-charts \
    --output-dir=catalog \
    --apiGroup=autoscaling.kubedb.com \
    --apiGroup=kubedb.com \
    --apiGroup=ops.kubedb.com \
    --apiGroup=addon.kubestash.com \
    --apiGroup=core.kubestash.com \
    --apiGroup=storage.kubestash.com \
    --apiGroup=charts.x-helm.dev

image-packer generate-scripts --insecure --allow-nondistributable-artifacts \
    --output-dir=catalog \
    --src=catalog/ace.yaml \
    --src=catalog/editor-charts.yaml \
    --src=catalog/feature-charts.yaml \
    --src=catalog/reusable-ui-charts.yaml

image-packer generate-gcp-script --allow-nondistributable-artifacts \
    --output-dir=catalog \
    --src=catalog/ace.yaml

make add-license fmt
```
