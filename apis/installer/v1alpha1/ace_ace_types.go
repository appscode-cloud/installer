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
	store "kmodules.xyz/objectstore-api/api/v1"
)

const (
	ResourceKindAce = "Ace"
	ResourceAce     = "ace"
	ResourceAces    = "aces"
)

// Ace defines the schama for Ace Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=aces,singular=ace,categories={kubeops,appscode}
type Ace struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              AceSpec `json:"spec,omitempty"`
}

// AceSpec is the schema for Ace Operator values file
type AceSpec struct {
	Billing            AceBilling                `json:"billing"`
	PlatformUi         AcePlatformUi             `json:"platform-ui"`
	AccountsUi         AceAccountsUi             `json:"accounts-ui"`
	ClusterUi          AceClusterUi              `json:"cluster-ui"`
	DeployUi           AceDeployUi               `json:"deploy-ui"`
	Grafana            AceGrafana                `json:"grafana"`
	KubedbUi           AceKubedbUi               `json:"kubedb-ui"`
	MarketplaceUi      AceMarketplaceUi          `json:"marketplace-ui"`
	PlatformApi        AcePlatformApi            `json:"platform-api"`
	PromProxy          AcePromProxy              `json:"prom-proxy"`
	IngressNginx       AceIngressNginx           `json:"ingress-nginx"`
	IngressDns         AceIngressDns             `json:"ingress-dns"`
	Nats               AceNats                   `json:"nats"`
	NatsDns            AceNatsDns                `json:"nats-dns"`
	Reloader           AceReloader               `json:"reloader"`
	Global             AceGlobalValues           `json:"global"`
	Settings           Settings                  `json:"settings"`
	Image              ImageReference            `json:"image"`
	PodAnnotations     map[string]string         `json:"podAnnotations"`
	PodSecurityContext *core.PodSecurityContext  `json:"podSecurityContext"`
	SecurityContext    *core.SecurityContext     `json:"securityContext"`
	Resources          core.ResourceRequirements `json:"resources"`
	//+optional
	NodeSelector map[string]string `json:"nodeSelector"`
	Tolerations  []core.Toleration `json:"tolerations"`
	Affinity     *core.Affinity    `json:"affinity"`
}

type AceBilling struct {
	Enabled      bool `json:"enabled"`
	*BillingSpec `json:",inline,omitempty"`
}

type AcePlatformUi struct {
	Enabled         bool `json:"enabled"`
	*PlatformUiSpec `json:",inline,omitempty"`
}

type AceAccountsUi struct {
	Enabled         bool `json:"enabled"`
	*AccountsUiSpec `json:",inline,omitempty"`
}

type AceClusterUi struct {
	Enabled        bool `json:"enabled"`
	*ClusterUiSpec `json:",inline,omitempty"`
}

type AceDeployUi struct {
	Enabled       bool `json:"enabled"`
	*DeployUiSpec `json:",inline,omitempty"`
}

type AceGrafana struct {
	Enabled      bool `json:"enabled"`
	*GrafanaSpec `json:",inline,omitempty"`
}

type AceKubedbUi struct {
	Enabled       bool `json:"enabled"`
	*KubedbUiSpec `json:",inline,omitempty"`
}

type AceMarketplaceUi struct {
	Enabled            bool `json:"enabled"`
	*MarketplaceUiSpec `json:",inline,omitempty"`
}

type AcePlatformApi struct {
	Enabled          bool `json:"enabled"`
	*PlatformApiSpec `json:",inline,omitempty"`
}

type AcePromProxy struct {
	Enabled        bool `json:"enabled"`
	*PromProxySpec `json:",inline,omitempty"`
}

type AceIngressNginx struct {
	Enabled           bool `json:"enabled"`
	*IngressNginxSpec `json:",inline,omitempty"`
}

type AceIngressDns struct {
	Enabled          bool `json:"enabled"`
	*ExternalDnsSpec `json:",inline,omitempty"`
}

type AceNats struct {
	Enabled   bool `json:"enabled"`
	*NatsSpec `json:",inline,omitempty"`
}

type AceNatsDns struct {
	Enabled          bool `json:"enabled"`
	*ExternalDnsSpec `json:",inline,omitempty"`
}

