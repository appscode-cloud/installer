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
)

const (
	ResourceKindMonitoringConfig = "MonitoringConfig"
	ResourceMonitoringConfig     = "monitoringconfig"
	ResourceMonitoringConfigs    = "monitoringconfigs"
)

// MonitoringConfig defines the schama for MonitoringConfig Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=monitoringconfigs,singular=monitoringconfig,categories={kubeops,appscode}
type MonitoringConfig struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              MonitoringConfigSpec `json:"spec,omitempty"`
}

// MonitoringConfigSpec is the schema for MonitoringConfig Operator values file
type MonitoringConfigSpec struct {
	NameOverride     string           `json:"nameOverride"`
	FullnameOverride string           `json:"fullnameOverride"`
	Grafana          GrafanaConfig    `json:"grafana"`
	Prometheus       PrometheusConfig `json:"prometheus"`
}

type ClusterMonitoring struct {
	Agent          MonitoringAgent       `json:"agent"`
	ServiceMonitor *ServiceMonitorLabels `json:"serviceMonitor"`
	Alert          *ServiceMonitorLabels `json:"alert"`
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

// MonitoringConfigList is a list of MonitoringConfigs
type MonitoringConfigList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of MonitoringConfig CRD objects
	Items []MonitoringConfig `json:"items,omitempty"`
}
