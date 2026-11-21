#!/usr/bin/env bash

# Copyright AppsCode Inc. and Contributors
#
# Licensed under the AppsCode Community License 1.0.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://github.com/appscode/licenses/raw/1.0.0/AppsCode-Community-1.0.0.md
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Builds or pulls the images of a kubepatch demo and imports them into a k3s that cannot pull the private ones.
# Private images (b3, patch-console, patch-console-ui) are built from source and only ever go to a tarball and into
# k3s' containerd: they are never pushed, and no registry credential is read or written here. The patch console
# agent runs the patch-console image (`patch-console agent`), so there is no image of its own.
#
# Run it on a build host with docker, docker buildx and an ssh agent whose key can read the private repositories
# (b3, patch-console and go.appscode.dev/iam):
#
#   load-images.sh fetch      clone or update the sources under $WORK
#   load-images.sh build      build b3, patch-console and patch-console-ui
#   load-images.sh pull       pull the public images
#   load-images.sh save       docker save every image into $OUT/kubepatch-images.tar; write $OUT/kubepatch-images.digests
#   load-images.sh import     import the tarball into k3s over ssh on $TARGET (needs sudo there), or into $DOCKER_K3S
#   load-images.sh all        fetch, build, pull, save, import
#
# Settings (environment):
#   WORK       directory for the checkouts, default ~/kubepatch-build
#   B3_REF     branch or tag of appscode-cloud/b3, default fix-v2-only-cold-boot
#   PATCH_REF  branch or tag of appscode-cloud/patch-console, default master
#   TARGET     ssh target of the k3s host, e.g. ubuntu@10.2.0.5   (import)
#   DOCKER_K3S name of a k3s-in-docker container, for tests        (import)
#   OUT        directory for the tarball, default $WORK/images
# The images are named and tagged as profiles/k3s-test.yaml expects; the digests file lists what was built.

set -euo pipefail

WORK=${WORK:-$HOME/kubepatch-build}
B3_REF=${B3_REF:-fix-v2-only-cold-boot}
PATCH_REF=${PATCH_REF:-master}
# 3.1.0 of the two UIs speaks b3's v1 API, which v2_only does not mount: build the branches that speak the v2 API.
PLATFORM_UI_REF=${PLATFORM_UI_REF:-feat/iam-ui}
CLUSTER_UI_REF=${CLUSTER_UI_REF:-feat/akp-v2-client}
PLATFORM_UI_IMAGE=${PLATFORM_UI_IMAGE:-ghcr.io/appscode/platform-ui}
CLUSTER_UI_IMAGE=${CLUSTER_UI_IMAGE:-ghcr.io/appscode/cluster-ui}
OUT=${OUT:-$WORK/images}
B3_REPO=${B3_REPO:-git@github.com:appscode-cloud/b3.git}
PATCH_REPO=${PATCH_REPO:-git@github.com:appscode-cloud/patch-console.git}
B3_IMAGE=${B3_IMAGE:-ghcr.io/appscode/b3}
PATCH_IMAGE=${PATCH_IMAGE:-ghcr.io/appscode/patch-console}
PATCH_UI_IMAGE=${PATCH_UI_IMAGE:-ghcr.io/appscode/patch-console-ui}
PUBLIC_IMAGES=${PUBLIC_IMAGES:-"ghcr.io/appscode/casdoor:v4.29.0-3391e5fe ghcr.io/appscode-images/postgres:18.3-bookworm ghcr.io/appscode-images/nats:2.12.6-alpine natsio/nats-box:0.19.2"}
BUILD_IMAGE=${BUILD_IMAGE:-ghcr.io/appscode/golang-dev:1.27}

b3_tag() { echo "kubepatch-$(git -C "$WORK/b3" rev-parse --short=10 HEAD)"; }
platform_ui_tag() { echo "kubepatch-$(git -C "$WORK/platform-ui" rev-parse --short=10 HEAD)"; }
cluster_ui_tag() { echo "kubepatch-$(git -C "$WORK/cluster-ui" rev-parse --short=10 HEAD)"; }
patch_tag() { echo "kubepatch-$(git -C "$WORK/patch-console" rev-parse --short=10 HEAD)"; }

