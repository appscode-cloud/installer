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

# Builds the two Trust Console images from source, saves them to a tarball and, with TARGET set, imports them into the
# containerd of a k3s host. Nothing is pushed. Run it on a build host with go, node, npm and docker (the legacy builder is
# enough: only the binary and the built UI go into the build context).
#
#   TARGET=ubuntu@10.2.0.5 hack/trustconsole/build-images.sh
#
# The module graph holds the private go.appscode.dev/iam, which `go build` fetches over ssh with the host's own key.
# Settings: WORK (checkout, default ~/trustconsole-build), TC_REF (default design/platform-and-akp-console),
# TC_REPO (default git@github.com:appscode-cloud/trust-console.git), OUT (default $WORK/images).

set -euo pipefail

WORK=${WORK:-$HOME/trustconsole-build}
TC_REF=${TC_REF:-design/platform-and-akp-console}
TC_REPO=${TC_REPO:-git@github.com:appscode-cloud/trust-console.git}
OUT=${OUT:-$WORK/images}
IMAGE=${IMAGE:-ghcr.io/appscode/trust-console}
UI_IMAGE=${UI_IMAGE:-ghcr.io/appscode/trust-console-ui}

mkdir -p "$WORK" "$OUT"
if [ -e "$WORK/trust-console/.git" ]; then
    git -C "$WORK/trust-console" fetch -q origin "$TC_REF"
else
    git clone -q "$TC_REPO" "$WORK/trust-console"
    git -C "$WORK/trust-console" fetch -q origin "$TC_REF"
fi
git -C "$WORK/trust-console" checkout -q --detach FETCH_HEAD
TAG=tc-$(git -C "$WORK/trust-console" rev-parse --short=10 HEAD)

ctx=$(mktemp -d)
trap 'rm -rf "$ctx"' EXIT
mkdir -p "$ctx/backend" "$ctx/ui"

(
    cd "$WORK/trust-console"
    export GOPRIVATE='github.com/appscode-cloud/*,go.appscode.dev/*'
    export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=url.git@github.com:.insteadOf GIT_CONFIG_VALUE_0=https://github.com/
    CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.Version=$TAG" -o "$ctx/backend/trust-console" ./cmd/trust-console
    cd ui && npm ci --no-audit --no-fund && npm run build
    cp -r dist "$ctx/ui/dist"
    cp default.conf.template "$ctx/ui/"
)

cat >"$ctx/backend/Dockerfile" <<'DOCKERFILE'
FROM alpine:3.20
RUN apk add --no-cache ca-certificates curl && addgroup -S trust && adduser -S trust -G trust
COPY trust-console /usr/local/bin/trust-console
USER trust
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/trust-console"]
DOCKERFILE
# The same nginx the repository's ui/Dockerfile ends in, on the already built dist.
cat >"$ctx/ui/Dockerfile" <<'DOCKERFILE'
FROM nginx:stable-alpine
COPY dist /usr/share/nginx/html/trust
COPY default.conf.template /etc/nginx/templates/default.conf.template
ENV HUB_UPSTREAM=localhost:8080
RUN chown -R nginx:root /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d /etc/nginx/templates \
  && chmod -R g=u /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d /etc/nginx/templates \
  && touch /var/run/nginx.pid && chown nginx:root /var/run/nginx.pid && chmod g=u /var/run/nginx.pid
USER 101
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
DOCKERFILE

docker build -q -t "$IMAGE:$TAG" "$ctx/backend"
docker build -q -t "$UI_IMAGE:$TAG" "$ctx/ui"
docker save "$IMAGE:$TAG" "$UI_IMAGE:$TAG" -o "$OUT/trust-console-images.tar"
echo "built $IMAGE:$TAG and $UI_IMAGE:$TAG ($OUT/trust-console-images.tar)"

if [ -n "${TARGET:-}" ]; then
    ssh "$TARGET" 'sudo k3s ctr -n k8s.io images import -' <"$OUT/trust-console-images.tar"
fi
echo "set trust-console-api.image.tag and trust-console-ui.image.tag to $TAG"
