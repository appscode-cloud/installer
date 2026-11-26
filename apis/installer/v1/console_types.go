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

// ProductLine is the set of products an ace install runs.
// +kubebuilder:validation:Enum=AKP;TrustConsole;KubePatch;AKP_Plus
type ProductLine string

const (
	ProductLineAKP          ProductLine = "AKP"
	ProductLineTrustConsole ProductLine = "TrustConsole"
	ProductLineKubePatch    ProductLine = "KubePatch"
	// ProductLineAKPPlus is AKP, the Trust Console and the patch console behind one Casdoor sign-in.
	ProductLineAKPPlus ProductLine = "AKP_Plus"
)

// AkpMode is b3's [iam] MODE: v1_only, dual or v2_only. Empty is b3's default. No enum marker: the empty
// default must pass the values schema.
type AkpMode string

const (
	AkpModeV1Only AkpMode = "v1_only"
	AkpModeDual   AkpMode = "dual"
	AkpModeV2Only AkpMode = "v2_only"
)

func (p ProductLine) HasAKP() bool {
	return p == "" || p == ProductLineAKP || p == ProductLineAKPPlus
}

func (p ProductLine) HasTrustConsole() bool {
	return p == ProductLineTrustConsole || p == ProductLineAKPPlus
}

func (p ProductLine) HasKubePatch() bool {
	return p == ProductLineKubePatch || p == ProductLineAKPPlus
}

// AkpMode is the mode b3 runs in for this line: the requested one on AKP, v2_only on AKP_Plus (one Casdoor
// sign-in for every product), none where b3 web does not run.
func (p ProductLine) AkpMode(requested AkpMode) AkpMode {
	switch {
	case p == ProductLineAKPPlus:
		return AkpModeV2Only
	case p.HasAKP():
		return requested
	default:
		return ""
	}
}

func (p ProductLine) NeedsCasdoor(requested AkpMode) bool {
	m := p.AkpMode(requested)
	return m == AkpModeDual || m == AkpModeV2Only || p.HasTrustConsole() || p.HasKubePatch()
}

// Components are the ace sub-charts a product line needs and refuses, as the keys of the AceSpec sub-charts.
// casdoor on AKP depends on the mode: see NeedsCasdoor. ace enforces the same sets in templates/validate.yaml.
func (p ProductLine) Components() (need, refuse []string) {
	akp := []string{"platform-api", "platform-ui", "cluster-ui", "kubedb-ui", "grafana", "perses", "trickster", "s3proxy", "cadence", "pgoutbox", "outbox-syncer", "platform-opscenter", "postgres-alerts", "redis-alerts"}
	trust := []string{"trust-console-api", "trust-console-ui"}
	patch := []string{"patch-console-api", "patch-console-ui"}
	join := func(lists ...[]string) []string {
		var out []string
		for _, l := range lists {
			out = append(out, l...)
		}
		return out
	}
	switch p {
	case ProductLineTrustConsole:
		return join([]string{"casdoor", "openfga"}, trust), join(akp, patch)
	case ProductLineKubePatch:
		return join([]string{"casdoor"}, patch), join(akp, []string{"openfga"}, trust)
	case ProductLineAKPPlus:
		return join([]string{"casdoor", "openfga", "platform-api", "platform-ui", "cluster-ui"}, trust, patch), nil
	default:
		return nil, nil
	}
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
