
SHELL=/bin/bash -o pipefail

GO_PKG   := go.bytebuilders.dev
REPO     := $(notdir $(shell pwd))
BIN      := installer

# Produce CRDs that work back to Kubernetes 1.11 (no version conversion)
CRD_OPTIONS          ?= "crd:maxDescLen=0,generateEmbeddedObjectMeta=true,allowDangerousTypes=true"
# https://github.com/appscodelabs/gengo-builder
CODE_GENERATOR_IMAGE ?= ghcr.io/appscode/gengo:release-1.29
API_GROUPS           ?= installer:v1alpha1

# This version-strategy uses git tags to set the version string
git_branch       := $(shell git rev-parse --abbrev-ref HEAD)
git_tag          := $(shell git describe --exact-match --abbrev=0 2>/dev/null || echo "")
commit_hash      := $(shell git rev-parse --verify HEAD)
commit_timestamp := $(shell date --date="@$$(git show -s --format=%ct)" --utc +%FT%T)

VERSION          := $(shell git describe --tags --always --dirty)
version_strategy := commit_hash
ifdef git_tag
	VERSION := $(git_tag)
	version_strategy := tag
else
	ifeq (,$(findstring $(git_branch),master HEAD))
		ifneq (,$(patsubst release-%,,$(git_branch)))
			VERSION := $(git_branch)
			version_strategy := branch
		endif
	endif
endif

###
### These variables should not need tweaking.
###

SRC_PKGS := apis cmd schema tests # directories which hold app source (not vendored)
SRC_DIRS := $(SRC_PKGS)

DOCKER_PLATFORMS := linux/amd64 linux/arm linux/arm64
BIN_PLATFORMS    := $(DOCKER_PLATFORMS)

# Used internally.  Users should pass GOOS and/or GOARCH.
OS   := $(if $(GOOS),$(GOOS),$(shell go env GOOS))
ARCH := $(if $(GOARCH),$(GOARCH),$(shell go env GOARCH))

BASEIMAGE_PROD   ?= gcr.io/distroless/static-debian11
BASEIMAGE_DBG    ?= debian:bullseye

GO_VERSION       ?= 1.22
BUILD_IMAGE      ?= ghcr.io/appscode/golang-dev:$(GO_VERSION)
CHART_TEST_IMAGE ?= quay.io/helmpack/chart-testing:v3.5.1

OUTBIN = bin/$(OS)_$(ARCH)/$(BIN)
ifeq ($(OS),windows)
  OUTBIN = bin/$(OS)_$(ARCH)/$(BIN).exe
endif

# Directories that we need created to build/test.
BUILD_DIRS  := bin/$(OS)_$(ARCH)     \
               .go/bin/$(OS)_$(ARCH) \
               .go/cache             \
               hack/config           \
               $(HOME)/.credentials  \
               $(HOME)/.kube         \
               $(HOME)/.minikube

DOCKER_REPO_ROOT := /go/src/$(GO_PKG)/$(REPO)

# If you want to build all binaries, see the 'all-build' rule.
# If you want to build all containers, see the 'all-container' rule.
# If you want to build AND push all containers, see the 'all-push' rule.
all: fmt build

# For the following OS/ARCH expansions, we transform OS/ARCH into OS_ARCH
# because make pattern rules don't match with embedded '/' characters.

build-%:
	@$(MAKE) build                        \
	    --no-print-directory              \
	    GOOS=$(firstword $(subst _, ,$*)) \
	    GOARCH=$(lastword $(subst _, ,$*))

all-build: $(addprefix build-, $(subst /,_, $(BIN_PLATFORMS)))

version: version-PROD version-DBG
	@echo IMAGE=$(IMAGE)
	@echo BIN=$(BIN)
	@echo version=$(VERSION)
	@echo version_strategy=$(version_strategy)
	@echo git_tag=$(git_tag)
	@echo git_branch=$(git_branch)
	@echo commit_hash=$(commit_hash)
	@echo commit_timestamp=$(commit_timestamp)