type AceReloader struct {
	Enabled       bool `json:"enabled"`
	*ReloaderSpec `json:",inline,omitempty"`
}

type AceGlobalValues struct {
	NameOverride     string                     `json:"nameOverride"`
	FullnameOverride string                     `json:"fullnameOverride"`
	Platform         AceOptionsPlatformSettings `json:"platform"`
	License          string                     `json:"license"`
	Registry         string                     `json:"registry"`
	RegistryFQDN     string                     `json:"registryFQDN"`
	ImagePullSecrets []string                   `json:"imagePullSecrets"`
	ServiceAccount   NatsServiceAccountSpec     `json:"serviceAccount"`
	Monitoring       GlobalMonitoring           `json:"monitoring"`
	Infra            PlatformInfra              `json:"infra"`
}

type GlobalMonitoring struct {
	Agent          string                   `json:"agent"`
	ServiceMonitor GlobalServiceMonitor     `json:"serviceMonitor"`
	Exporter       GlobalPrometheusExporter `json:"exporter"`
}

type GlobalServiceMonitor struct {
	Labels map[string]string `json:"labels"`
}

type GlobalPrometheusExporter struct {
	Resources core.ResourceRequirements `json:"resources"`
}

type PlatformInfra struct {
	StorageClass LocalObjectReference `json:"storageClass"`
	TLS          InfraTLS             `json:"tls"`
	DNS          InfraDns             `json:"dns"`
	Objstore     InfraObjstore        `json:"objstore"`
	Stash        InfraStash           `json:"stash"`
	Kms          InfraKms             `json:"kms"`
	Kubepack     InfraKubepack        `json:"kubepack"`
	Badger       InfraBadger          `json:"badger"`
	Invoice      InfraInvoice         `json:"invoice"`
}

// +kubebuilder:validation:Enum=ca;letsencrypt;letsencrypt-staging;external
type TLSIssuerType string

const (
	TLSIssuerTypeCA        TLSIssuerType = "ca"
	TLSIssuerTypeLE        TLSIssuerType = "letsencrypt"
	TLSIssuerTypeLEStaging TLSIssuerType = "letsencrypt-staging"
	TLSIssuerTypeExternal  TLSIssuerType = "external"
)

type InfraTLS struct {
	Issuer      TLSIssuerType `json:"issuer"`
	CA          TLSData       `json:"ca"`
	Acme        TLSIssuerAcme `json:"acme"`
	Certificate TLSData       `json:"certificate"`
}

type TLSData struct {
	Cert string `json:"cert"`
	Key  string `json:"key"`
}

type TLSIssuerAcme struct {
	Email string `json:"email"`
}

// +kubebuilder:validation:Enum=external;cloudflare;route53
type DNSProvider string

const (
	DNSProviderExternal   DNSProvider = "external"
	DNSProviderCloudflare DNSProvider = "cloudflare"
	DNSProviderRoute53    DNSProvider = "route53"
)

type InfraDns struct {
	Provider DNSProvider     `json:"provider"`
	Auth     DNSProviderAuth `json:"auth"`
}

type DNSProviderAuth struct {
	Token              string `json:"token"`
	AwsAccessKeyID     string `json:"AWS_ACCESS_KEY_ID"`
	AwsSecretAccessKey string `json:"AWS_SECRET_ACCESS_KEY"`
	AwsRegion          string `json:"AWS_REGION"`
}

// +kubebuilder:validation:Enum=gcs;s3;azure;swift
type ObjstoreProvider string

const (
	ObjstoreProviderS3    ObjstoreProvider = "s3"
	ObjstoreProviderAzure ObjstoreProvider = "azure"
	ObjstoreProviderGCS   ObjstoreProvider = "gcs"
	ObjstoreProviderSwift ObjstoreProvider = "swift"
)

type InfraObjstore struct {
	Provider  ObjstoreProvider `json:"provider"`
	Host      string           `json:"host"`
	Bucket    string           `json:"bucket"`
	MountPath string           `json:"mountPath"`
	S3        *S3              `json:"s3,omitempty"`
	Azure     *Azure           `json:"azure,omitempty"`
	GCS       *GCS             `json:"gcs,omitempty"`
	Swift     *Swift           `json:"swift,omitempty"`
}

