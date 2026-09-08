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
	"k8s.io/apimachinery/pkg/runtime"
)

type CadenceImageReference struct {
	Repository string `json:"repository"`
	PullPolicy string `json:"pullPolicy"`
	Tag        string `json:"tag"`
}

type CadenceServiceSpec struct {
	Replicas                 int                       `json:"replicas"`
	Port                     int                       `json:"port"`
	GrpcPort                 int                       `json:"grpcPort"`
	Resources                core.ResourceRequirements `json:"resources"`
	NodeSelector             map[string]string         `json:"nodeSelector"`
	PodAnnotations           map[string]string         `json:"podAnnotations"`
	Affinity                 *core.Affinity            `json:"affinity"`
	Tolerations              []core.Toleration         `json:"tolerations"`
	ContainerSecurityContext *core.SecurityContext     `json:"containerSecurityContext"`
}

type CadenceWebSpec struct {
	Enabled                  bool                      `json:"enabled"`
	Image                    CadenceImageReference     `json:"image"`
	Replicas                 int                       `json:"replicas"`
	Resources                core.ResourceRequirements `json:"resources"`
	NodeSelector             map[string]string         `json:"nodeSelector"`
	ContainerSecurityContext *core.SecurityContext     `json:"containerSecurityContext"`
}

type CadenceServiceAccountSpec struct {
	Create      bool              `json:"create"`
	Annotations map[string]string `json:"annotations"`
	Name        string            `json:"name"`
}

type CadenceMetricsSpec struct {
	Enabled        bool                  `json:"enabled"`
	Port           int                   `json:"port"`
	ServiceMonitor CadenceServiceMonitor `json:"serviceMonitor"`
}

type CadenceServiceMonitor struct {
	Enabled           bool                   `json:"enabled"`
	AdditionalLabels  map[string]string      `json:"additionalLabels"`
	Annotations       map[string]string      `json:"annotations"`
	ScrapeInterval    string                 `json:"scrapeInterval"`
	Namespace         string                 `json:"namespace"`
	NamespaceSelector map[string]string      `json:"namespaceSelector"`
	TargetLabels      []runtime.RawExtension `json:"targetLabels"`
	Relabelings       []runtime.RawExtension `json:"relabelings"`
	MetricRelabelings []runtime.RawExtension `json:"metricRelabelings"`
}

// CadenceSpec is the schema for Cadence Operator values file
type CadenceSpec struct {
	NameOverride     string                    `json:"nameOverride"`
	FullnameOverride string                    `json:"fullnameOverride"`
	Global           CadenceGlobalSpec         `json:"global"`
	Frontend         CadenceServiceSpec        `json:"frontend"`
	Matching         CadenceServiceSpec        `json:"matching"`
	History          CadenceServiceSpec        `json:"history"`
	Worker           CadenceServiceSpec        `json:"worker"`
	Web              CadenceWebSpec            `json:"web"`
	ServiceAccount   CadenceServiceAccountSpec `json:"serviceAccount"`
	Metrics          CadenceMetricsSpec        `json:"metrics"`
	Cassandra        CadenceCassandraSpec      `json:"cassandra"`
	Postgresql       CadencePostgresqlSpec     `json:"postgresql"`
	Mysql            CadenceMysqlSpec          `json:"mysql"`
	Config           CadenceConfigSpec         `json:"config"`
	Schema           CadenceSchemaSpec         `json:"schema"`
}

type CadenceGlobalSpec struct {
	Image                    CadenceImageReference       `json:"image"`
	ImagePullSecrets         []core.LocalObjectReference `json:"imagePullSecrets"`
	PodSecurityContext       *core.PodSecurityContext    `json:"podSecurityContext"`
	ContainerSecurityContext *core.SecurityContext       `json:"containerSecurityContext"`
	Affinity                 *core.Affinity              `json:"affinity"`
	Tolerations              []core.Toleration           `json:"tolerations"`
	NodeSelector             map[string]string           `json:"nodeSelector"`
	Log                      CadenceLogSpec              `json:"log"`
}

type CadenceLogSpec struct {
	Stdout bool   `json:"stdout"`
	Level  string `json:"level"`
}

type CadenceCassandraSpec struct {
	Enabled  bool   `json:"enabled"`
	Hosts    string `json:"hosts"`
	Port     int    `json:"port"`
	Keyspace string `json:"keyspace"`
	User     string `json:"user"`
	Password string `json:"password"`
}

type CadencePostgresqlSpec struct {
	Enabled bool `json:"enabled"`
}

type CadenceMysqlSpec struct {
	Enabled bool `json:"enabled"`
}

type CadenceConfigSpec struct {
	Persistence CadencePersistenceSpec `json:"persistence"`
}

type CadencePersistenceSpec struct {
	NumHistoryShards int                 `json:"numHistoryShards"`
	DefaultStore     string              `json:"defaultStore"`
	VisibilityStore  string              `json:"visibilityStore"`
	Database         CadenceDatabaseSpec `json:"database"`
}

type CadenceDatabaseSpec struct {
	Driver string         `json:"driver"`
	Sql    CadenceSqlSpec `json:"sql"`
}

type CadenceSqlSpec struct {
	Hosts    string `json:"hosts"`
	Port     int    `json:"port"`
	Dbname   string `json:"dbname"`
	User     string `json:"user"`
	Password string `json:"password"`
	MaxConns int    `json:"maxConns"`
}

type CadenceSchemaSpec struct {
	ServerJob CadenceSchemaJobSpec `json:"serverJob"`
}

type CadenceSchemaJobSpec struct {
	Enabled   bool                      `json:"enabled"`
	Resources core.ResourceRequirements `json:"resources"`
}
