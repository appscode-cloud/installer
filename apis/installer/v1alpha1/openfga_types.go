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
	"encoding/json"

	core "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
)

const (
	ResourceKindOpenfga = "Openfga"
	ResourceOpenfga     = "openfga"
	ResourceOpenfgas    = "openfgas"
)

// Openfga defines the schama for Openfga Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=openfgas,singular=openfga,categories={kubeops,appscode}
type Openfga struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              OpenfgaSpec `json:"spec,omitempty"`
}

type OpenfgaImageReference struct {
	Repository string `json:"repository"`
	PullPolicy string `json:"pullPolicy"`
	Tag        string `json:"tag"`
}

type OpenfgaServiceAccountSpec struct {
	Create      bool              `json:"create"`
	Annotations map[string]string `json:"annotations"`
	Name        string            `json:"name"`
}

type OpenfgaServiceSpec struct {
	Annotations map[string]string `json:"annotations"`
	Type        string            `json:"type"`
	Port        int               `json:"port"`
}

// OpenfgaSpec is the schema for Openfga Operator values file
type OpenfgaSpec struct {
	ReplicaCount                              int                             `json:"replicaCount,omitempty"`
	Image                                     OpenfgaImageReference           `json:"image,omitempty"`
	ImagePullSecrets                          []core.LocalObjectReference     `json:"imagePullSecrets,omitempty"`
	NameOverride                              string                          `json:"nameOverride,omitempty"`
	FullnameOverride                          string                          `json:"fullnameOverride,omitempty"`
	CommonLabels                              map[string]string               `json:"commonLabels,omitempty"`
	ServiceAccount                            OpenfgaServiceAccountSpec       `json:"serviceAccount,omitempty"`
	Annotations                               map[string]string               `json:"annotations,omitempty"`
	PodAnnotations                            map[string]string               `json:"podAnnotations,omitempty"`
	PodExtraLabels                            map[string]string               `json:"podExtraLabels,omitempty"`
	ExtraEnvVars                              []core.EnvVar                   `json:"extraEnvVars,omitempty"`
	ExtraVolumes                              []core.Volume                   `json:"extraVolumes,omitempty"`
	ExtraVolumeMounts                         []core.VolumeMount              `json:"extraVolumeMounts,omitempty"`
	ExtraInitContainers                       []core.Container                `json:"extraInitContainers,omitempty"`
	PodSecurityContext                        core.PodSecurityContext         `json:"podSecurityContext,omitempty"`
	SecurityContext                           core.SecurityContext            `json:"securityContext,omitempty"`
	InitContainer                             OpenfgaImageReference           `json:"initContainer,omitempty"`
	LivenessProbe                             OpenfgaProbe                    `json:"livenessProbe,omitempty"`
	ReadinessProbe                            OpenfgaProbe                    `json:"readinessProbe,omitempty"`
	StartupProbe                              OpenfgaProbe                    `json:"startupProbe,omitempty"`
	CustomLivenessProbe                       core.Probe                      `json:"customLivenessProbe,omitempty"`
	CustomReadinessProbe                      core.Probe                      `json:"customReadinessProbe,omitempty"`
	CustomStartupProbe                        core.Probe                      `json:"customStartupProbe,omitempty"`
	Service                                   OpenfgaServiceSpec              `json:"service,omitempty"`
	Telemetry                                 OpenfgaTelemetry                `json:"telemetry,omitempty"`
	Datastore                                 OpenfgaDatastore                `json:"datastore,omitempty"`
	Postgresql                                OpenfgaPostgresql               `json:"postgresql,omitempty"`
	Mysql                                     OpenfgaMysql                    `json:"mysql,omitempty"`
	Grpc                                      OpenfgaGrpc                     `json:"grpc,omitempty"`
	Http                                      OpenfgaHttp                     `json:"http,omitempty"`
	Authn                                     OpenfgaAuthn                    `json:"authn,omitempty"`
	Playground                                OpenfgaPlayground               `json:"playground,omitempty"`
	Profiler                                  OpenfgaProfiler                 `json:"profiler,omitempty"`
	Log                                       OpenfgaLog                      `json:"log,omitempty"`
	CheckQueryCache                           OpenfgaCheckQueryCache          `json:"checkQueryCache,omitempty"`
	Experimentals                             []string                        `json:"experimentals,omitempty"`
	MaxTuplesPerWrite                         *int                            `json:"maxTuplesPerWrite,omitempty"`
	MaxTypesPerAuthorizationModel             *int                            `json:"maxTypesPerAuthorizationModel,omitempty"`
	MaxAuthorizationModelSizeInBytes          *int                            `json:"maxAuthorizationModelSizeInBytes,omitempty"`
	MaxConcurrentReadsForCheck                *int                            `json:"maxConcurrentReadsForCheck,omitempty"`
	MaxConcurrentReadsForListObjects          *int                            `json:"maxConcurrentReadsForListObjects,omitempty"`
	MaxChecksPerBatchCheck                    *int                            `json:"maxChecksPerBatchCheck,omitempty"`
	MaxConcurrentChecksPerBatchCheck          *int                            `json:"maxConcurrentChecksPerBatchCheck,omitempty"`
	ChangelogHorizonOffset                    *string                         `json:"changelogHorizonOffset,omitempty"`
	ResolveNodeLimit                          *int                            `json:"resolveNodeLimit,omitempty"`
	ResolveNodeBreadthLimit                   *int                            `json:"resolveNodeBreadthLimit,omitempty"`
	ListObjectsDeadline                       *string                         `json:"listObjectsDeadline,omitempty"`
	ListObjectsMaxResults                     *int                            `json:"listObjectsMaxResults,omitempty"`
	ListUsersDeadline                         *string                         `json:"listUsersDeadline,omitempty"`
	ListUsersMaxResults                       *int                            `json:"listUsersMaxResults,omitempty"`
	RequestTimeout                            *string                         `json:"requestTimeout,omitempty"`
	MaxConcurrentReadsForListUsers            *int                            `json:"maxConcurrentReadsForListUsers,omitempty"`
	RequestDurationDatastoreQueryCountBuckets []int                           `json:"requestDurationDatastoreQueryCountBuckets,omitempty"`
	AllowWriting10Models                      *string                         `json:"allowWriting1_0Models,omitempty"`
	AllowEvaluating10Models                   *string                         `json:"allowEvaluating1_0Models,omitempty"`
	Ingress                                   AppIngress                      `json:"ingress,omitempty"`
	Resources                                 core.ResourceRequirements       `json:"resources,omitempty"`
	Autoscaling                               AutoscalingSpec                 `json:"autoscaling,omitempty"`
	NodeSelector                              map[string]string               `json:"nodeSelector,omitempty"`
	Tolerations                               []core.Toleration               `json:"tolerations,omitempty"`
	TopologySpreadConstraints                 []core.TopologySpreadConstraint `json:"topologySpreadConstraints,omitempty"`
	Affinity                                  core.Affinity                   `json:"affinity,omitempty"`
	Lifecycle                                 core.Lifecycle                  `json:"lifecycle,omitempty"`
	Sidecars                                  []core.Container                `json:"sidecars,omitempty"`
	Migrate                                   OpenfgaMigrate                  `json:"migrate,omitempty"`
	TestContainerSpec                         *runtime.RawExtension           `json:"testContainerSpec,omitempty"`
	TestPodSpec                               *runtime.RawExtension           `json:"testPodSpec,omitempty"`
	ExtraObjects                              []runtime.RawExtension          `json:"extraObjects,omitempty"`
}
type OpenfgaProbe struct {
	Enabled    bool `json:"enabled"`
	core.Probe `json:",inline,omitempty"`
}

