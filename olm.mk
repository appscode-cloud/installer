IMAGE_TAG_BASE ?= ghcr.io/appscode/akp-installer
BUNDLE_VERSION ?= $(shell yq -r '.version | ltrimstr("v")' charts/akp-installer/Chart.yaml)
IMG ?= $(IMAGE_TAG_BASE):v$(BUNDLE_VERSION)
BUNDLE_IMG ?= $(IMAGE_TAG_BASE)-bundle:v$(BUNDLE_VERSION)
CHANNELS ?= $(if $(findstring -,$(BUNDLE_VERSION)),candidate,stable)
DEFAULT_CHANNEL ?= $(firstword $(subst $(comma), ,$(CHANNELS)))
comma := ,
CONTAINER_TOOL ?= docker
OPERATOR_SDK ?= operator-sdk
KUSTOMIZE ?= kustomize
IMAGE_PACKER ?= image-packer
BUNDLE_CSV ?= bundle/manifests/akp-installer.clusterserviceversion.yaml
PREV_VERSION ?=

.PHONY: bundle
bundle: gen-crds
	@command -v $(OPERATOR_SDK) >/dev/null
	@command -v $(KUSTOMIZE) >/dev/null
	IMG="$(IMG)" $(KUSTOMIZE) build config/manifests | IMG="$(IMG)" yq -y --explicit-start \
		'if .kind == "Deployment" then (.spec.template.spec.containers[] | select(.name == "manager") | .image) = env.IMG elif .kind == "ClusterServiceVersion" then .metadata.annotations.containerImage = env.IMG else . end' | \
		$(OPERATOR_SDK) generate bundle --overwrite --version "$(BUNDLE_VERSION)" --channels "$(CHANNELS)" --default-channel "$(DEFAULT_CHANNEL)"
	$(OPERATOR_SDK) bundle validate ./bundle
	$(OPERATOR_SDK) bundle validate ./bundle --select-optional name=operatorhubv2
	$(OPERATOR_SDK) bundle validate ./bundle --select-optional name=capabilities
	$(OPERATOR_SDK) bundle validate ./bundle --select-optional name=categories
	$(OPERATOR_SDK) bundle validate ./bundle --select-optional name=good-practices

.PHONY: bundle-replace-image-digest
bundle-replace-image-digest:
	$(IMAGE_PACKER) replace-image-digest "$(BUNDLE_CSV)" "$(BUNDLE_CSV)"
	PREV_VERSION="$(PREV_VERSION)" yq -y --indentless -i \
		'.spec.relatedImages = ([.metadata.annotations.containerImage, (.spec.install.spec.deployments[]?.spec.template.spec | (.containers[]?, .initContainers[]?) | .image)] | map(select(type == "string" and length > 0)) | unique | to_entries | map({name: ("image-" + (.key | tostring)), image: .value})) | if env.PREV_VERSION != "" then .spec.replaces = ("akp-installer." + (if env.PREV_VERSION | startswith("v") then env.PREV_VERSION else "v" + env.PREV_VERSION end)) else . end' "$(BUNDLE_CSV)"
	$(OPERATOR_SDK) bundle validate ./bundle

.PHONY: operator-build
operator-build:
	helm dependency build charts/akp-installer
	$(CONTAINER_TOOL) build -f Dockerfile --build-arg VERSION="$(BUNDLE_VERSION)" -t "$(IMG)" .

.PHONY: operator-push
operator-push:
	$(CONTAINER_TOOL) push "$(IMG)"

.PHONY: docker-buildx
PLATFORMS ?= linux/arm64,linux/amd64
docker-buildx:
	$(CONTAINER_TOOL) buildx create --name akp-installer-builder --use
	$(CONTAINER_TOOL) buildx build --push --platform="$(PLATFORMS)" --build-arg VERSION="$(BUNDLE_VERSION)" --tag "$(IMG)" -f Dockerfile .
	$(CONTAINER_TOOL) buildx rm akp-installer-builder

.PHONY: docker-certify-redhat
docker-certify-redhat:
	@preflight check container "$(IMG)" \
		--submit \
		--certification-component-id=6aee958cf9f0d46f5a1fe8ff

.PHONY: bundle-build
bundle-build:
	$(CONTAINER_TOOL) build -f bundle.Dockerfile -t "$(BUNDLE_IMG)" .

.PHONY: bundle-push
bundle-push:
	$(CONTAINER_TOOL) push "$(BUNDLE_IMG)"
