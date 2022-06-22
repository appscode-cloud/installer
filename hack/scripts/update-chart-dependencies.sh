#!/bin/sh

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

set -e

helm repo add appscode https://charts.appscode.com/stable/ || true
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx || true
helm repo add nats https://nats-io.github.io/k8s/helm/charts/ || true
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/ || true
helm repo add stakater https://stakater.github.io/stakater-charts || true

helm dependency update charts/opscenter-core
helm dependency update charts/opscenter-config
helm dependency update charts/ace
