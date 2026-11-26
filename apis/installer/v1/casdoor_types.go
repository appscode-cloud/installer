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

package v1

import (
	core "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

const (
	ResourceKindCasdoor = "Casdoor"
	ResourceCasdoor     = "casdoor"
	ResourceCasdoors    = "casdoors"
)

// Casdoor defines the schema for Casdoor Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=casdoors,singular=casdoor,categories={kubeops,appscode}
type Casdoor struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              CasdoorSpec `json:"spec,omitempty"`
}

// CasdoorSpec is the schema for Casdoor values file
type CasdoorSpec struct {
	Global       ConsoleUiGlobal `json:"global"`
	ReplicaCount int             `json:"replicaCount"`
	// +optional
	RegistryFQDN string       `json:"registryFQDN"`
	Image        ConsoleImage `json:"image"`
	// +optional
	ImagePullSecrets []string `json:"imagePullSecrets"`
	// +optional
	NameOverride string `json:"nameOverride"`
	// +optional
	FullnameOverride string `json:"fullnameOverride"`
	// +optional
	PodAnnotations map[string]string `json:"podAnnotations"`
	// +optional
	PodSecurityContext *core.PodSecurityContext `json:"podSecurityContext"`
	// +optional
	SecurityContext *core.SecurityContext `json:"securityContext"`
	Service         ConsoleService        `json:"service"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
	// +optional
	Affinity *core.Affinity `json:"affinity"`
	// +optional
	PublicURL string          `json:"publicUrl"`
	Database  CasdoorDatabase `json:"database"`
	// +optional
	AdminPassword string              `json:"adminPassword"`
	Organization  CasdoorOrganization `json:"organization"`
	// +optional
	Jwt CasdoorJwt `json:"jwt"`
	// +optional
	Applications []CasdoorApplication `json:"applications"`
	// +optional
	Users []CasdoorUser `json:"users"`
}

type CasdoorDatabase struct {
	// +optional
	Host string `json:"host"`
	Port int    `json:"port"`
	Name string `json:"name"`
	User string `json:"user"`
	// +optional
	Password string `json:"password"`
	SSLMode  string `json:"sslmode"`
}

type CasdoorOrganization struct {
	Name        string `json:"name"`
	DisplayName string `json:"displayName"`
	// Optional, Prompt or Required.
	MfaRule string `json:"mfaRule"`
}

type CasdoorJwt struct {
	// +optional
	Certificate string `json:"certificate"`
	// +optional
	PrivateKey string `json:"privateKey"`
}

type CasdoorApplication struct {
	Name         string   `json:"name"`
	DisplayName  string   `json:"displayName"`
	ClientID     string   `json:"clientId"`
	ClientSecret string   `json:"clientSecret"`
	RedirectURIs []string `json:"redirectUris"`
}

type CasdoorUser struct {
	Name        string `json:"name"`
	DisplayName string `json:"displayName"`
	Email       string `json:"email"`
	Password    string `json:"password"`
	// +optional
	Tag string `json:"tag"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// CasdoorList is a list of Casdoors
type CasdoorList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of Casdoor CRD objects
	Items []Casdoor `json:"items,omitempty"`
}