type S3 struct {
	Spec store.S3Spec `json:"spec"`
	// +optional
	Auth *S3Auth `json:"auth,omitempty"`
}

type S3Auth struct {
	AwsAccessKeyID     string `json:"AWS_ACCESS_KEY_ID"`
	AwsSecretAccessKey string `json:"AWS_SECRET_ACCESS_KEY"`
	CaCertData         string `json:"CA_CERT_DATA"`
}

type Azure struct {
	Spec store.AzureSpec `json:"spec"`
	// +optional
	Auth *AzureAuth `json:"auth,omitempty"`
}

type AzureAuth struct {
	AzureAccountName string `json:"AZURE_ACCOUNT_NAME"`
	AzureAccountKey  string `json:"AZURE_ACCOUNT_KEY"`
}

type GCS struct {
	Spec store.GCSSpec `json:"spec"`
	// +optional
	Auth *GCSAuth `json:"auth,omitempty"`
}

type GCSAuth struct {
	GoogleProjectID             string `json:"GOOGLE_PROJECT_ID"`
	GoogleServiceAccountJSONKey string `json:"GOOGLE_SERVICE_ACCOUNT_JSON_KEY"`
}

type Swift struct {
	Spec store.SwiftSpec `json:"spec"`
	// +optional
	Auth *SwiftAuth `json:"auth,omitempty"`
}

type SwiftAuth struct {
	OsUsername          string `json:"OS_USERNAME"`
	OsPassword          string `json:"OS_PASSWORD"`
	OsRegionName        string `json:"OS_REGION_NAME"`
	OsAuthURL           string `json:"OS_AUTH_URL"`
	OsUserDomainName    string `json:"OS_USER_DOMAIN_NAME"`
	OsProjectName       string `json:"OS_PROJECT_NAME"`
	OsProjectDomainName string `json:"OS_PROJECT_DOMAIN_NAME"`
	OsTenantID          string `json:"OS_TENANT_ID"`
	OsTenantName        string `json:"OS_TENANT_NAME"`
	StAuth              string `json:"ST_AUTH"`
	StUser              string `json:"ST_USER"`
	StKey               string `json:"ST_KEY"`
	OsStorageURL        string `json:"OS_STORAGE_URL"`
	OsAuthToken         string `json:"OS_AUTH_TOKEN"`
}

type InfraStash struct {
	BackupPassword string `json:"backupPassword"`
}

type InfraKms struct {
	MasterKeyURL string `json:"masterKeyURL"`
}

type InfraKubepack struct {
	Host   string `json:"host"`
	Bucket string `json:"bucket"`
	Prefix string `json:"prefix"`
}

type InfraBadger struct {
	MountPath string `json:"mountPath"`
	Levels    int    `json:"levels"`
}

type InfraInvoice struct {
	MountPath    string `json:"mountPath"`
	Bucket       string `json:"bucket"`
	Prefix       string `json:"prefix"`
	TrackerEmail string `json:"trackerEmail"`
}

type Settings struct {
	DB               DBSettings           `json:"db"`
	Cache            CacheSettings        `json:"cache"`
	Smtp             SmtpSettings         `json:"smtp"`
	Nats             NatsSettings         `json:"nats"`
	Platform         PlatformSettings     `json:"platform"`
	Stripe           StripeSettings       `json:"stripe"`
	Security         SecuritySettings     `json:"security"`
	Searchlight      SearchlightSettings  `json:"searchlight"`
	Grafana          GrafanaSettings      `json:"grafana"`
	ClusterConnector ClusterConnectorSpec `json:"clusterConnector"`
	Contract         ContractStorage      `json:"contract"`
	Firebase         FirebaseSettings     `json:"firebase"`
}

type DBSettings struct {
	Version           string                    `json:"version"`
	DatabaseName      string                    `json:"databaseName"`
	TerminationPolicy string                    `json:"terminationPolicy"`
	Persistence       PersistenceSpec           `json:"persistence"`
	Resources         core.ResourceRequirements `json:"resources"`
	Auth              BasicAuth                 `json:"auth"`
}

type CacheSettings struct {
	CacheInterval     int                       `json:"cacheInterval"`
	Version           string                    `json:"version"`
	TerminationPolicy string                    `json:"terminationPolicy"`
	Persistence       PersistenceSpec           `json:"persistence"`
	Resources         core.ResourceRequirements `json:"resources"`
	Auth              BasicAuth                 `json:"auth"`
}