all_images() {
    echo "$B3_IMAGE:$(b3_tag)" "$PATCH_IMAGE:$(patch_tag)" "$PATCH_UI_IMAGE:$(patch_tag)" "$PLATFORM_UI_IMAGE:$(platform_ui_tag)" "$CLUSTER_UI_IMAGE:$(cluster_ui_tag)" $PUBLIC_IMAGES
}

checkout() { # dir repo ref
    if [ -e "$1/.git" ]; then
        git -C "$1" fetch -q origin "$3"
    else
        git clone -q "$2" "$1"
        git -C "$1" fetch -q origin "$3"
    fi
    git -C "$1" checkout -q --detach FETCH_HEAD
}

fetch() {
    mkdir -p "$WORK"
    checkout "$WORK/b3" "$B3_REPO" "$B3_REF"
    checkout "$WORK/patch-console" "$PATCH_REPO" "$PATCH_REF"
    checkout "$WORK/platform-ui" git@github.com:appscode-cloud/platform-ui.git "$PLATFORM_UI_REF"
    checkout "$WORK/cluster-ui" git@github.com:appscode-cloud/cluster-ui.git "$CLUSTER_UI_REF"
}

build_b3() {
    local dir=$WORK/b3 sha ctx
    sha=$(git -C "$dir" rev-parse HEAD)
    mkdir -p "$dir/bin" "$dir/.go/cache"
    # b3 vendors its modules, so the build needs no credentials. A non-tag build enforces no license.
    docker run --rm -u "$(id -u):$(id -g)" -v "$dir:/src" -w /src -v "$dir/.go/cache:/.cache" -e HOME=/tmp \
        -e CGO_ENABLED=0 -e GOOS=linux -e GOARCH=amd64 -e GOFLAGS=-mod=vendor -e GOCACHE=/.cache/gocache \
        "$BUILD_IMAGE" go build -installsuffix static \
        -ldflags "-X main.Version=$(b3_tag) -X main.CommitHash=$sha -X main.GitBranch=$B3_REF" \
        -o bin/b3-linux-amd64 .
    # The repository is gigabytes: send the image build only the binary.
    ctx=$(mktemp -d)
    mkdir "$ctx/bin"
    cp "$dir/bin/b3-linux-amd64" "$ctx/bin/"
    cat >"$ctx/Dockerfile" <<'DOCKERFILE'
FROM debian:13
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*
ENV B3_CUSTOM=/data/b3
COPY bin/b3-linux-amd64 /b3
ENTRYPOINT ["/b3"]
DOCKERFILE
    docker build -t "$B3_IMAGE:$(b3_tag)" "$ctx"
    rm -rf "$ctx"
}

build_patch_console() {
    local dir=$WORK/patch-console uidf
    # The module graph holds the private go.appscode.dev/iam, fetched over ssh from the agent.
    [ -n "${SSH_AUTH_SOCK:-}" ] || {
        echo "start an ssh-agent with a key that can read go.appscode.dev/iam" >&2
        exit 1
    }
    DOCKER_BUILDKIT=1 docker build --ssh default -t "$PATCH_IMAGE:$(patch_tag)" -f "$dir/Dockerfile" "$dir"
    # The UI Dockerfile builds on node:alpine, where `npm ci` skips rolldown's musl binding (npm bug 4828) and
    # `vite build` fails; the same build on a glibc node image works. Build with a copy that only swaps the base.
    uidf=$(mktemp "$dir/ui/Dockerfile.kp.XXXXXX")
    sed -e 's|^FROM node:22-alpine@[^ ]* AS builder|FROM node:22-bookworm AS builder|' \
        -e 's|^RUN apk add --no-cache git openssh-client .*|RUN apt-get update \&\& apt-get install -y --no-install-recommends git openssh-client \&\& rm -rf /var/lib/apt/lists/* \\|' \
        "$dir/ui/Dockerfile" >"$uidf"
    DOCKER_BUILDKIT=1 docker build --ssh default -t "$PATCH_UI_IMAGE:$(patch_tag)" -f "$uidf" "$dir/ui"
    rm -f "$uidf"
}

