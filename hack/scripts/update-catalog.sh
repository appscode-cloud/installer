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

image-packer list --root-dir=charts --output-dir=catalog

image-packer list-feature-charts --root-dir=charts --output-dir=catalog

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
    --src=catalog/reusable-ui-charts.yaml

image-packer generate-gcp-script --allow-nondistributable-artifacts \
    --output-dir=catalog \
    --src=catalog/ace.yaml

make add-license fmt