type OpenfgaTelemetry struct {
	Trace   OpenfgaTrace   `json:"trace"`
	Metrics OpenfgaMetrics `json:"metrics"`
}

type OpenfgaMetrics struct {
	Enabled             bool                  `json:"enabled"`
	ServiceMonitor      OpenfgaServiceMonitor `json:"serviceMonitor"`
	Addr                string                `json:"addr"`
	EnableRPCHistograms *bool                 `json:"enableRPCHistograms"`
	PodAnnotations      map[string]string     `json:"podAnnotations"`
}

type OpenfgaServiceMonitor struct {
	Enabled           bool                   `json:"enabled"`
	AdditionalLabels  map[string]string      `json:"additionalLabels"`
	Annotations       map[string]string      `json:"annotations"`
	JobLabel          string                 `json:"jobLabel"`
	Namespace         string                 `json:"namespace"`
	NamespaceSelector map[string]string      `json:"namespaceSelector"`
	ScrapeInterval    string                 `json:"scrapeInterval"`
	ScrapeTimeout     string                 `json:"scrapeTimeout"`
	TargetLabels      []runtime.RawExtension `json:"targetLabels"`
	Relabelings       []runtime.RawExtension `json:"relabelings"`
	MetricRelabelings []runtime.RawExtension `json:"metricRelabelings"`
}

type OpenfgaOltp struct {
	Endpoint *string        `json:"endpoint"`
	Tls      OpenfgaOltpTls `json:"tls"`
}

type OpenfgaOltpTls struct {
	Enabled bool `json:"enabled"`
}

type OpenfgaTrace struct {
	Enabled     bool         `json:"enabled"`
	Otlp        OpenfgaOltp  `json:"otlp"`
	SampleRatio *json.Number `json:"sampleRatio"`
}