type SmtpSettings struct {
	Host            string `json:"host"`
	TlsEnabled      bool   `json:"tlsEnabled"`
	From            string `json:"from"`
	Username        string `json:"username"`
	Password        string `json:"password"`
	SubjectPrefix   string `json:"subjectPrefix"`
	SendAsPlainText bool   `json:"sendAsPlainText"`
}

type NatsSettings struct {
	ShardCount      int    `json:"shardCount"`
	Replics         int    `json:"replicas"`
	MountPath       string `json:"mountPath"`
	OperatorCreds   string `json:"operatorCreds"`
	OperatorJwt     string `json:"operatorJwt"`
	SystemCreds     string `json:"systemCreds"`
	SystemJwt       string `json:"systemJwt"`
	SystemPubKey    string `json:"systemPubKey"`
	SystemUserCreds string `json:"systemUserCreds"`
	AdminCreds      string `json:"adminCreds"`
	AdminUserCreds  string `json:"adminUserCreds"`
}

type PlatformSettings struct {
	AppName                         string  `json:"appName"`
	RunMode                         string  `json:"runMode"`
	ExperimentalFeatures            bool    `json:"experimentalFeatures"`
	ForcePrivate                    bool    `json:"forcePrivate"`
	DisableHttpGit                  bool    `json:"disableHttpGit"`
	InstallLock                     bool    `json:"installLock"`
	RepositoryUploadEnabled         bool    `json:"repositoryUploadEnabled"`
	RepositoryUploadAllowedTypes    *string `json:"repositoryUploadAllowedTypes"`
	RepositoryUploadMaxFileSize     int     `json:"repositoryUploadMaxFileSize"`
	RepositoryUploadMaxFiles        int     `json:"repositoryUploadMaxFiles"`
	ServiceEnableCaptcha            bool    `json:"serviceEnableCaptcha"`
	ServiceRegisterEmailConfirm     bool    `json:"serviceRegisterEmailConfirm"`
	ServiceDisableRegistration      bool    `json:"serviceDisableRegistration"`
	ServiceRequireSignInView        bool    `json:"serviceRequireSignInView"`
	ServiceEnableNotifyMail         bool    `json:"serviceEnableNotifyMail"`
	CookieName                      string  `json:"cookieName"`
	ServerLandingPage               string  `json:"serverLandingPage"`
	LogMode                         string  `json:"logMode"`
	LogLevel                        string  `json:"logLevel"`
	OtherShowFooterBranding         bool    `json:"otherShowFooterBranding"`
	OtherShowFooterVersion          bool    `json:"otherShowFooterVersion"`
	OtherShowFooterTemplateLoadTime bool    `json:"otherShowFooterTemplateLoadTime"`
	EnableCSRFCookieHttpOnly        bool    `json:"enableCSRFCookieHttpOnly"`
}

type StripeSettings struct {
	StripeKey      string `json:"stripeKey"`
	EndpointSecret string `json:"endpointSecret"`
}

type SearchlightSettings struct {
	Enabled           bool   `json:"enabled"`
	AlertmanagerAddr  string `json:"alertmanagerAddr"`
	QueryAddr         string `json:"queryAddr"`
	RulerAddr         string `json:"rulerAddr"`
	M3CoordinatorAddr string `json:"m3coordinatorAddr"`
}

type SecuritySettings struct {
	Oauth2JWTSecret string `json:"oauth2JWTSecret"`
	CsrfSecretKey   string `json:"csrfSecretKey"`
}

type GrafanaSettings struct {
	AppMode string `json:"appMode"`
}

type ClusterConnectorSpec struct {
	ImageReference `json:",inline,omitempty"`

	Host   string `json:"host"`
	Bucket string `json:"bucket"`
	Prefix string `json:"prefix"`
}

type ContractStorage struct {
	Bucket        string `json:"bucket"`
	Prefix        string `json:"prefix"`
	LicenseBucket string `json:"licenseBucket"`
}

type FirebaseSettings struct {
	Project  string `json:"project"`
	Database string `json:"database"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// AceList is a list of Aces
type AceList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of Ace CRD objects
	Items []Ace `json:"items,omitempty"`
}
