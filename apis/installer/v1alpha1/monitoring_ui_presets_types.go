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
	"go.appscode.dev/alerts/apis/alerts/v1alpha1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

const (
	ResourceKindMonitoringUiPresets = "MonitoringUiPresets"
	ResourceMonitoringUiPresets     = "monitoringuipresets"
	ResourceMonitoringUiPresetss    = "monitoringuipresetss"
)

// MonitoringUiPresets defines the schama for MonitoringUiPresets Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=monitoringuipresetss,singular=monitoringuipresets,categories={kubeops,appscode}
type MonitoringUiPresets struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              MonitoringUiPresetsSpec `json:"spec,omitempty"`
}

// MonitoringUiPresetsSpec is the schema for MonitoringUiPresets Operator values file
type MonitoringUiPresetsSpec struct {
	Monitoring ServiceMonitorPreset `json:"monitoring"`
}

type ServiceMonitorPreset struct {
	ServiceMonitor ServiceMonitorLabels `json:"serviceMonitor"`
	Alert          AlertPreset          `json:"alert"`

	// enabled: string
}

type AlertPreset struct {
	Enabled v1alpha1.SeverityFlag `json:"enabled"`
	// +optional
	Labels map[string]string `json:"labels"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// MonitoringUiPresetsList is a list of MonitoringUiPresetss
type MonitoringUiPresetsList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of MonitoringUiPresets CRD objects
	Items []MonitoringUiPresets `json:"items,omitempty"`
}
