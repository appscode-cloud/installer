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
	rbac "k8s.io/api/rbac/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

const (
	ResourceKindExternalDns = "ExternalDns"
	ResourceExternalDns     = "externaldns"
	ResourceExternalDnss    = "externaldnss"
)

// ExternalDns defines the schama for ExternalDns Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=externaldnss,singular=externaldns,categories={kubeops,appscode}
type ExternalDns struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              ExternalDnsSpec `json:"spec,omitempty"`
}

// ExternalDnsSpec is the schema for ExternalDns Operator values file
type ExternalDnsSpec struct {
	Image                         ExternalDnsImageReference       `json:"image"`
	ImagePullSecrets              []string                        `json:"imagePullSecrets"`
	NameOverride                  string                          `json:"nameOverride"`
	FullnameOverride              string                          `json:"fullnameOverride"`
	ServiceAccount                ExternalDnsServiceAccountSpec   `json:"serviceAccount"`
	Rbac                          ExternalDnsRbacSpec             `json:"rbac"`
	DeploymentAnnotations         map[string]string               `json:"deploymentAnnotations"`
	PodLabels                     map[string]string               `json:"podLabels"`
	PodAnnotations                map[string]string               `json:"podAnnotations"`
	ShareProcessNamespace         bool                            `json:"shareProcessNamespace"`
	PodSecurityContext            *core.PodSecurityContext        `json:"podSecurityContext"`
	SecurityContext               *core.SecurityContext           `json:"securityContext"`
	PriorityClassName             string                          `json:"priorityClassName"`
	TerminationGracePeriodSeconds *int64                          `json:"terminationGracePeriodSeconds"`
	ServiceMonitor                ExternalDnsServiceMonitorSpec   `json:"serviceMonitor"`
	Env                           []core.EnvVar                   `json:"env"`
	LivenessProbe                 *core.Probe                     `json:"livenessProbe"`
	ReadinessProbe                *core.Probe                     `json:"readinessProbe"`
	Service                       ExternalDnsServiceSpec          `json:"service"`
	ExtraVolumes                  []core.Volume                   `json:"extraVolumes"`
	ExtraVolumeMounts             []core.VolumeMount              `json:"extraVolumeMounts"`
	Resources                     core.ResourceRequirements       `json:"resources"`
	NodeSelector                  map[string]string               `json:"nodeSelector"`
	Tolerations                   []core.Toleration               `json:"tolerations"`
	Affinity                      *core.Affinity                  `json:"affinity"`
	TopologySpreadConstraints     []core.TopologySpreadConstraint `json:"topologySpreadConstraints"`
	LogLevel                      string                          `json:"logLevel"`
	LogFormat                     string                          `json:"logFormat"`
	Interval                      string                          `json:"interval"`
	TriggerLoopOnEvent            bool                            `json:"triggerLoopOnEvent"`
	Sources                       []string                        `json:"sources"`
	Policy                        string                          `json:"policy"`
	Registry                      string                          `json:"registry"`
	TxtOwnerID                    string                          `json:"txtOwnerId"`
	TxtPrefix                     string                          `json:"txtPrefix"`
	TxtSuffix                     string                          `json:"txtSuffix"`
	DomainFilters                 []string                        `json:"domainFilters"`
	Provider                      string                          `json:"provider"`
	ExtraArgs                     []string                        `json:"extraArgs"`
}

type ExternalDnsImageReference struct {
	Repository string `json:"repository"`
	Tag        string `json:"tag"`
	PullPolicy string `json:"pullPolicy"`
}

type ExternalDnsServiceAccountSpec struct {
	Create      bool              `json:"create"`
	Annotations map[string]string `json:"annotations"`
	Name        string            `json:"name"`
}

type ExternalDnsRbacSpec struct {
	Create                bool              `json:"create"`
	AdditionalPermissions []rbac.PolicyRule `json:"additionalPermissions"`
}

type ExternalDnsServiceMonitorSpec struct {
	Enabled          bool              `json:"enabled"`
	AdditionalLabels map[string]string `json:"additionalLabels"`
	Interval         string            `json:"interval"`
	ScrapeTimeout    string            `json:"scrapeTimeout"`
}
type ExternalDnsServiceSpec struct {
	Port        int               `json:"port"`
	Annotations map[string]string `json:"annotations"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// ExternalDnsList is a list of ExternalDnss
type ExternalDnsList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of ExternalDns CRD objects
	Items []ExternalDns `json:"items,omitempty"`
}