version-%:
	@echo TAG_$*=$(TAG_$*)

.PHONY: codegen
codegen:
	@echo "Generating deepcopy funcs"
	@docker run --rm \
		-u $$(id -u):$$(id -g) \
		-v /tmp:/.cache \
		-v $$(pwd):$(DOCKER_REPO_ROOT) \
		-w $(DOCKER_REPO_ROOT) \
	    --env HTTP_PROXY=$(HTTP_PROXY) \
	    --env HTTPS_PROXY=$(HTTPS_PROXY) \
		$(CODE_GENERATOR_IMAGE) \
		controller-gen \
			object:headerFile="./hack/license/go.txt" paths="./apis/..."

# Generate openapi schema
.PHONY: openapi
openapi: $(addprefix openapi-, $(subst :,_, $(API_GROUPS)))
	@echo "Generating api/openapi-spec/swagger.json"
	@docker run --rm	                                 \
		-u $$(id -u):$$(id -g)                           \
		-v /tmp:/.cache                                  \
		-v $$(pwd):$(DOCKER_REPO_ROOT)                   \
		-w $(DOCKER_REPO_ROOT)                           \
		--env HTTP_PROXY=$(HTTP_PROXY)                   \
		--env HTTPS_PROXY=$(HTTPS_PROXY)                 \
		--env GOFLAGS="-mod=vendor"                      \
		$(BUILD_IMAGE)                                   \
		go run hack/gencrd/main.go

openapi-%:
	@echo "Generating openapi schema for $(subst _,/,$*)"
	@docker run --rm	                                 \
		-u $$(id -u):$$(id -g)                           \
		-v /tmp:/.cache                                  \
		-v $$(pwd):$(DOCKER_REPO_ROOT)                   \
		-w $(DOCKER_REPO_ROOT)                           \
		--env HTTP_PROXY=$(HTTP_PROXY)                   \
		--env HTTPS_PROXY=$(HTTPS_PROXY)                 \
		$(CODE_GENERATOR_IMAGE)                          \
		openapi-gen                                      \
			--v 1 --logtostderr                          \
			--go-header-file "./hack/license/go.txt" \
			--input-dirs "$(GO_PKG)/$(REPO)/apis/$(subst _,/,$*),k8s.io/apimachinery/pkg/apis/meta/v1,k8s.io/apimachinery/pkg/api/resource,k8s.io/apimachinery/pkg/runtime,k8s.io/apimachinery/pkg/util/intstr,k8s.io/apimachinery/pkg/version,k8s.io/api/core/v1,k8s.io/api/apps/v1,k8s.io/api/rbac/v1" \
			--output-package "$(GO_PKG)/$(REPO)/apis/$(subst _,/,$*)" \
			--report-filename /tmp/violation_exceptions.list

# Generate CRD manifests
.PHONY: gen-crds
gen-crds:
	@echo "Generating CRD manifests"
	@docker run --rm	                    \
		-u $$(id -u):$$(id -g)              \
		-v /tmp:/.cache                     \
		-v $$(pwd):$(DOCKER_REPO_ROOT)      \
		-w $(DOCKER_REPO_ROOT)              \
	    --env HTTP_PROXY=$(HTTP_PROXY)      \
	    --env HTTPS_PROXY=$(HTTPS_PROXY)    \
		$(CODE_GENERATOR_IMAGE)             \
		controller-gen                      \
			$(CRD_OPTIONS)                  \
			paths="./apis/..."              \
			output:crd:artifacts:config=.crds

.PHONY: patch-schema
patch-schema:
	@# https://github.com/kislyuk/yq
	@yq -s '.[0] * .[1]' ./schema/ace-options/values.openapiv3_schema.yaml ./schema/ace-options/patch.yaml -y > ./schema/ace-options/final.yaml
	@mv ./schema/ace-options/final.yaml ./schema/ace-options/values.openapiv3_schema.yaml