# The two UIs fetch private git dependencies at `npm install`: over ssh from the agent, on a glibc node image
# (npm bug 4828 again on alpine).
build_ui() { # dir image tag
    local dir=$1 df
    df=$(mktemp "$dir/Dockerfile.kp.XXXXXX")
    python3 - "$dir/Dockerfile" "$df" <<'PY'
import re, sys
s = open(sys.argv[1]).read()
s = s.replace("node:22-alpine", "node:22-bookworm", 1)
# the build stage reaches the private git dependencies with an ssh key from the agent, not a token
setup = ('RUN apt-get update && apt-get install -y --no-install-recommends git openssh-client && rm -rf /var/lib/apt/lists/* \\\n'
         ' && mkdir -p -m 0700 /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts \\\n'
         ' && git config --global url."git@github.com:".insteadOf "https://github.com/"\n\n')
start = s.index("RUN apk add") if "RUN apk add" in s else s.index("# add git credentials on build")
s = s[:start] + setup + s[s.index("WORKDIR /app"):]
s = re.sub(r"^RUN (NODE_OPTIONS=\S+ CYPRESS_INSTALL_BINARY=0 npm install|npm ci)$", r"RUN --mount=type=ssh \1", s, flags=re.M)
open(sys.argv[2], "w").write(s)
PY
    DOCKER_BUILDKIT=1 docker build --ssh default --provenance=false -t "$2:$3" -f "$df" "$dir"
    rm -f "$df"
}

build_uis() {
    [ -n "${SSH_AUTH_SOCK:-}" ] || {
        echo "start an ssh-agent with a key that can read the private git dependencies" >&2
        exit 1
    }
    build_ui "$WORK/platform-ui" "$PLATFORM_UI_IMAGE" "$(platform_ui_tag)"
    build_ui "$WORK/cluster-ui" "$CLUSTER_UI_IMAGE" "$(cluster_ui_tag)"
}

pull_public() {
    for i in $PUBLIC_IMAGES; do docker pull -q "$i" >/dev/null; done
}

save() {
    mkdir -p "$OUT"
    # shellcheck disable=SC2046
    docker save $(all_images) -o "$OUT/kubepatch-images.tar"
    # The ids are what a pre-pinned `digest` of the private images cannot be (no registry holds them); the
    # repo digests of the public ones are what the production profile pins.
    for i in $(all_images); do
        printf '%s %s %s\n' "$i" "$(docker image inspect --format '{{.Id}}' "$i")" "$(docker image inspect --format '{{index .RepoDigests 0}}' "$i" 2>/dev/null || true)"
    done | tee "$OUT/kubepatch-images.digests"
}

import() {
    local tar=$OUT/kubepatch-images.tar
    if [ -n "${DOCKER_K3S:-}" ]; then
        docker exec -i "$DOCKER_K3S" ctr images import - <"$tar"
    elif [ -n "${TARGET:-}" ]; then
        # Only the import touches the host: `ctr images import` into k3s' own containerd. An image that is
        # imported (not pulled) is known by its tag only, so give it a name by digest too: a pod that pins the
        # digest then finds it instead of asking a registry.
        ssh "$TARGET" 'sudo k3s ctr images import -' <"$tar"
        while read -r img _ repodigest; do
            [ -n "$repodigest" ] && ssh "$TARGET" "sudo k3s ctr -n k8s.io images tag --force $img $repodigest" >/dev/null
        done <"$OUT/kubepatch-images.digests"
    else
        echo "set TARGET (ssh target) or DOCKER_K3S (container name)" >&2
        exit 1
    fi
}

case "${1:-}" in
    fetch) fetch ;;
    build)
        build_b3
        build_patch_console
        build_uis
        ;;
    build-uis) build_uis ;;
    build-b3) build_b3 ;;
    build-patch-console) build_patch_console ;;
    pull) pull_public ;;
    save) save ;;
    import) import ;;
    all)
        fetch
        build_b3
        build_patch_console
        build_uis
        pull_public
        save
        import
        ;;
    *)
        sed -n 17,40p "$0" >&2
        exit 1
        ;;
esac
