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
	ResourceKindTrustconsole = "Trustconsole"
	ResourceTrustconsole     = "trustconsole"
	ResourceTrustconsoles    = "trustconsoles"
)

// Trustconsole defines the schema for Trustconsole Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=trustconsoles,singular=trustconsole,categories={kubeops,appscode}
type Trustconsole struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              TrustconsoleSpec `json:"spec,omitempty"`
}

// TrustconsoleSpec is the schema for Trustconsole values file
type TrustconsoleSpec struct {
	// +optional
	Production bool               `json:"production"`
	Global     TrustconsoleGlobal `json:"global"`
	// +optional
	NameOverride string `json:"nameOverride"`
	// +optional
	FullnameOverride string                      `json:"fullnameOverride"`
	Credentials      TrustconsoleCredentials     `json:"credentials"`
	Routing          TrustconsoleRouting         `json:"routing"`
	TLS              TrustconsoleTLS             `json:"tls"`
	Casdoor          TrustconsoleCasdoor         `json:"casdoor"`
	Postgres         TrustconsolePostgres        `json:"postgres"`
	Persistence      TrustconsolePersistence     `json:"persistence"`
	NATS             TrustconsoleNATS            `json:"nats"`
	B3               TrustconsoleB3              `json:"b3"`
	TrustConsole     TrustconsoleTrustConsole    `json:"trustConsole"`
	TrustConsoleApi  TrustconsoleTrustConsoleApi `json:"trust-console-api"`
	TrustConsoleUi   TrustconsoleTrustConsoleUi  `json:"trust-console-ui"`
	OpenFGA          TrustconsoleOpenFGA         `json:"openfga"`
	Valkey           TrustconsoleValkey          `json:"valkey"`
	AkpBootstrap     TrustconsoleAkpBootstrap    `json:"akpBootstrap"`
	PlatformUI       TrustconsoleUIChart         `json:"platform-ui"`
	ClusterUI        TrustconsoleUIChart         `json:"cluster-ui"`
}

type TrustconsoleGlobal struct {
	// The Secret the sub-charts read the credentials from: credentials.existingSecret.
	// +optional
	Credentials TrustconsoleGlobalCredentials `json:"credentials"`
	Platform    TrustconsolePlatform          `json:"platform"`
	// Registry prefix for the images this chart pulls itself.
	// +optional
	ImageRegistry string `json:"imageRegistry"`
	// +optional
	ImagePullSecrets []string `json:"imagePullSecrets"`
}

type TrustconsoleGlobalCredentials struct {
	// +optional
	SecretName string `json:"secretName"`
}

type TrustconsolePlatform struct {
	// The public HTTPS port, as routing.httpsPort.
	// +optional
	HTTPSPort      int    `json:"httpsPort"`
	Host           string `json:"host"`
	HostType       string `json:"hostType"`
	DeploymentType string `json:"deploymentType"`
}

type TrustconsoleCredentials struct {
	// +optional
	ExistingSecret string `json:"existingSecret"`
}

type TrustconsoleRouting struct {
	// gateway, ingress or none
	Mode string `json:"mode"`
	// +optional
	HTTPSPort int `json:"httpsPort"`
	// +optional
	RootRedirect string                     `json:"rootRedirect"`
	Gateway      TrustconsoleRoutingGateway `json:"gateway"`
	Ingress      TrustconsoleRoutingIngress `json:"ingress"`
}

type TrustconsoleRoutingGateway struct {
	Create    bool   `json:"create"`
	ClassName string `json:"className"`
	// +optional
	Annotations map[string]string `json:"annotations"`
	// +optional
	ParentRefs []map[string]string `json:"parentRefs"`
	// The port of the Gateway listener, when it is not httpsPort.
	// +optional
	ListenerPort int `json:"listenerPort"`
	// +optional
	BackendTrafficPolicy bool `json:"backendTrafficPolicy"`
}

type TrustconsoleRoutingIngress struct {
	// +optional
	ClassName string `json:"className"`
	// +optional
	Annotations map[string]string `json:"annotations"`
}

