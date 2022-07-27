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
	openviz_installer "go.openviz.dev/installer/apis/installer/v1alpha1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	kubeops_installer "kubeops.dev/installer/apis/installer/v1alpha1"
)

const (
	ResourceKindOpscenterCore = "OpscenterCore"
	ResourceOpscenterCore     = "opscentercore"
	ResourceOpscenterCores    = "opscentercores"
)

// OpscenterCore defines the schama for ui server installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=opscentercores,singular=opscentercore,categories={kubeops,appscode}
type OpscenterCore struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              OpscenterCoreSpec `json:"spec,omitempty"`
}

// OpscenterCoreSpec is the schema for Identity Server values file
type OpscenterCoreSpec struct {
	Global                GlobalValues                   `json:"global"`
	LicenseProxyserver    EmbeddedLicenseProxyserverSpec `json:"license-proxyserver"`
	KubeUiServer          KubeUiServerSpec               `json:"kube-ui-server"`
	Supervisor            SupervisorSpec                 `json:"supervisor"`
	GrafanaOperator       GrafanaOperatorSpec            `json:"grafana-operator"`
	GrafanaUiServer       GrafanaUiServerSpec            `json:"grafana-ui-server"`
	KubeGrafanaDashboards KubeGrafanaDashboardsSpec      `json:"kube-grafana-dashboards"`
}

type GlobalValues struct {
	License          string     `json:"license"`
	Registry         string     `json:"registry"`
	RegistryFQDN     string     `json:"registryFQDN"`
	ImagePullSecrets []string   `json:"imagePullSecrets"`
	Monitoring       Monitoring `json:"monitoring"`
}

type EmbeddedLicenseProxyserverSpec struct {
	Enabled                 *bool `json:"enabled"`
	*LicenseProxyserverSpec `json:",inline,omitempty"`
}

type KubeUiServerSpec struct {
	Enabled                             *bool `json:"enabled"`
	*kubeops_installer.KubeUiServerSpec `json:",inline,omitempty"`
}

type SupervisorSpec struct {
	Enabled                           *bool `json:"enabled"`
	*kubeops_installer.SupervisorSpec `json:",inline,omitempty"`
}

type GrafanaOperatorSpec struct {
	Enabled                                *bool `json:"enabled"`
	*openviz_installer.GrafanaOperatorSpec `json:",inline,omitempty"`
}

type GrafanaUiServerSpec struct {
	Enabled                                *bool `json:"enabled"`
	*openviz_installer.GrafanaUiServerSpec `json:",inline,omitempty"`
}

type KubeGrafanaDashboardsSpec struct {
	Enabled                                      *bool `json:"enabled"`
	*openviz_installer.KubeGrafanaDashboardsSpec `json:",inline,omitempty"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// OpscenterCoreList is a list of OpscenterCores
type OpscenterCoreList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of OpscenterCore CRD objects
	Items []OpscenterCore `json:"items,omitempty"`
}
