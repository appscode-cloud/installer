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
	ResourceKindAceOptions = "AceOptions"
	ResourceAceOptions     = "aceoptions"
	ResourceAceOptionss    = "aceoptionss"
)

// AceOptions defines the schama for AceOptions Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=aceoptionss,singular=aceoptions,categories={kubeops,appscode}
type AceOptions struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              AceOptionsSpec `json:"spec,omitempty"`
}

// AceOptionsSpec is the schema for AceOptions Operator values file
type AceOptionsSpec struct {
	Platform AcePlatformOptions `json:"platform"`
	DNS      AceDNSOptions      `json:"dns"`
}

type AcePlatformOptions struct {
	Domain string `json:"domain"`
}

type AceDNSOptions struct {
	Provider string           `json:"provider"`
	Auth     DNSProdviderAuth `json:"auth"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// AceOptionsList is a list of AceOptionss
type AceOptionsList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of AceOptions CRD objects
	Items []AceOptions `json:"items,omitempty"`
}
