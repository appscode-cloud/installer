# catalog

## Generate Image Catalog

Uses [image-packer](https://github.com/kmodules/image-packer)

```bash
# image-packer list --root-dir=charts --output-dir=catalog

image-packer list-feature-charts --root-dir=charts --output-dir=catalog

image-packer list-editor-charts --apiGroup=kubedb.com --apiGroup=core.kubestash.com --output-dir=catalog

image-packer generate-scripts --output-dir=catalog \
    --src=catalog/ace.yaml \
    --src=catalog/editor-charts.yaml \
    --src=catalog/feature-charts.yaml \
    --src=catalog/reusable-ui-charts.yaml
```