.PHONY: gen-values-schema
gen-values-schema: $(BUILD_DIRS)
	@for dir in charts/*/; do \
		dir=$${dir%*/}; \
		dir=$${dir##*/}; \
		crd_file=.crds/installer.bytebuilders.dev_$$(echo $$dir | tr -d '-')s.yaml; \
		if [ ! -f $${crd_file} ]; then \
			continue; \
		fi; \
		yq -y --indentless '.spec.versions[0].schema.openAPIV3Schema.properties.spec | del(.description)' $${crd_file} > charts/$${dir}/values.openapiv3_schema.yaml; \
	done

.PHONY: gen-external-schema
gen-external-schema: $(BUILD_DIRS)
	@$(MAKE) gen-crds --no-print-directory CRD_OPTIONS=crd:generateEmbeddedObjectMeta=true,allowDangerousTypes=true
	@for dir in schema/*/; do \
		dir=$${dir%*/}; \
		dir=$${dir##*/}; \
		crd_file=.crds/installer.bytebuilders.dev_$$(echo $$dir | tr -d '-')s.yaml; \
		if [ ! -f $${crd_file} ]; then \
			continue; \
		fi; \
		yq -y --indentless '.spec.versions[0].schema.openAPIV3Schema.properties.spec | del(.description)' $${crd_file} > schema/$${dir}/values.openapiv3_schema.yaml; \
	done

.PHONY: gen-schema
gen-schema: gen-values-schema gen-external-schema

.PHONY: gen-chart-doc
gen-chart-doc: $(shell find $$(pwd)/charts -maxdepth 1 -mindepth 1 -type d -printf 'gen-chart-doc-%f ')

gen-chart-doc-%:
	@echo "Generate $* chart docs"
	@docker run --rm 	                                 \
		-u $$(id -u):$$(id -g)                           \
		-v /tmp:/.cache                                  \
		-v $$(pwd):$(DOCKER_REPO_ROOT)                   \
		-w $(DOCKER_REPO_ROOT)                           \
		--env HTTP_PROXY=$(HTTP_PROXY)                   \
		--env HTTPS_PROXY=$(HTTPS_PROXY)                 \
		$(BUILD_IMAGE)                                   \
		chart-doc-gen -d ./charts/$*/doc.yaml -v ./charts/$*/values.yaml > ./charts/$*/README.md

.PHONY: manifests
manifests: gen-crds gen-schema patch-schema gen-chart-doc

.PHONY: gen
gen: codegen manifests

CHART_REGISTRY     ?= appscode
CHART_REGISTRY_URL ?= https://charts.appscode.com/stable/
CHART_VERSION      ?=
APP_VERSION        ?= $(CHART_VERSION)

.PHONY: update-charts
update-charts: $(shell find $$(pwd)/charts -maxdepth 1 -mindepth 1 -type d -printf 'chart-%f ')

chart-%:
	@$(MAKE) contents-$* gen-chart-doc-$* --no-print-directory

contents-%:
	@yq -y --indentless -i '.repository.name="$(CHART_REGISTRY)"' ./charts/$*/doc.yaml
	@yq -y --indentless -i '.repository.url="$(CHART_REGISTRY_URL)"' ./charts/$*/doc.yaml
	@if [ -n "$(CHART_VERSION)" ]; then \
	  yq -y --indentless -i '.version="$(CHART_VERSION)"' ./charts/$*/Chart.yaml; \
	  yq -y --indentless -i '.dependencies |= map(select(.name == "$*").version="$(CHART_VERSION)")' ./charts/ace/Chart.yaml; \
	  yq -y --indentless -i '.dependencies |= map(select(.name == "$*").version="$(CHART_VERSION)")' ./charts/opscenter-features/Chart.yaml; \
	fi
	@if [ -n "$(APP_VERSION)" ]; then \
		yq -y --indentless -i '.appVersion="$(APP_VERSION)"' ./charts/$*/Chart.yaml; \
	fi

.PHONY: update-local-repo
update-local-repo:
	GIT_BRANCH=$(git_branch) ./hack/scripts/update-local-repo.sh

fmt: $(BUILD_DIRS)
	@docker run                                                 \
	    -i                                                      \
	    --rm                                                    \
	    -u $$(id -u):$$(id -g)                                  \
	    -v $$(pwd):/src                                         \
	    -w /src                                                 \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin                \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin/$(OS)_$(ARCH)  \
	    -v $$(pwd)/.go/cache:/.cache                            \
	    --env HTTP_PROXY=$(HTTP_PROXY)                          \
	    --env HTTPS_PROXY=$(HTTPS_PROXY)                        \
	    $(BUILD_IMAGE)                                          \
	    /bin/bash -c "                                          \
	        set -eou pipefail;                                  \
	        go run cmd/generate-feature-graph/main.go;          \
	        REPO_PKG=$(GO_PKG)                                  \
	        ./hack/fmt.sh $(SRC_DIRS)                           \
	    "

build: $(OUTBIN)

.PHONY: .go/$(OUTBIN)
$(OUTBIN): $(BUILD_DIRS)
	@echo "making $(OUTBIN)"
	@docker run                                                 \
	    -i                                                      \
	    --rm                                                    \
	    -u $$(id -u):$$(id -g)                                  \
	    -v $$(pwd):/src                                         \
	    -w /src                                                 \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin                \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin/$(OS)_$(ARCH)  \
	    -v $$(pwd)/.go/cache:/.cache                            \
	    --env HTTP_PROXY=$(HTTP_PROXY)                          \
	    --env HTTPS_PROXY=$(HTTPS_PROXY)                        \
	    $(BUILD_IMAGE)                                          \
	    /bin/bash -c "                                          \
	        ARCH=$(ARCH)                                        \
	        OS=$(OS)                                            \
	        VERSION=$(VERSION)                                  \
	        version_strategy=$(version_strategy)                \
	        git_branch=$(git_branch)                            \
	        git_tag=$(git_tag)                                  \
	        commit_hash=$(commit_hash)                          \
	        commit_timestamp=$(commit_timestamp)                \
	        ./hack/build.sh                                     \
	    "
	@echo

.PHONY: test
test: unit-tests

unit-tests: $(BUILD_DIRS)
	@docker run                                                 \
	    -i                                                      \
	    --rm                                                    \
	    -u $$(id -u):$$(id -g)                                  \
	    -v $$(pwd):/src                                         \
	    -w /src                                                 \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin                \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin/$(OS)_$(ARCH)  \
	    -v $$(pwd)/.go/cache:/.cache                            \
	    --env HTTP_PROXY=$(HTTP_PROXY)                          \
	    --env HTTPS_PROXY=$(HTTPS_PROXY)                        \
	    $(BUILD_IMAGE)                                          \
	    /bin/bash -c "                                          \
	        ARCH=$(ARCH)                                        \
	        OS=$(OS)                                            \
	        VERSION=$(VERSION)                                  \
	        ./hack/test.sh $(SRC_PKGS)                          \
	    "

CT_COMMAND     ?= lint-and-install
TEST_CHARTS    ?=
KUBE_NAMESPACE ?=

ifeq ($(strip $(TEST_CHARTS)),)
	CT_ARGS = --all $(ct_namespace)
else
	CT_ARGS = --charts=$(TEST_CHARTS) $(ct_namespace)
endif

ifeq ($(CT_COMMAND),lint-and-install)
	ct_namespace = --namespace=$(KUBE_NAMESPACE)
	CT_ARGS := $(CT_ARGS) --helm-extra-args='--timeout 300s'
endif

.PHONY: ct
ct: $(BUILD_DIRS)
	@docker run                                                 \
	    -i                                                      \
	    --rm                                                    \
	    -v $$(pwd):/src                                         \
	    -w /src                                                 \
	    --net=host                                              \
	    -v $(HOME)/.kube:/.kube                                 \
	    -v $(HOME)/.minikube:$(HOME)/.minikube                  \
	    -v $(HOME)/.credentials:$(HOME)/.credentials            \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin                \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin/$(OS)_$(ARCH)  \
	    -v $$(pwd)/.go/cache:/.cache                            \
	    --env HTTP_PROXY=$(HTTP_PROXY)                          \
	    --env HTTPS_PROXY=$(HTTPS_PROXY)                        \
	    --env KUBECONFIG=$(subst $(HOME),,$(KUBECONFIG))        \
	    $(CHART_TEST_IMAGE)                                     \
	    /bin/sh -c "                                            \
	      set -x; \
	      kubectl delete crds --all; \
	      kubectl apply --validate=false -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml; \
	      kubectl wait --for=condition=Ready pods -n cert-manager --all --timeout=5m; \
	      ./hack/scripts/update-chart-dependencies.sh; \
	      ct $(CT_COMMAND) --debug --validate-maintainers=false $(CT_ARGS) \
	    "

ADDTL_LINTERS   := goconst,gofmt,goimports,unparam

.PHONY: lint
lint: $(BUILD_DIRS)
	@echo "running linter"
	@docker run                                                 \
	    -i                                                      \
	    --rm                                                    \
	    -u $$(id -u):$$(id -g)                                  \
	    -v $$(pwd):/src                                         \
	    -w /src                                                 \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin                \
	    -v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin/$(OS)_$(ARCH)  \
	    -v $$(pwd)/.go/cache:/.cache                            \
	    --env HTTP_PROXY=$(HTTP_PROXY)                          \
	    --env HTTPS_PROXY=$(HTTPS_PROXY)                        \
	    --env GOFLAGS="-mod=vendor"                             \
	    $(BUILD_IMAGE)                                          \
	    golangci-lint run --enable $(ADDTL_LINTERS) --timeout=10m --skip-files="generated.*\.go$\" --skip-dirs-use-default --skip-dirs=client,vendor

$(BUILD_DIRS):
	@mkdir -p $@

.PHONY: dev
dev: gen fmt

.PHONY: verify
verify: verify-gen verify-modules

.PHONY: verify-modules
verify-modules:
	go mod tidy
	go mod vendor
	@if !(git diff --exit-code HEAD); then \
		echo "go module files are out of date"; exit 1; \
	fi

.PHONY: verify-gen
verify-gen: gen fmt
	@if !(git diff --exit-code HEAD); then \
		echo "generated files are out of date, run make gen"; exit 1; \
	fi

.PHONY: add-license
add-license:
	@echo "Adding license header"
	@docker run --rm 	                                 \
		-u $$(id -u):$$(id -g)                           \
		-v /tmp:/.cache                                  \
		-v $$(pwd):$(DOCKER_REPO_ROOT)                   \
		-w $(DOCKER_REPO_ROOT)                           \
		--env HTTP_PROXY=$(HTTP_PROXY)                   \
		--env HTTPS_PROXY=$(HTTPS_PROXY)                 \
		$(BUILD_IMAGE)                                   \
		ltag -t "./hack/license" --excludes "vendor contrib libbuild" -v

.PHONY: check-license
check-license:
	@echo "Checking files for license header"
	@docker run --rm 	                                 \
		-u $$(id -u):$$(id -g)                           \
		-v /tmp:/.cache                                  \
		-v $$(pwd):$(DOCKER_REPO_ROOT)                   \
		-w $(DOCKER_REPO_ROOT)                           \
		--env HTTP_PROXY=$(HTTP_PROXY)                   \
		--env HTTPS_PROXY=$(HTTPS_PROXY)                 \
		$(BUILD_IMAGE)                                   \
		ltag -t "./hack/license" --excludes "vendor contrib libbuild" --check -v

.PHONY: ci
ci: verify check-license lint build #unit-tests cover

.PHONY: clean
clean:
	rm -rf .go bin