type OpenfgaDatastore struct {
	Engine            string                     `json:"engine,omitempty"`
	Uri               *string                    `json:"uri,omitempty"`
	UriSecret         *string                    `json:"uriSecret,omitempty"`
	Username          *string                    `json:"username,omitempty"`
	Password          *string                    `json:"password,omitempty"`
	ExistingSecret    *string                    `json:"existingSecret,omitempty"`
	SecretKeys        OpenfgaDatastoreSecretKeys `json:"secretKeys,omitempty"`
	MaxCacheSize      *string                    `json:"maxCacheSize,omitempty"`
	MaxOpenConns      *string                    `json:"maxOpenConns,omitempty"`
	MaxIdleConns      *string                    `json:"maxIdleConns,omitempty"`
	ConnMaxIdleTime   *string                    `json:"connMaxIdleTime,omitempty"`
	ConnMaxLifetime   *string                    `json:"connMaxLifetime,omitempty"`
	ApplyMigrations   bool                       `json:"applyMigrations,omitempty"`
	WaitForMigrations bool                       `json:"waitForMigrations,omitempty"`
	MigrationType     string                     `json:"migrationType,omitempty"`
	Metrics           *OpenfgaDatastoreMetrics   `json:"metrics,omitempty"`
	Migrations        OpenfgaMigrations          `json:"migrations,omitempty"`
}

type OpenfgaDatastoreSecretKeys struct {
	UriKey      *string `json:"uriKey,omitempty"`
	UsernameKey *string `json:"usernameKey,omitempty"`
	PasswordKey *string `json:"passwordKey,omitempty"`
}

type OpenfgaDatastoreMetrics struct {
	Enabled bool `json:"enabled"`
}

type OpenfgaMigrations struct {
	Resources core.ResourceRequirements `json:"resources"`
	Image     OpenfgaImageReference     `json:"image"`
}

type OpenfgaPostgresql struct {
	Enabled bool `json:"enabled"`
}

type OpenfgaMysql struct {
	Enabled bool `json:"enabled"`
}

type OpenfgaGrpc struct {
	Addr string         `json:"addr"`
	Tls  OpenfgaGrpcTls `json:"tls"`
}

type OpenfgaGrpcTls struct {
	Enabled bool    `json:"enabled"`
	Cert    *string `json:"cert"`
	Key     *string `json:"key"`
	CA      *string `json:"ca"`
}

type OpenfgaHttp struct {
	Enabled            bool       `json:"enabled"`
	Addr               string     `json:"addr"`
	Tls                OpenfgaTls `json:"tls"`
	UpstreamTimeout    *string    `json:"upstreamTimeout"`
	CorsAllowedOrigins []string   `json:"corsAllowedOrigins"`
	CorsAllowedHeaders []string   `json:"corsAllowedHeaders"`
}

type OpenfgaAuthn struct {
	Method    *string          `json:"method"`
	Preshared OpenfgaPreshared `json:"preshared"`
	Oidc      OpenfgaOidc      `json:"oidc"`
}

type OpenfgaPreshared struct {
	Keys       []string `json:"keys"`
	KeysSecret *string  `json:"keysSecret"`
}

type OpenfgaOidc struct {
	Audience *string `json:"audience"`
	Issuer   *string `json:"issuer"`
}

type OpenfgaTls struct {
	Enabled bool    `json:"enabled"`
	Cert    *string `json:"cert"`
	Key     *string `json:"key"`
}

type OpenfgaPlayground struct {
	Enabled bool `json:"enabled"`
	Port    int  `json:"port"`
}

type OpenfgaProfiler struct {
	Enabled bool   `json:"enabled"`
	Addr    string `json:"addr"`
}

type OpenfgaLog struct {
	Level           string `json:"level"`
	Format          string `json:"format"`
	TimestampFormat string `json:"timestampFormat"`
}

type OpenfgaCheckQueryCache struct {
	Enabled bool    `json:"enabled"`
	Limit   *string `json:"limit"`
	Ttl     *string `json:"ttl"`
}

type OpenfgaMigrate struct {
	ExtraVolumes            []core.Volume      `json:"extraVolumes"`
	ExtraVolumeMounts       []core.VolumeMount `json:"extraVolumeMounts"`
	Sidecars                []core.Container   `json:"sidecars"`
	ExtraInitContainers     []core.Container   `json:"extraInitContainers"`
	Annotations             map[string]*string `json:"annotations"`
	Labels                  map[string]*string `json:"labels"`
	Timeout                 *string            `json:"timeout"`
	Hook                    AceHook            `json:"hook"`
	TTLSecondsAfterFinished int                `json:"ttlSecondsAfterFinished"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// OpenfgaList is a list of Openfgas
type OpenfgaList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of Openfga CRD objects
	Items []Openfga `json:"items,omitempty"`
}