type TrustconsoleTLS struct {
	// selfSigned, existing or none
	Mode string `json:"mode"`
	// +optional
	ExistingSecret string `json:"existingSecret"`
	// +optional
	ValidityDays int `json:"validityDays"`
}

// TrustconsoleImage is an image the chart pulls itself; a digest wins over the tag.
type TrustconsoleImage struct {
	Repository string `json:"repository"`
	Tag        string `json:"tag"`
	// +optional
	Digest string `json:"digest"`
	// +optional
	PullPolicy string `json:"pullPolicy"`
}

type TrustconsoleCasdoorApp struct {
	Name     string `json:"name"`
	ClientID string `json:"clientId"`
}

type TrustconsoleCasdoor struct {
	Enabled bool              `json:"enabled"`
	Image   TrustconsoleImage `json:"image"`
	// +optional
	Host string `json:"host"`
	// +optional
	Endpoint         string                   `json:"endpoint"`
	Organization     string                   `json:"organization"`
	AkpApplication   TrustconsoleCasdoorApp   `json:"akpApplication"`
	TrustApplication TrustconsoleCasdoorApp   `json:"trustApplication"`
	MFA              TrustconsoleCasdoorMFA   `json:"mfa"`
	Admin            TrustconsoleCasdoorAdmin `json:"admin"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	PodAnnotations map[string]string `json:"podAnnotations"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
}

type TrustconsoleDatabase struct {
	Name string `json:"name"`
	User string `json:"user"`
}

type TrustconsolePostgres struct {
	Image     TrustconsoleImage             `json:"image"`
	External  TrustconsolePostgresExternal  `json:"external"`
	Databases TrustconsolePostgresDatabases `json:"databases"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	PodAnnotations map[string]string `json:"podAnnotations"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
}

type TrustconsolePersistence struct {
	// +optional
	StorageClassName string `json:"storageClassName"`
	Postgres         string `json:"postgres"`
	NATS             string `json:"nats"`
	B3               string `json:"b3"`
}

type TrustconsoleNATS struct {
	Enabled bool              `json:"enabled"`
	Image   TrustconsoleImage `json:"image"`
	NatsBox TrustconsoleImage `json:"natsBox"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
}

type TrustconsoleSMTP struct {
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

type TrustconsoleB3 struct {
	Enabled      bool              `json:"enabled"`
	Image        TrustconsoleImage `json:"image"`
	ReplicaCount int               `json:"replicaCount"`
	AppName      string            `json:"appName"`
	RunMode      string            `json:"runMode"`
	// The site administration organization b3 dev makes.
	SiteOrganization string                `json:"siteOrganization"`
	LogLevel         string                `json:"logLevel"`
	Session          TrustconsoleB3Session `json:"session"`
	Cache            TrustconsoleB3Cache   `json:"cache"`
	IAM              TrustconsoleB3IAM     `json:"iam"`
	SMTP             TrustconsoleSMTP      `json:"smtp"`
	Inbox            TrustconsoleB3Inbox   `json:"inbox"`
	Worker           TrustconsoleEnabled   `json:"worker"`
	Cadence          TrustconsoleB3Cadence `json:"cadence"`
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

type TrustconsoleTrustConsole struct {
	// Host the browser reaches the console at. Empty: trust.<global.platform.host>. Set trust-console-api.publicUrl too.
	// +optional
	Host string `json:"host"`
}

// TrustconsoleTrustConsoleApi is the part of the trust-console-api sub-chart the umbrella sets; see that chart for
// all its values.
type TrustconsoleTrustConsoleApi struct {
	Enabled bool                        `json:"enabled"`
	Image   TrustconsoleSubChartImage   `json:"image"`
	Org     string                      `json:"org"`
	Casdoor TrustconsoleSubChartCasdoor `json:"casdoor"`
	// +optional
	ExtraEnv []core.EnvVar `json:"extraEnv"`
}

type TrustconsoleSubChartCasdoor struct {
	Organization    string `json:"organization"`
	Application     string `json:"application"`
	ClientID        string `json:"clientId"`
	BootstrapAdmins string `json:"bootstrapAdmins"`
}

// TrustconsoleSubChartImage is the part of a sub-chart's image the umbrella sets.
type TrustconsoleSubChartImage struct {
	// +optional
	Tag string `json:"tag"`
}

// TrustconsoleTrustConsoleUi is the part of the trust-console-ui sub-chart the umbrella sets; see that chart for all
// its values.
type TrustconsoleTrustConsoleUi struct {
	Enabled bool                      `json:"enabled"`
	Image   TrustconsoleSubChartImage `json:"image"`
}

// TrustconsoleOpenFGA is the authorization store of the hub.
type TrustconsoleOpenFGA struct {
	Enabled bool              `json:"enabled"`
	Image   TrustconsoleImage `json:"image"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
}

