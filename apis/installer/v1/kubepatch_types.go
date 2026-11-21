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
	ResourceKindKubepatch = "Kubepatch"
	ResourceKubepatch     = "kubepatch"
	ResourceKubepatchs    = "kubepatchs"
)

// Kubepatch defines the schema for Kubepatch Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=kubepatchs,singular=kubepatch,categories={kubeops,appscode}
type Kubepatch struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              KubepatchSpec `json:"spec,omitempty"`
}

// KubepatchSpec is the schema for Kubepatch values file
type KubepatchSpec struct {
	// +optional
	Production bool            `json:"production"`
	Global     KubepatchGlobal `json:"global"`
	// +optional
	NameOverride string `json:"nameOverride"`
	// +optional
	FullnameOverride string                `json:"fullnameOverride"`
	Credentials      KubepatchCredentials  `json:"credentials"`
	Routing          KubepatchRouting      `json:"routing"`
	TLS              KubepatchTLS          `json:"tls"`
	Casdoor          KubepatchCasdoor      `json:"casdoor"`
	Postgres         KubepatchPostgres     `json:"postgres"`
	Persistence      KubepatchPersistence  `json:"persistence"`
	NATS             KubepatchNATS         `json:"nats"`
	B3               KubepatchB3           `json:"b3"`
	PatchConsole     KubepatchPatchConsole `json:"patchConsole"`
	AkpBootstrap     KubepatchAkpBootstrap `json:"akpBootstrap"`
	PlatformUI       KubepatchUIChart      `json:"platform-ui"`
	ClusterUI        KubepatchUIChart      `json:"cluster-ui"`
}

type KubepatchGlobal struct {
	Platform KubepatchPlatform `json:"platform"`
	// Registry prefix for the images this chart pulls itself.
	// +optional
	ImageRegistry string `json:"imageRegistry"`
	// +optional
	ImagePullSecrets []string `json:"imagePullSecrets"`
}

type KubepatchPlatform struct {
	Host           string `json:"host"`
	HostType       string `json:"hostType"`
	DeploymentType string `json:"deploymentType"`
}

type KubepatchCredentials struct {
	// +optional
	ExistingSecret string `json:"existingSecret"`
}

type KubepatchRouting struct {
	// gateway, ingress or none
	Mode string `json:"mode"`
	// +optional
	HTTPSPort int `json:"httpsPort"`
	// +optional
	RootRedirect string                  `json:"rootRedirect"`
	Gateway      KubepatchRoutingGateway `json:"gateway"`
	Ingress      KubepatchRoutingIngress `json:"ingress"`
}

type KubepatchRoutingGateway struct {
	Create    bool   `json:"create"`
	ClassName string `json:"className"`
	// +optional
	Annotations map[string]string `json:"annotations"`
	// +optional
	ParentRefs []map[string]string `json:"parentRefs"`
	// +optional
	BackendTrafficPolicy bool `json:"backendTrafficPolicy"`
}

type KubepatchRoutingIngress struct {
	// +optional
	ClassName string `json:"className"`
	// +optional
	Annotations map[string]string `json:"annotations"`
}

type KubepatchTLS struct {
	// selfSigned, existing or none
	Mode string `json:"mode"`
	// +optional
	ExistingSecret string `json:"existingSecret"`
	// +optional
	ValidityDays int `json:"validityDays"`
}

// KubepatchImage is an image the chart pulls itself; a digest wins over the tag.
type KubepatchImage struct {
	Repository string `json:"repository"`
	Tag        string `json:"tag"`
	// +optional
	Digest string `json:"digest"`
	// +optional
	PullPolicy string `json:"pullPolicy"`
}

type KubepatchCasdoorApp struct {
	Name     string `json:"name"`
	ClientID string `json:"clientId"`
}

type KubepatchCasdoor struct {
	Enabled bool           `json:"enabled"`
	Image   KubepatchImage `json:"image"`
	// +optional
	Host string `json:"host"`
	// +optional
	Endpoint         string                `json:"endpoint"`
	Organization     string                `json:"organization"`
	AkpApplication   KubepatchCasdoorApp   `json:"akpApplication"`
	PatchApplication KubepatchCasdoorApp   `json:"patchApplication"`
	MFA              KubepatchCasdoorMFA   `json:"mfa"`
	Admin            KubepatchCasdoorAdmin `json:"admin"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	PodAnnotations map[string]string `json:"podAnnotations"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
}

type KubepatchDatabase struct {
	Name string `json:"name"`
	User string `json:"user"`
}

type KubepatchPostgres struct {
	Image     KubepatchImage             `json:"image"`
	External  KubepatchPostgresExternal  `json:"external"`
	Databases KubepatchPostgresDatabases `json:"databases"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	PodAnnotations map[string]string `json:"podAnnotations"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
}

type KubepatchPersistence struct {
	// +optional
	StorageClassName string `json:"storageClassName"`
	Postgres         string `json:"postgres"`
	NATS             string `json:"nats"`
	B3               string `json:"b3"`
}

