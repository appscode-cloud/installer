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
	core "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	dnsapi "kubeops.dev/external-dns-operator/apis/external/v1alpha1"
)

const (
	ResourceKindServicePresets = "ServicePresets"
	ResourceServicePresets     = "servicepresets"
	ResourceServicePresetss    = "servicepresetss"
)

// ServicePresets defines the schama for ServicePresets Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=servicepresetss,singular=servicepresets,categories={kubeops,appscode}
type ServicePresets struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              ServicePresetsSpec `json:"spec,omitempty"`
}

type ServicePresetsSpec struct {
	NameOverride     string `json:"nameOverride"`
	FullnameOverride string `json:"fullnameOverride"`
	ReplicaCount     int    `json:"replicaCount"`
	//+optional
	RegistryFQDN       string                    `json:"registryFQDN"`
	Image              ImageReference            `json:"image"`
	ImagePullSecrets   []string                  `json:"imagePullSecrets"`
	PodAnnotations     map[string]string         `json:"podAnnotations"`
	PodSecurityContext *core.PodSecurityContext  `json:"podSecurityContext"`
	SecurityContext    *core.SecurityContext     `json:"securityContext"`
	Resources          core.ResourceRequirements `json:"resources"`
	//+optional
	NodeSelector   map[string]string      `json:"nodeSelector"`
	Tolerations    []core.Toleration      `json:"tolerations"`
	Affinity       *core.Affinity         `json:"affinity"`
	ServiceAccount NatsServiceAccountSpec `json:"serviceAccount"`
	Monitoring     GlobalMonitoring       `json:"monitoring"`
	Infra          ServiceProviderInfra   `json:"infra"`
	GatewayDns     ServiceGatewayDns      `json:"gateway-dns"`
	// +optional
	VaultServer LocalObjectReference `json:"vaultServer"`
}

type ServiceProviderInfra struct {
	ClusterName   string     `json:"clusterName"`
	GatewayDomain string     `json:"gatewayDomain"`
	TLS           InfraTLS   `json:"tls"`
	DNS           GatewayDns `json:"dns"`
}

type ServiceGatewayDns struct {
	Enabled bool                    `json:"enabled"`
	Spec    *dnsapi.ExternalDNSSpec `json:"spec,omitempty"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// ServicePresetsList is a list of ServicePresetss
type ServicePresetsList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of ServicePresets CRD objects
	Items []ServicePresets `json:"items,omitempty"`
}
