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
)

const (
	ResourceKindOfflineLicenseServer = "OfflineLicenseServer"
	ResourceOfflineLicenseServer     = "offlinelicenseserver"
	ResourceOfflineLicenseServers    = "offlinelicenseservers"
)

// OfflineLicenseServer defines the schama for OfflineLicenseServer Installer.

// +genclient
// +genclient:skipVerbs=updateStatus
// +k8s:openapi-gen=true
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// +kubebuilder:object:root=true
// +kubebuilder:resource:path=dnsproxys,singular=dnsproxy,categories={kubeops,appscode}
type OfflineLicenseServer struct {
	metav1.TypeMeta   `json:",inline,omitempty"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Spec              OfflineLicenseServerSpec `json:"spec,omitempty"`
}

// OfflineLicenseServerSpec is the schema for OfflineLicenseServer Operator values file
type OfflineLicenseServerSpec struct {
	ReplicaCount int                `json:"replicaCount"`
	Image        HelmImageReference `json:"image"`
	Geoipdb      HelmImageReference `json:"geoipdb"`
	//+optional
	ImagePullSecrets []string `json:"imagePullSecrets"`
	//+optional
	NameOverride string `json:"nameOverride"`
	//+optional
	FullnameOverride string             `json:"fullnameOverride"`
	ServiceAccount   HelmServiceAccount `json:"serviceAccount"`
	//+optional
	PodAnnotations map[string]string `json:"podAnnotations"`
	//+optional
	PodSecurityContext *core.PodSecurityContext `json:"podSecurityContext"`
	//+optional
	SecurityContext *core.SecurityContext `json:"securityContext"`
	Service         AceServiceSpec        `json:"service"`
	//+optional
	Resources   core.ResourceRequirements `json:"resources"`
	Autoscaling AutoscalingSpec           `json:"autoscaling"`
	//+optional
	NodeSelector map[string]string `json:"nodeSelector"`
	// If specified, the pod's tolerations.
	// +optional
	Tolerations []core.Toleration `json:"tolerations"`
	// If specified, the pod's scheduling constraints
	// +optional
	Affinity     *core.Affinity     `json:"affinity"`
	Ingress      AppIngress         `json:"ingress"`
	Volumes      []core.Volume      `json:"volumes"`
	VolumeMounts []core.VolumeMount `json:"volumeMounts"`
	Args         []string           `json:"args"`
	EnvVars      map[string]string  `json:"envVars"`
	// +optional
	LivenessProbe *core.Probe `json:"livenessProbe"`
	// +optional
	ReadinessProbe *core.Probe       `json:"readinessProbe"`
	PodLabels      map[string]string `json:"podLabels"`
}

type HelmImageReference struct {
	Repository string `json:"repository"`
	PullPolicy string `json:"pullPolicy"`
	Tag        string `json:"tag"`
}

type HelmServiceAccount struct {
	Create      bool              `json:"create"`
	Automount   bool              `json:"automount"`
	Annotations map[string]string `json:"annotations"`
	Name        string            `json:"name"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// OfflineLicenseServerList is a list of OfflineLicenseServers
type OfflineLicenseServerList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	// Items is a list of OfflineLicenseServer CRD objects
	Items []OfflineLicenseServer `json:"items,omitempty"`
}
