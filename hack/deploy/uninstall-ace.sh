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

echo "pausing fluxcd helm controller"
kubectl scale deploy/helm-controller -n flux-system --replicas=0
# wait for pods to teminate
while [[ -n $(kubectl get deploy -n flux-system helm-controller -o=jsonpath='{.status.replicas}') ]]; do
    sleep 1
done

echo "uninstall ace chart"
helm uninstall ace -n ace
# wait for pods to teminate
while [[ $(kubectl get pods -n ace -l lapp.kubernetes.io/instance=ace -o=name | wc -l) -gt 0 ]]; do
    sleep 1
done
# force delete
kubectl delete pods -n ace -l lapp.kubernetes.io/instance=ace --force --grace-period=0

echo "deleting cached helm charts"
kubectl delete helmcharts.source.toolkit.fluxcd.io -n kubeops --all

echo "pausing fluxcd source controller"
kubectl scale deploy/source-controller -n flux-system --replicas=0
# wait for pods to teminate
while [[ -n $(kubectl get deploy -n flux-system source-controller -o=jsonpath='{.status.replicas}') ]]; do
    sleep 1
done

# remove finalizer from helmreleases
for x in $(kubectl get helmreleases.helm.toolkit.fluxcd.io -n kubeops -o name); do
    kubectl patch $x -n kubeops -p '{"metadata":{"finalizers":null}}' --type=merge
done
# delete helmreleases
kubectl delete helmreleases.helm.toolkit.fluxcd.io -n kubeops --all

helm uninstall -n ace service-backend || true

helm uninstall -n kubeops opscenter-features || true
helm uninstall -n kubeops ace-installer || true
# helm uninstall -n kubeops docker-machine-operator || true
# helm uninstall -n kubeops external-dns-operator || true
# helm uninstall -n kubeops kube-ui-server || true
# helm uninstall -n kubeops license-proxyserver || true
# helm uninstall -n kubeops reloader || true

# helm uninstall -n cert-manager cert-manager-csi-driver-cacerts || true
helm uninstall -n cert-manager cert-manager-webhook-ace || true

helm uninstall -n monitoring grafana-operator || true
# helm uninstall -n monitoring kube-grafana-dashboards || true
# helm uninstall -n monitoring kube-prometheus-stack || true
helm uninstall -n monitoring monitoring-operator || true
helm uninstall -n monitoring panopticon || true
# helm uninstall -n monitoring prometheus-adapter || true

helm uninstall -n stash stash-presets || true

# remove finalizer from features
for x in $(kubectl get features.ui.k8s.appscode.com -o name); do
    kubectl patch $x -p '{"metadata":{"finalizers":null}}' --type=merge
done
# delete features
kubectl delete features.ui.k8s.appscode.com --all
