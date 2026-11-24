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

// ProductLine is the product an ace install is: AKP, or one of the lines on AKP v2.
// +kubebuilder:validation:Enum=AKP;TrustConsole;KubePatch
type ProductLine string

const (
	// ProductLineAKP is everything ace installs.
	ProductLineAKP ProductLine = "AKP"
	// ProductLineTrustConsole is the Trust Console on AKP v2 (v2_only).
	ProductLineTrustConsole ProductLine = "TrustConsole"
	// ProductLineKubePatch is the patch console on AKP v2 (v2_only).
	ProductLineKubePatch ProductLine = "KubePatch"
)

// Components are the ace sub-charts a product line enables, as the keys of the AceSpec sub-charts.
// ace refuses (templates/validate.yaml) a values file that does not fit its line.
func (p ProductLine) Components() (need, refuse []string) {
	akpOnly := []string{"kubedb-ui", "grafana", "perses", "trickster", "s3proxy", "cadence", "pgoutbox", "outbox-syncer", "platform-opscenter", "postgres-alerts", "redis-alerts"}
	switch p {
	case ProductLineTrustConsole:
		return []string{"platform-ui", "cluster-ui", "platform-api", "openfga", "trust-console-api", "trust-console-ui"},
			append(append([]string{}, akpOnly...), "patch-console-api", "patch-console-ui")
	case ProductLineKubePatch:
		return []string{"platform-ui", "cluster-ui", "platform-api", "patch-console-api", "patch-console-ui"},
			append(append([]string{}, akpOnly...), "openfga", "trust-console-api", "trust-console-ui")
	default:
		return nil, nil
	}
}

// IsV2Only tells whether the line runs AKP in b3's v2_only identity mode.
func (p ProductLine) IsV2Only() bool {
	return p == ProductLineTrustConsole || p == ProductLineKubePatch
}

// ConsoleImage is the image of a console sub-chart: registryFQDN/registry/repository:tag, a digest wins over the tag.
type ConsoleImage struct {
	Registry   string `json:"registry"`
	Repository string `json:"repository"`
	// +optional
	Tag string `json:"tag"`
	// +optional
	Digest     string `json:"digest"`
	PullPolicy string `json:"pullPolicy"`
}

// ConsoleGlobal is what a console hub reads from the parent chart's global values.
type ConsoleGlobal struct {
	Platform    ConsoleGlobalPlatform    `json:"platform"`
	Credentials ConsoleGlobalCredentials `json:"credentials"`
}

type ConsoleUiGlobal struct {
	Platform ConsoleGlobalPlatform `json:"platform"`
}

type ConsoleGlobalPlatform struct {
	Host string `json:"host"`
	// The public HTTPS port when it is not 443.
	HTTPSPort int `json:"httpsPort"`
}

type ConsoleGlobalCredentials struct {
	// +optional
	SecretName string `json:"secretName"`
}

type ConsoleService struct {
	Port int `json:"port"`
}

// ConsoleSecretKey names a key of a Secret. An empty SecretName is the chart's default Secret.
type ConsoleSecretKey struct {
	// +optional
	SecretName string `json:"secretName"`
	SecretKey  string `json:"secretKey"`
}

// ConsoleCasdoor is the hosted sign-in of a console hub.
type ConsoleCasdoor struct {
	// +optional
	Endpoint string `json:"endpoint"`
	// +optional
	PublicURL    string           `json:"publicUrl"`
	Organization string           `json:"organization"`
	Application  string           `json:"application"`
	ClientID     string           `json:"clientId"`
	ClientSecret ConsoleSecretKey `json:"clientSecret"`
}

type ConsoleDatabase struct {
	// +optional
	SecretName string `json:"secretName"`
	SecretKey  string `json:"secretKey"`
}

const (
	ResourceKindPatchConsoleApi = "PatchConsoleApi"
	ResourcePatchConsoleApi     = "patchconsoleapi"
	ResourcePatchConsoleApis    = "patchconsoleapis"
)

// PatchConsoleApi defines the schema for Patch Console API Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=patchconsoleapis,singular=patchconsoleapi,categories={kubeops,appscode}
type PatchConsoleApi struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              PatchConsoleApiSpec `json:"spec,omitempty"`
}

// PatchConsoleApiSpec is the schema for PatchConsoleApi values file
type PatchConsoleApiSpec struct {
	Global       ConsoleGlobal `json:"global"`
	ReplicaCount int           `json:"replicaCount"`
	// +optional
	RegistryFQDN string       `json:"registryFQDN"`
	Image        ConsoleImage `json:"image"`
	// +optional
	ImagePullSecrets []string `json:"imagePullSecrets"`
	// +optional
	NameOverride string `json:"nameOverride"`
	// +optional
	FullnameOverride string               `json:"fullnameOverride"`
	ServiceAccount   LocalObjectReference `json:"serviceAccount"`
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
	Affinity   *core.Affinity `json:"affinity"`
	Production bool           `json:"production"`
	// +optional
	PublicURL string             `json:"publicUrl"`
	Database  ConsoleDatabase    `json:"database"`
	IAM       PatchConsoleApiIAM `json:"iam"`
	Casdoor   ConsoleCasdoor     `json:"casdoor"`
	// +optional
	ClusterDirectory string                   `json:"clusterDirectory"`
	AKP              PatchConsoleApiAKP       `json:"akp"`
	BlobStore        PatchConsoleApiBlobStore `json:"blobStore"`
	// +optional
	ExtraEnv []core.EnvVar `json:"extraEnv"`
}

type PatchConsoleApiIAM struct {
	RootKey ConsoleSecretKey `json:"rootKey"`
}