// TrustconsoleValkey holds the hub's login rate limit.
type TrustconsoleValkey struct {
	Enabled bool              `json:"enabled"`
	Image   TrustconsoleImage `json:"image"`
	// +optional
	Resources core.ResourceRequirements `json:"resources"`
	// +optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
}

type TrustconsoleEnabled struct {
	Enabled bool `json:"enabled"`
}

type TrustconsoleCasdoorMFA struct {
	// Optional, Prompt or Required
	Rule string `json:"rule"`
}

type TrustconsoleCasdoorAdmin struct {
	Username    string `json:"username"`
	Email       string `json:"email"`
	DisplayName string `json:"displayName"`
}

type TrustconsolePostgresExternal struct {
	Enabled bool `json:"enabled"`
	// +optional
	Host string `json:"host"`
	// +optional
	Port int `json:"port"`
	// +optional
	SSLMode string `json:"sslmode"`
}

type TrustconsolePostgresDatabases struct {
	Akp          TrustconsoleDatabase `json:"akp"`
	TrustConsole TrustconsoleDatabase `json:"trustconsole"`
	OpenFGA      TrustconsoleDatabase `json:"openfga"`
	Casdoor      TrustconsoleDatabase `json:"casdoor"`
}

type TrustconsoleB3Session struct {
	Provider string `json:"provider"`
	// +optional
	ProviderConfig string `json:"providerConfig"`
}

type TrustconsoleB3Cache struct {
	Adapter string `json:"adapter"`
	// +optional
	Host string `json:"host"`
}

type TrustconsoleB3IAM struct {
	Mode       string              `json:"mode"`
	Federation TrustconsoleEnabled `json:"federation"`
	SCIM       TrustconsoleEnabled `json:"scim"`
}

type TrustconsoleB3Inbox struct {
	// +optional
	JMAPURL string `json:"jmapURL"`
	// +optional
	WebAdminURL string `json:"webAdminURL"`
}

type TrustconsoleB3Cadence struct {
	// +optional
	Host     string `json:"host"`
	Port     int    `json:"port"`
	Domain   string `json:"domain"`
	TaskList string `json:"taskList"`
}

type TrustconsoleAkpBootstrap struct {
	Enabled bool `json:"enabled"`
}

// TrustconsoleUIImage is the part of a UI sub-chart's image the umbrella sets; the rest are the chart's own defaults.
type TrustconsoleUIImage struct {
	// +optional
	Tag string `json:"tag"`
	// +optional
	PullPolicy string `json:"pullPolicy"`
}

// TrustconsoleUIChart is the platform-ui or cluster-ui sub-chart; see those charts for all their values.
type TrustconsoleUIChart struct {
	Enabled      bool                `json:"enabled"`
	RegistryFQDN string              `json:"registryFQDN"`
	Image        TrustconsoleUIImage `json:"image"`
	// +optional
	LoginURL string `json:"loginURL"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// TrustconsoleList is a list of Trustconsoles
type TrustconsoleList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of Trustconsole CRD objects
	Items []Trustconsole `json:"items,omitempty"`
}
