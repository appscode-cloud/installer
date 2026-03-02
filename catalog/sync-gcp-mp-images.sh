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

set -x

if [ -z "${IMAGE_REGISTRY}" ]; then
    echo "IMAGE_REGISTRY is not set"
    exit 1
fi
if [ -z "${TAG}" ]; then
    echo "TAG is not set"
    exit 1
fi

crane cp --allow-nondistributable-artifacts ghcr.io/appscode-charts/ace-installer:v2026.2.16 $IMAGE_REGISTRY/ace-installer:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-charts/ace:v2026.2.16 $IMAGE_REGISTRY/ace:$TAG
crane cp --allow-nondistributable-artifacts ghcr.io/appscode-charts/service-gateway:v2026.2.16 $IMAGE_REGISTRY/service-gateway:$TAG