type PatchConsoleApiAKP struct {
	// +optional
	URL string `json:"url"`
	// +optional
	TokenSecret string               `json:"tokenSecret"`
	CASecret    LocalObjectReference `json:"caSecret"`
}

type PatchConsoleApiBlobStore struct {
	// +optional
	ExistingClaim string `json:"existingClaim"`
	SizeLimit     string `json:"sizeLimit"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// PatchConsoleApiList is a list of PatchConsoleApis
type PatchConsoleApiList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of PatchConsoleApi CRD objects
	Items []PatchConsoleApi `json:"items,omitempty"`
}

const (
	ResourceKindPatchConsoleUi = "PatchConsoleUi"
	ResourcePatchConsoleUi     = "patchconsoleui"
	ResourcePatchConsoleUis    = "patchconsoleuis"
)

// PatchConsoleUi defines the schema for Patch Console UI Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=patchconsoleuis,singular=patchconsoleui,categories={kubeops,appscode}
type PatchConsoleUi struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              PatchConsoleUiSpec `json:"spec,omitempty"`
}

// PatchConsoleUiSpec is the schema for PatchConsoleUi values file
type PatchConsoleUiSpec struct {
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
	FullnameOverride string               `json:"fullnameOverride"`
	ServiceAccount   LocalObjectReference `json:"serviceAccount"`
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
	Affinity  *core.Affinity          `json:"affinity"`
	Hub       PatchConsoleUiHub       `json:"hub"`
	ClusterUi PatchConsoleUiClusterUi `json:"clusterUi"`
}

type PatchConsoleUiHub struct {
	// +optional
	Service string `json:"service"`
	Port    int    `json:"port"`
}

type PatchConsoleUiClusterUi struct {
	Enabled bool `json:"enabled"`
	// +optional
	BaseURL       string `json:"baseUrl"`
	CveReportPath string `json:"cveReportPath"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// PatchConsoleUiList is a list of PatchConsoleUis
type PatchConsoleUiList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of PatchConsoleUi CRD objects
	Items []PatchConsoleUi `json:"items,omitempty"`
}

const (
	ResourceKindTrustConsoleApi = "TrustConsoleApi"
	ResourceTrustConsoleApi     = "trustconsoleapi"
	ResourceTrustConsoleApis    = "trustconsoleapis"
)

// TrustConsoleApi defines the schema for Trust Console API Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=trustconsoleapis,singular=trustconsoleapi,categories={kubeops,appscode}
type TrustConsoleApi struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              TrustConsoleApiSpec `json:"spec,omitempty"`
}

// TrustConsoleApiSpec is the schema for TrustConsoleApi values file
type TrustConsoleApiSpec struct {
	Global       ConsoleGlobal `json:"global"`
	ReplicaCount int           `json:"replicaCount"`
	// +optional
	RegistryFQDN string       `json:"registryFQDN"`
	Image        ConsoleImage `json:"image"`
	// +optional
	ImagePullSecrets []string `json:"imagePullSecrets"`
	// +optional
	NameOverride string `json:"nameOverride"`
	// +optional
	FullnameOverride string               `json:"fullnameOverride"`
	ServiceAccount   LocalObjectReference `json:"serviceAccount"`
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
	Org      string         `json:"org"`
	// +optional
	PublicURL string                 `json:"publicUrl"`
	Database  ConsoleDatabase        `json:"database"`
	Casdoor   TrustConsoleApiCasdoor `json:"casdoor"`
	AppPrefix string                 `json:"appPrefix"`
	Openfga   TrustConsoleApiOpenfga `json:"openfga"`
	Valkey    TrustConsoleApiValkey  `json:"valkey"`
	// +optional
	ExtraEnv []core.EnvVar `json:"extraEnv"`
}

type TrustConsoleApiCasdoor struct {
	ConsoleCasdoor  `json:",inline"`
	CsrfKey         ConsoleSecretKey `json:"csrfKey"`
	BootstrapAdmins string           `json:"bootstrapAdmins"`
}

type TrustConsoleApiOpenfga struct {
	// +optional
	APIURL string `json:"apiUrl"`
}

type TrustConsoleApiValkey struct {
	// +optional
	Addr string `json:"addr"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// TrustConsoleApiList is a list of TrustConsoleApis
type TrustConsoleApiList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of TrustConsoleApi CRD objects
	Items []TrustConsoleApi `json:"items,omitempty"`
}

const (
	ResourceKindTrustConsoleUi = "TrustConsoleUi"
	ResourceTrustConsoleUi     = "trustconsoleui"
	ResourceTrustConsoleUis    = "trustconsoleuis"
)

// TrustConsoleUi defines the schema for Trust Console UI Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=trustconsoleuis,singular=trustconsoleui,categories={kubeops,appscode}
type TrustConsoleUi struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              TrustConsoleUiSpec `json:"spec,omitempty"`
}

// TrustConsoleUiSpec is the schema for TrustConsoleUi values file
type TrustConsoleUiSpec struct {
	ReplicaCount int `json:"replicaCount"`
	// +optional
	RegistryFQDN string       `json:"registryFQDN"`
	Image        ConsoleImage `json:"image"`
	// +optional
	ImagePullSecrets []string `json:"imagePullSecrets"`
	// +optional
	NameOverride string `json:"nameOverride"`
	// +optional
	FullnameOverride string               `json:"fullnameOverride"`
	ServiceAccount   LocalObjectReference `json:"serviceAccount"`
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
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// TrustConsoleUiList is a list of TrustConsoleUis
type TrustConsoleUiList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of TrustConsoleUi CRD objects
	Items []TrustConsoleUi `json:"items,omitempty"`
}
