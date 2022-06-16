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
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	kubeops_installer "kubeops.dev/installer/apis/installer/v1alpha1"
)

const (
	ResourceKindOpscenterConfig = "OpscenterConfig"
	ResourceOpscenterConfig     = "opscenterconfig"
	ResourceOpscenterConfigs    = "opscenterconfigs"
)

// OpscenterConfig defines the schama for OpscenterConfig Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=opscenterconfigs,singular=opscenterconfig,categories={kubeops,appscode}
type OpscenterConfig struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              OpscenterConfigSpec `json:"spec,omitempty"`
}

// OpscenterConfigSpec is the schema for OpscenterConfig Operator values file
type OpscenterConfigSpec struct {
	NameOverride     string                      `json:"nameOverride"`
	FullnameOverride string                      `json:"fullnameOverride"`
	Global           OpscenterConfigGlobalValues `json:"global"`
	Panopticon       PanopticonSpec              `json:"panopticon"`
	UiPreset         EmbeddedUiPresetsSpec       `json:"ui-presets"`
	Grafana          GrafanaConfig               `json:"grafana"`
	Prometheus       PrometheusConfig            `json:"prometheus"`
}

type OpscenterConfigGlobalValues struct {
	License          string            `json:"license"`
	Registry         string            `json:"registry"`
	RegistryFQDN     string            `json:"registryFQDN"`
	ImagePullSecrets []string          `json:"imagePullSecrets"`
	Monitoring       ClusterMonitoring `json:"monitoring"`
}

type ClusterMonitoring struct {
	Agent          MonitoringAgent       `json:"agent"`
	ServiceMonitor *ServiceMonitorLabels `json:"serviceMonitor"`
	Alert          *ServiceMonitorLabels `json:"alert"`
}

type PanopticonSpec struct {
	Enabled                           *bool `json:"enabled"`
	*kubeops_installer.PanopticonSpec `json:",inline,omitempty"`
}

type EmbeddedUiPresetsSpec struct {
	Enabled        *bool `json:"enabled"`
	*UiPresetsSpec `json:",inline,omitempty"`
}

type GrafanaConfig struct {
	Default     bool          `json:"default"`
	URL         string        `json:"url"`
	Service     ServiceSpec   `json:"service"`
	BasicAuth   BasicAuth     `json:"basicAuth"`
	BearerToken string        `json:"bearerToken"`
	TLS         TLSConfig     `json:"tls"`
	Dashboard   DashboardSpec `json:"dashboard"`
}

type PrometheusConfig struct {
	Default     bool        `json:"default"`
	URL         string      `json:"url"`
	Service     ServiceSpec `json:"service"`
	BasicAuth   BasicAuth   `json:"basicAuth"`
	BearerToken string      `json:"bearerToken"`
	TLS         TLSConfig   `json:"tls"`
}

type ServiceSpec struct {
	Scheme    string `json:"scheme"`
	Name      string `json:"name"`
	Namespace string `json:"namespace"`
	Port      string `json:"port"`
	Path      string `json:"path"`
	Query     string `json:"query"`
}

type DashboardSpec struct {
	Datasource string `json:"datasource"`
	FolderID   int    `json:"folderID"`
}

type BasicAuth struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type TLSConfig struct {
	Ca                    string `json:"ca"`
	Cert                  string `json:"cert"`
	Key                   string `json:"key"`
	ServerName            string `json:"serverName"`
	InsecureSkipTLSVerify bool   `json:"insecureSkipTLSVerify"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// OpscenterConfigList is a list of OpscenterConfigs
type OpscenterConfigList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of OpscenterConfig CRD objects
	Items []OpscenterConfig `json:"items,omitempty"`
}
