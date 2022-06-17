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
	ResourceKindUiPresets = "UiPresets"
	ResourceUiPresets     = "uipresets"
	ResourceUiPresetss    = "uipresetss"
)

// UiPresets defines the schama for UiPresets Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=uipresetss,singular=uipresets,categories={kubeops,appscode}
type UiPresets struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              UiPresetsSpec `json:"spec,omitempty"`
}

// UiPresetsSpec is the schema for UiPresets Operator values file
type UiPresetsSpec struct {
	Monitoring ServiceMonitorPreset `json:"monitoring"`
}

type ServiceMonitorPreset struct {
	ServiceMonitor ServiceMonitorLabels `json:"serviceMonitor"`
	Alert          ServiceMonitorLabels `json:"alert"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// UiPresetsList is a list of UiPresetss
type UiPresetsList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of UiPresets CRD objects
	Items []UiPresets `json:"items,omitempty"`
}
