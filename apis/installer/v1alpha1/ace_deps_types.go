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
	"k8s.io/apimachinery/pkg/runtime"
)

const (
	ResourceKindAceDeps = "AceDeps"
	ResourceAceDeps     = "acedeps"
	ResourceAceDepss    = "acedepss"
)

// AceDeps defines the schama for AceDeps Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=acedepss,singular=acedeps,categories={kubeops,appscode}
type AceDeps struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              AceDepsSpec `json:"spec,omitempty"`
}

// AceDepsSpec is the schema for AceDeps Operator values file
type AceDepsSpec struct {
	NameOverride     string `json:"nameOverride"`
	FullnameOverride string `json:"fullnameOverride"`

	Repositories          map[string]HelmRepository       `json:"repositories"`
	RepositoryCredentials map[string]RepositoryCredential `json:"repositoryCredentials"`
	Releases              map[string]runtime.RawExtension `json:"releases"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// AceDepsList is a list of AceDepss
type AceDepsList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of AceDeps CRD objects
	Items []AceDeps `json:"items,omitempty"`
}
