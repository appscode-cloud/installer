[![Twitter](https://img.shields.io/twitter/follow/appscodehq.svg?style=social&logo=twitter&label=Follow)](https://twitter.com/intent/follow?screen_name=AppsCodeHQ)

# ACE installer

ACE Helm charts

## Generate Image Catalog

[image-packer](https://github.com/kmodules/image-packer)

```bash
image-packer list --root-dir=charts --output-dir=catalog

image-packer list-feature-charts --output-dir=/tmp
image-packer list-feature-charts --root-dir=charts --output-dir=catalog

image-packer list-editor-charts --apiGroup=kubedb.com --apiGroup=core.kubestash.com --output-dir=catalog
```

## Support

To speak with us, please leave a message on [our website](https://appscode.com/contact/).

To receive product annoucements, follow us on [Twitter](https://twitter.com/AppsCodeHQ).
