#!/bin/bash

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

set -eou pipefail

# image-packer embeds the resource-metadata hubs (resourceeditors,
# resourcedescriptors, clusterprofiles), but the reloader used by
# kmodules.xyz/resource-metadata shadows the embedded copies with
# /tmp/hub/<hub> when those directories exist. A stale or empty leftover
# there makes image-packer load nothing and emit a broken catalog, so
# remove them before running.
rm -rf /tmp/hub

image-packer list --root-dir=charts --output-dir=catalog

# Feature charts left out of catalog/feature-chart-images.yaml because another
# catalog already publishes their images. Rendering them here would duplicate
# those lists, and would mirror a second copy of every database image.
#
#   - charts owned by this repo   -> catalog/imagelist.yaml
#   - charts owned by a component -> that component installer's own
#     catalog/imagelist.yaml, collected per org by appscode-cloud/artifacts
#     (pkg/collect/orgs.go)
#   - the externally maintained charts appscode-cloud/artifacts renders itself
#     from curated CI values (pkg/collect/externals.go)
#
# Charts NOT listed here -- reloader, prometheus-adapter, kyverno, longhorn,
# opencost, stash, voyager, ... -- have no other publisher, which is why their
# images went unmirrored until now.
feature_chart_exclusions=(
    # appscode-cloud/installer
    aceshifter
    catalog-manager
    cluster-presets
    inbox-ui
    kubedb-ui-presets
    license-proxyserver
    license-proxyserver-manager
    opscenter-features
    service-backend
    service-gateway-presets
    service-provider
    stash-presets
    # kubedb/installer
    kubedb
    kubedb-opscenter
    kubedb-provider-aws
    kubedb-provider-azure
    kubedb-provider-gcp
    prepare-cluster
    # kubestash/installer
    kubestash
    # kubevault/installer
    kubevault
    kubevault-opscenter
    # kubeops/installer
    cert-manager-csi-driver-cacerts
    config-syncer
    external-dns-operator
    falco-ui-server
    gatekeeper-grafana-dashboards
    gatekeeper-library
    kube-ui-server
    opencost-grafana-dashboards
    operator-shard-manager
    panopticon
    scanner
    sidekick
    storage-metrics-server
    supervisor
    # kluster-manager/installer
    cluster-auth-manager
    cluster-gateway-manager
    cluster-manager-hub
    cluster-manager-spoke
    cluster-profile-manager
    cluster-proxy-manager
    fluxcd-manager
    hub-cluster-robot
    managed-serviceaccount-manager
    # open-viz/installer
    grafana-operator
    kube-grafana-dashboards
    monitoring-operator
    # opnpulse/installer
    appscode-otel-stack
    inbox-agent
    inbox-server
    prom-label-proxy
    tenant-operator
    thanos-operator
    # rendered by appscode-cloud/artifacts from hack/ci values
    cert-manager
    flux2
    keda
    keda-add-ons-http
    kube-prometheus-stack
    snapshot-controller
)

exclude_args=()
for chart in "${feature_chart_exclusions[@]}"; do
    exclude_args+=("--exclude-chart=${chart}")
done

image-packer list-feature-charts --root-dir=charts --output-dir=catalog "${exclude_args[@]}"

image-packer ace-up --dir=.

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
    --src=catalog/feature-chart-images.yaml \
    --src=catalog/reusable-ui-charts.yaml

image-packer generate-gcp-script --allow-nondistributable-artifacts \
    --output-dir=catalog \
    --src=catalog/ace.yaml

make add-license fmt
