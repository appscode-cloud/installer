/*
Copyright AppsCode Inc. and Contributors

Licensed under the AppsCode Community License 1.0.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://github.com/appscode/licenses/raw/1.0.0/AppsCode-Community-1.0.0.md

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

const (
	ResourceKindLicenseProxyserverAddonManager = "LicenseProxyserverAddonManager"
	ResourceLicenseProxyserverAddonManager     = "licenseproxyserveraddonmanager"
	ResourceLicenseProxyserverAddonManagers    = "licenseproxyserveraddonmanagers"
)

// LicenseProxyserverAddonManager defines the schama for LicenseProxyserverAddonManager Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=licenseproxyserveraddonmanagers,singular=licenseproxyserveraddonmanager,categories={kubeops,appscode}
type LicenseProxyserverAddonManager struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              LicenseProxyserverAddonManagerSpec `json:"spec,omitempty"`
}

// LicenseProxyserverAddonManagerSpec is the schema for LicenseProxyserverAddonManager Operator values file
type LicenseProxyserverAddonManagerSpec struct {
	Image string `json:"image"`
	// +optional
	Tag string `json:"tag"`
	// +optional
	KubeconfigSecretName string      `json:"kubeconfigSecretName"`
	Kubectl              DockerImage `json:"kubectl"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// LicenseProxyserverAddonManagerList is a list of LicenseProxyserverAddonManagers
type LicenseProxyserverAddonManagerList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of LicenseProxyserverAddonManager CRD objects
	Items []LicenseProxyserverAddonManager `json:"items,omitempty"`
}