type KubepatchNATS struct {
	Enabled bool           `json:"enabled"`
	Image   KubepatchImage `json:"image"`
	NatsBox KubepatchImage `json:"natsBox"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
}

type KubepatchSMTP struct {
	Enabled bool `json:"enabled"`
	// +optional
	Host string `json:"host"`
	// +optional
	From string `json:"from"`
	// +optional
	Username string `json:"username"`
	// +optional
	ExistingSecret string `json:"existingSecret"`
	// +optional
	TLSEnabled bool `json:"tlsEnabled"`
}

type KubepatchB3 struct {
	Enabled      bool               `json:"enabled"`
	Image        KubepatchImage     `json:"image"`
	ReplicaCount int                `json:"replicaCount"`
	AppName      string             `json:"appName"`
	RunMode      string             `json:"runMode"`
	LogLevel     string             `json:"logLevel"`
	Session      KubepatchB3Session `json:"session"`
	Cache        KubepatchB3Cache   `json:"cache"`
	IAM          KubepatchB3IAM     `json:"iam"`
	SMTP         KubepatchSMTP      `json:"smtp"`
	Inbox        KubepatchB3Inbox   `json:"inbox"`
	Worker       KubepatchEnabled   `json:"worker"`
	Cadence      KubepatchB3Cadence `json:"cadence"`
	// +optional
	ExtraAppIni string `json:"extraAppIni"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	SecurityContext *core.SecurityContext `json:"securityContext"`
	// +optional
	PodAnnotations map[string]string `json:"podAnnotations"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
}

type KubepatchPatchConsole struct {
	Enabled   bool                           `json:"enabled"`
	Image     KubepatchImage                 `json:"image"`
	UI        KubepatchPatchConsoleUI        `json:"ui"`
	Hub       KubepatchPatchConsoleHub       `json:"hub"`
	AKP       KubepatchPatchConsoleAKP       `json:"akp"`
	Bootstrap KubepatchPatchConsoleBootstrap `json:"bootstrap"`
	BlobStore KubepatchPatchConsoleBlobStore `json:"blobStore"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
}

type KubepatchEnabled struct {
	Enabled bool `json:"enabled"`
}

type KubepatchCasdoorMFA struct {
	// Optional, Prompt or Required
	Rule string `json:"rule"`
}

type KubepatchCasdoorAdmin struct {
	Username    string `json:"username"`
	Email       string `json:"email"`
	DisplayName string `json:"displayName"`
}

type KubepatchPostgresExternal struct {
	Enabled bool `json:"enabled"`
	// +optional
	Host string `json:"host"`
	// +optional
	Port int `json:"port"`
	// +optional
	SSLMode string `json:"sslmode"`
}

type KubepatchPostgresDatabases struct {
	Akp          KubepatchDatabase `json:"akp"`
	PatchConsole KubepatchDatabase `json:"patchconsole"`
	Casdoor      KubepatchDatabase `json:"casdoor"`
}

type KubepatchB3Session struct {
	Provider string `json:"provider"`
	// +optional
	ProviderConfig string `json:"providerConfig"`
}

type KubepatchB3Cache struct {
	Adapter string `json:"adapter"`
	// +optional
	Host string `json:"host"`
}

type KubepatchB3IAM struct {
	Mode       string           `json:"mode"`
	Federation KubepatchEnabled `json:"federation"`
	SCIM       KubepatchEnabled `json:"scim"`
}

type KubepatchB3Inbox struct {
	// +optional
	JMAPURL string `json:"jmapURL"`
	// +optional
	WebAdminURL string `json:"webAdminURL"`
}

type KubepatchB3Cadence struct {
	// +optional
	Host     string `json:"host"`
	Port     int    `json:"port"`
	Domain   string `json:"domain"`
	TaskList string `json:"taskList"`
}

type KubepatchPatchConsoleUI struct {
	Image        KubepatchImage `json:"image"`
	ReplicaCount int            `json:"replicaCount"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
}

type KubepatchPatchConsoleService struct {
	Port int `json:"port"`
}

type KubepatchPatchConsoleHub struct {
	ReplicaCount     int                          `json:"replicaCount"`
	Service          KubepatchPatchConsoleService `json:"service"`
	ClusterDirectory string                       `json:"clusterDirectory"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	ExtraEnv []core.EnvVar `json:"extraEnv"`
}

type KubepatchPatchConsoleAKP struct {
	// +optional
	URL string `json:"url"`
	// +optional
	TokenSecret string `json:"tokenSecret"`
}

type KubepatchPatchConsoleBootstrap struct {
	Enabled      bool   `json:"enabled"`
	Organization string `json:"organization"`
}

type KubepatchPatchConsoleBlobStore struct {
	// +optional
	ExistingClaim string `json:"existingClaim"`
}

type KubepatchAkpBootstrap struct {
	Enabled bool `json:"enabled"`
}

// KubepatchUIImage is the part of a UI sub-chart's image the umbrella sets; the rest are the chart's own defaults.
type KubepatchUIImage struct {
	// +optional
	Tag string `json:"tag"`
	// +optional
	PullPolicy string `json:"pullPolicy"`
}

// KubepatchUIChart is the platform-ui or cluster-ui sub-chart; see those charts for all their values.
type KubepatchUIChart struct {
	Enabled      bool             `json:"enabled"`
	RegistryFQDN string           `json:"registryFQDN"`
	Image        KubepatchUIImage `json:"image"`
	// +optional
	LoginURL string `json:"loginURL"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// KubepatchList is a list of Kubepatches
type KubepatchList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of Kubepatch CRD objects
	Items []Kubepatch `json:"items,omitempty"`
}
