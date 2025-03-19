package v1alpha1

const (
	ResourceKindPgOutbox = "PgOutbox"
	ResourcePgOutbox     = "pgoutbox"
	ResourcePgOutboxs    = "pgoutboxs"
)

//
//// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
//
//// +genclient
//// +genclient:skipVerbs=updateStatus
//// +k8s:openapi-gen=true
//// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
//
//// +kubebuilder:object:root=true
//// +kubebuilder:resource:path=pgoutboxs,singular=pgoutbox,categories={kubeops,appscode}
//type PgOutbox struct {
//	metav1.TypeMeta   `json:",inline,omitempty"`
//	metav1.ObjectMeta `json:"metadata,omitempty"`
//	Spec              PgOutboxSpec `json:"spec,omitempty"`
//}
//
//type PgOutboxSpec struct {
//	*apis.Config     `json:",inline"`
//	ConfigSecretName string `json:"configSecretName"`
//	NatsSecretName   string `json:"natsSecretName"`
//	NatsMountPath    string `json:"natsMountPath"`
//}
//
//// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
//
//// PgOutboxList is a list of PgOutboxes
//type PgOutboxList struct {
//	metav1.TypeMeta `json:",inline"`
//	metav1.ListMeta `json:"metadata,omitempty"`
//	// Items is a list of PgOutbox CRD objects
//	Items []PgOutbox `json:"items,omitempty"`
//}
