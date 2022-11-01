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
	Release          ObjectReference         `json:"release"`
	License          string                  `json:"license"`
	Registry         string                  `json:"registry"`
	RegistryFQDN     string                  `json:"registryFQDN"`
	ImagePullSecrets []string                `json:"imagePullSecrets"`
	Monitoring       GlobalMonitoring        `json:"monitoring"`
	Infra            AceOptionsPlatformInfra `json:"infra"`
	Settings         AceOptionsSettings      `json:"settings"`
	Billing          AceOptionsComponentSpec `json:"billing"`
	PlatformUi       AceOptionsComponentSpec `json:"platform-ui"`
	AccountsUi       AceOptionsComponentSpec `json:"accounts-ui"`
	ClusterUi        AceOptionsComponentSpec `json:"cluster-ui"`
	DeployUi         AceOptionsComponentSpec `json:"deploy-ui"`
	Grafana          AceOptionsComponentSpec `json:"grafana"`
	KubedbUi         AceOptionsComponentSpec `json:"kubedb-ui"`
	MarketplaceUi    AceOptionsComponentSpec `json:"marketplace-ui"`
	PlatformApi      AceOptionsComponentSpec `json:"platform-api"`
	PromProxy        AceOptionsComponentSpec `json:"prom-proxy"`
	Ingress          AceOptionsIngressNginx  `json:"ingress"`
	Nats             AceOptionsNatsSettings  `json:"nats"`
}

type AceOptionsComponentSpec struct {
	Enabled bool `json:"enabled"`
	//+optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
}

// +kubebuilder:validation:Enum=LoadBalancer;HostPort
type ServiceType string

const (
	ServiceTypeLoadBalancer ServiceType = "LoadBalancer"
	ServiceTypeHostPort     ServiceType = "HostPort"
)

const (
	DefaultPasswordLength = 16
)

type AceOptionsIngressNginx struct {
	ExposeVia ServiceType `json:"exposeVia"`
	//+optional
	Resources    core.ResourceRequirements `json:"resources"`
	NodeSelector map[string]string         `json:"nodeSelector"`
}

type AceOptionsNatsSettings struct {
	ExposeVia ServiceType `json:"exposeVia"`
	Replics   int         `json:"replicas"`
	//+optional
	Resources core.ResourceRequirements `json:"resources"`
	//+optional
	NodeSelector map[string]string `json:"nodeSelector"`
}

type AceOptionsPlatformInfra struct {
	StorageClass  LocalObjectReference         `json:"storageClass"`
	TLS           AceOptionsInfraTLS           `json:"tls"`
	DNS           InfraDns                     `json:"dns"`
	CloudServices AceOptionsInfraCloudServices `json:"cloudServices"`
}

type AceOptionsInfraTLS struct {
	Issuer TLSIssuerType `json:"issuer"`
	Acme   TLSIssuerAcme `json:"acme"`
}

type AceOptionsInfraCloudServices struct {
	Provider string                  `json:"provider"`
	Auth     ObjstoreAuth            `json:"auth"`
	Objstore AceOptionsInfraObjstore `json:"objstore"`
	// +optional
	Kms *AceOptionsInfraKms `json:"kms,omitempty"`
}

type AceOptionsInfraObjstore struct {
	Bucket string `json:"bucket"`
}

type AceOptionsInfraKms struct {
	MasterKeyURL string `json:"masterKeyURL"`
}

type AceOptionsSettings struct {
	DB       AceOptionsDBSettings       `json:"db"`
	Cache    AceOptionsCacheSettings    `json:"cache"`
	SMTP     AceOptionsSMTPSettings     `json:"smtp"`
	Platform AceOptionsPlatformSettings `json:"platform"`
}

type AceOptionsDBSettings struct {
	Persistence PersistenceSpec           `json:"persistence"`
	Resources   core.ResourceRequirements `json:"resources"`
}

type AceOptionsCacheSettings struct {
	Persistence PersistenceSpec           `json:"persistence"`
	Resources   core.ResourceRequirements `json:"resources"`
}

type AceOptionsSMTPSettings struct {
	Host       string `json:"host"`
	TlsEnabled bool   `json:"tlsEnabled"`
	From       string `json:"from"`
	Username   string `json:"username"`
	Password   string `json:"password"`
	// SubjectPrefix   string `json:"subjectPrefix"`
	SendAsPlainText bool `json:"sendAsPlainText"`
}

type AceOptionsPlatformSettings struct {
	Domain string `json:"domain"`
	Hosted bool   `json:"hosted"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// AceOptionsList is a list of AceOptionss
type AceOptionsList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of AceOptions CRD objects
	Items []AceOptions `json:"items,omitempty"`
}
