//go:build !ignore_autogenerated

/*
Copyright AppsCode Inc. and Contributors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Code generated by controller-gen. DO NOT EDIT.

package v1alpha1

import (
	v1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/runtime"
)

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *AceServiceSpec) DeepCopyInto(out *AceServiceSpec) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new AceServiceSpec.
func (in *AceServiceSpec) DeepCopy() *AceServiceSpec {
	if in == nil {
		return nil
	}
	out := new(AceServiceSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *AppIngress) DeepCopyInto(out *AppIngress) {
	*out = *in
	if in.Annotations != nil {
		in, out := &in.Annotations, &out.Annotations
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.Hosts != nil {
		in, out := &in.Hosts, &out.Hosts
		*out = make([]IngressHost, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
	if in.TLS != nil {
		in, out := &in.TLS, &out.TLS
		*out = make([]IngressTLS, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new AppIngress.
func (in *AppIngress) DeepCopy() *AppIngress {
	if in == nil {
		return nil
	}
	out := new(AppIngress)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *AutoscalingSpec) DeepCopyInto(out *AutoscalingSpec) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new AutoscalingSpec.
func (in *AutoscalingSpec) DeepCopy() *AutoscalingSpec {
	if in == nil {
		return nil
	}
	out := new(AutoscalingSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ContianerRef) DeepCopyInto(out *ContianerRef) {
	*out = *in
	out.ImageRef = in.ImageRef
	in.Resources.DeepCopyInto(&out.Resources)
	if in.SecurityContext != nil {
		in, out := &in.SecurityContext, &out.SecurityContext
		*out = new(v1.SecurityContext)
		(*in).DeepCopyInto(*out)
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ContianerRef.
func (in *ContianerRef) DeepCopy() *ContianerRef {
	if in == nil {
		return nil
	}
	out := new(ContianerRef)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *CoreDNSDashboard) DeepCopyInto(out *CoreDNSDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new CoreDNSDashboard.
func (in *CoreDNSDashboard) DeepCopy() *CoreDNSDashboard {
	if in == nil {
		return nil
	}
	out := new(CoreDNSDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *CustomMonitoring) DeepCopyInto(out *CustomMonitoring) {
	*out = *in
	if in.ServiceMonitor != nil {
		in, out := &in.ServiceMonitor, &out.ServiceMonitor
		*out = new(ServiceMonitorLabels)
		(*in).DeepCopyInto(*out)
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new CustomMonitoring.
func (in *CustomMonitoring) DeepCopy() *CustomMonitoring {
	if in == nil {
		return nil
	}
	out := new(CustomMonitoring)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *DashboardSpec) DeepCopyInto(out *DashboardSpec) {
	*out = *in
	out.Templatize = in.Templatize
	out.Multicluster = in.Multicluster
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new DashboardSpec.
func (in *DashboardSpec) DeepCopy() *DashboardSpec {
	if in == nil {
		return nil
	}
	out := new(DashboardSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *EASHealthcheckSpec) DeepCopyInto(out *EASHealthcheckSpec) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new EASHealthcheckSpec.
func (in *EASHealthcheckSpec) DeepCopy() *EASHealthcheckSpec {
	if in == nil {
		return nil
	}
	out := new(EASHealthcheckSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *EASMonitoring) DeepCopyInto(out *EASMonitoring) {
	*out = *in
	if in.ServiceMonitor != nil {
		in, out := &in.ServiceMonitor, &out.ServiceMonitor
		*out = new(ServiceMonitorLabels)
		(*in).DeepCopyInto(*out)
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new EASMonitoring.
func (in *EASMonitoring) DeepCopy() *EASMonitoring {
	if in == nil {
		return nil
	}
	out := new(EASMonitoring)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *EASSpec) DeepCopyInto(out *EASSpec) {
	*out = *in
	out.Healthcheck = in.Healthcheck
	out.ServingCerts = in.ServingCerts
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new EASSpec.
func (in *EASSpec) DeepCopy() *EASSpec {
	if in == nil {
		return nil
	}
	out := new(EASSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *GrafanaDashboard) DeepCopyInto(out *GrafanaDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new GrafanaDashboard.
func (in *GrafanaDashboard) DeepCopy() *GrafanaDashboard {
	if in == nil {
		return nil
	}
	out := new(GrafanaDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *GrafanaOperator) DeepCopyInto(out *GrafanaOperator) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ObjectMeta.DeepCopyInto(&out.ObjectMeta)
	in.Spec.DeepCopyInto(&out.Spec)
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new GrafanaOperator.
func (in *GrafanaOperator) DeepCopy() *GrafanaOperator {
	if in == nil {
		return nil
	}
	out := new(GrafanaOperator)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *GrafanaOperator) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *GrafanaOperatorList) DeepCopyInto(out *GrafanaOperatorList) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ListMeta.DeepCopyInto(&out.ListMeta)
	if in.Items != nil {
		in, out := &in.Items, &out.Items
		*out = make([]GrafanaOperator, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new GrafanaOperatorList.
func (in *GrafanaOperatorList) DeepCopy() *GrafanaOperatorList {
	if in == nil {
		return nil
	}
	out := new(GrafanaOperatorList)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *GrafanaOperatorList) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *GrafanaOperatorSpec) DeepCopyInto(out *GrafanaOperatorSpec) {
	*out = *in
	in.Image.DeepCopyInto(&out.Image)
	if in.ImagePullSecrets != nil {
		in, out := &in.ImagePullSecrets, &out.ImagePullSecrets
		*out = make([]string, len(*in))
		copy(*out, *in)
	}
	if in.Annotations != nil {
		in, out := &in.Annotations, &out.Annotations
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.PodAnnotations != nil {
		in, out := &in.PodAnnotations, &out.PodAnnotations
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.NodeSelector != nil {
		in, out := &in.NodeSelector, &out.NodeSelector
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.Tolerations != nil {
		in, out := &in.Tolerations, &out.Tolerations
		*out = make([]v1.Toleration, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
	if in.Affinity != nil {
		in, out := &in.Affinity, &out.Affinity
		*out = new(v1.Affinity)
		(*in).DeepCopyInto(*out)
	}
	if in.PodSecurityContext != nil {
		in, out := &in.PodSecurityContext, &out.PodSecurityContext
		*out = new(v1.PodSecurityContext)
		(*in).DeepCopyInto(*out)
	}
	in.ServiceAccount.DeepCopyInto(&out.ServiceAccount)
	out.Apiserver = in.Apiserver
	in.Monitoring.DeepCopyInto(&out.Monitoring)
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new GrafanaOperatorSpec.
func (in *GrafanaOperatorSpec) DeepCopy() *GrafanaOperatorSpec {
	if in == nil {
		return nil
	}
	out := new(GrafanaOperatorSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *HealthcheckSpec) DeepCopyInto(out *HealthcheckSpec) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new HealthcheckSpec.
func (in *HealthcheckSpec) DeepCopy() *HealthcheckSpec {
	if in == nil {
		return nil
	}
	out := new(HealthcheckSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *HostPath) DeepCopyInto(out *HostPath) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new HostPath.
func (in *HostPath) DeepCopy() *HostPath {
	if in == nil {
		return nil
	}
	out := new(HostPath)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ImageRef) DeepCopyInto(out *ImageRef) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ImageRef.
func (in *ImageRef) DeepCopy() *ImageRef {
	if in == nil {
		return nil
	}
	out := new(ImageRef)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ImageReference) DeepCopyInto(out *ImageReference) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ImageReference.
func (in *ImageReference) DeepCopy() *ImageReference {
	if in == nil {
		return nil
	}
	out := new(ImageReference)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *IngressHost) DeepCopyInto(out *IngressHost) {
	*out = *in
	if in.Paths != nil {
		in, out := &in.Paths, &out.Paths
		*out = make([]HostPath, len(*in))
		copy(*out, *in)
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new IngressHost.
func (in *IngressHost) DeepCopy() *IngressHost {
	if in == nil {
		return nil
	}
	out := new(IngressHost)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *IngressTLS) DeepCopyInto(out *IngressTLS) {
	*out = *in
	if in.Hosts != nil {
		in, out := &in.Hosts, &out.Hosts
		*out = make([]string, len(*in))
		copy(*out, *in)
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new IngressTLS.
func (in *IngressTLS) DeepCopy() *IngressTLS {
	if in == nil {
		return nil
	}
	out := new(IngressTLS)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *KubeAPIServerDashboard) DeepCopyInto(out *KubeAPIServerDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new KubeAPIServerDashboard.
func (in *KubeAPIServerDashboard) DeepCopy() *KubeAPIServerDashboard {
	if in == nil {
		return nil
	}
	out := new(KubeAPIServerDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *KubeControllerManagerDashboard) DeepCopyInto(out *KubeControllerManagerDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new KubeControllerManagerDashboard.
func (in *KubeControllerManagerDashboard) DeepCopy() *KubeControllerManagerDashboard {
	if in == nil {
		return nil
	}
	out := new(KubeControllerManagerDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *KubeEtcdDashboard) DeepCopyInto(out *KubeEtcdDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new KubeEtcdDashboard.
func (in *KubeEtcdDashboard) DeepCopy() *KubeEtcdDashboard {
	if in == nil {
		return nil
	}
	out := new(KubeEtcdDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *KubeGrafanaDashboards) DeepCopyInto(out *KubeGrafanaDashboards) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ObjectMeta.DeepCopyInto(&out.ObjectMeta)
	out.Spec = in.Spec
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new KubeGrafanaDashboards.
func (in *KubeGrafanaDashboards) DeepCopy() *KubeGrafanaDashboards {
	if in == nil {
		return nil
	}
	out := new(KubeGrafanaDashboards)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *KubeGrafanaDashboards) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *KubeGrafanaDashboardsList) DeepCopyInto(out *KubeGrafanaDashboardsList) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ListMeta.DeepCopyInto(&out.ListMeta)
	if in.Items != nil {
		in, out := &in.Items, &out.Items
		*out = make([]KubeGrafanaDashboards, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new KubeGrafanaDashboardsList.
func (in *KubeGrafanaDashboardsList) DeepCopy() *KubeGrafanaDashboardsList {
	if in == nil {
		return nil
	}
	out := new(KubeGrafanaDashboardsList)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *KubeGrafanaDashboardsList) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *KubeGrafanaDashboardsSpec) DeepCopyInto(out *KubeGrafanaDashboardsSpec) {
	*out = *in
	out.Dashboard = in.Dashboard
	out.Grafana = in.Grafana
	out.CoreDNS = in.CoreDNS
	out.KubeEtcd = in.KubeEtcd
	out.KubeAPIServer = in.KubeAPIServer
	out.KubeControllerManager = in.KubeControllerManager
	out.Kubelet = in.Kubelet
	out.KubeProxy = in.KubeProxy
	out.KubeScheduler = in.KubeScheduler
	out.NodeExporter = in.NodeExporter
	out.Prometheus = in.Prometheus
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new KubeGrafanaDashboardsSpec.
func (in *KubeGrafanaDashboardsSpec) DeepCopy() *KubeGrafanaDashboardsSpec {
	if in == nil {
		return nil
	}
	out := new(KubeGrafanaDashboardsSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *KubeProxyDashboard) DeepCopyInto(out *KubeProxyDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new KubeProxyDashboard.
func (in *KubeProxyDashboard) DeepCopy() *KubeProxyDashboard {
	if in == nil {
		return nil
	}
	out := new(KubeProxyDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *KubeSchedulerDashboard) DeepCopyInto(out *KubeSchedulerDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new KubeSchedulerDashboard.
func (in *KubeSchedulerDashboard) DeepCopy() *KubeSchedulerDashboard {
	if in == nil {
		return nil
	}
	out := new(KubeSchedulerDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *KubeletDashboard) DeepCopyInto(out *KubeletDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new KubeletDashboard.
func (in *KubeletDashboard) DeepCopy() *KubeletDashboard {
	if in == nil {
		return nil
	}
	out := new(KubeletDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *Monitoring) DeepCopyInto(out *Monitoring) {
	*out = *in
	if in.ServiceMonitor != nil {
		in, out := &in.ServiceMonitor, &out.ServiceMonitor
		*out = new(ServiceMonitorLabels)
		(*in).DeepCopyInto(*out)
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new Monitoring.
func (in *Monitoring) DeepCopy() *Monitoring {
	if in == nil {
		return nil
	}
	out := new(Monitoring)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *MonitoringOperator) DeepCopyInto(out *MonitoringOperator) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ObjectMeta.DeepCopyInto(&out.ObjectMeta)
	in.Spec.DeepCopyInto(&out.Spec)
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new MonitoringOperator.
func (in *MonitoringOperator) DeepCopy() *MonitoringOperator {
	if in == nil {
		return nil
	}
	out := new(MonitoringOperator)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *MonitoringOperator) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *MonitoringOperatorList) DeepCopyInto(out *MonitoringOperatorList) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ListMeta.DeepCopyInto(&out.ListMeta)
	if in.Items != nil {
		in, out := &in.Items, &out.Items
		*out = make([]MonitoringOperator, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new MonitoringOperatorList.
func (in *MonitoringOperatorList) DeepCopy() *MonitoringOperatorList {
	if in == nil {
		return nil
	}
	out := new(MonitoringOperatorList)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *MonitoringOperatorList) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *MonitoringOperatorSpec) DeepCopyInto(out *MonitoringOperatorSpec) {
	*out = *in
	in.Image.DeepCopyInto(&out.Image)
	if in.ImagePullSecrets != nil {
		in, out := &in.ImagePullSecrets, &out.ImagePullSecrets
		*out = make([]string, len(*in))
		copy(*out, *in)
	}
	if in.Annotations != nil {
		in, out := &in.Annotations, &out.Annotations
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.PodAnnotations != nil {
		in, out := &in.PodAnnotations, &out.PodAnnotations
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.NodeSelector != nil {
		in, out := &in.NodeSelector, &out.NodeSelector
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.Tolerations != nil {
		in, out := &in.Tolerations, &out.Tolerations
		*out = make([]v1.Toleration, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
	if in.Affinity != nil {
		in, out := &in.Affinity, &out.Affinity
		*out = new(v1.Affinity)
		(*in).DeepCopyInto(*out)
	}
	if in.PodSecurityContext != nil {
		in, out := &in.PodSecurityContext, &out.PodSecurityContext
		*out = new(v1.PodSecurityContext)
		(*in).DeepCopyInto(*out)
	}
	in.ServiceAccount.DeepCopyInto(&out.ServiceAccount)
	out.Apiserver = in.Apiserver
	in.Monitoring.DeepCopyInto(&out.Monitoring)
	out.Platform = in.Platform
	out.Rancher = in.Rancher
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new MonitoringOperatorSpec.
func (in *MonitoringOperatorSpec) DeepCopy() *MonitoringOperatorSpec {
	if in == nil {
		return nil
	}
	out := new(MonitoringOperatorSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *MulticlusterDashboard) DeepCopyInto(out *MulticlusterDashboard) {
	*out = *in
	out.Global = in.Global
	out.Etcd = in.Etcd
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new MulticlusterDashboard.
func (in *MulticlusterDashboard) DeepCopy() *MulticlusterDashboard {
	if in == nil {
		return nil
	}
	out := new(MulticlusterDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *MulticlusterEtcdDashboard) DeepCopyInto(out *MulticlusterEtcdDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new MulticlusterEtcdDashboard.
func (in *MulticlusterEtcdDashboard) DeepCopy() *MulticlusterEtcdDashboard {
	if in == nil {
		return nil
	}
	out := new(MulticlusterEtcdDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *MulticlusterGlobalDashboard) DeepCopyInto(out *MulticlusterGlobalDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new MulticlusterGlobalDashboard.
func (in *MulticlusterGlobalDashboard) DeepCopy() *MulticlusterGlobalDashboard {
	if in == nil {
		return nil
	}
	out := new(MulticlusterGlobalDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *NodeExporterDashboard) DeepCopyInto(out *NodeExporterDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new NodeExporterDashboard.
func (in *NodeExporterDashboard) DeepCopy() *NodeExporterDashboard {
	if in == nil {
		return nil
	}
	out := new(NodeExporterDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *PlatformSpec) DeepCopyInto(out *PlatformSpec) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new PlatformSpec.
func (in *PlatformSpec) DeepCopy() *PlatformSpec {
	if in == nil {
		return nil
	}
	out := new(PlatformSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *PrometheusDashboard) DeepCopyInto(out *PrometheusDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new PrometheusDashboard.
func (in *PrometheusDashboard) DeepCopy() *PrometheusDashboard {
	if in == nil {
		return nil
	}
	out := new(PrometheusDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ServiceAccountSpec) DeepCopyInto(out *ServiceAccountSpec) {
	*out = *in
	if in.Name != nil {
		in, out := &in.Name, &out.Name
		*out = new(string)
		**out = **in
	}
	if in.Annotations != nil {
		in, out := &in.Annotations, &out.Annotations
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ServiceAccountSpec.
func (in *ServiceAccountSpec) DeepCopy() *ServiceAccountSpec {
	if in == nil {
		return nil
	}
	out := new(ServiceAccountSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ServiceMonitorLabels) DeepCopyInto(out *ServiceMonitorLabels) {
	*out = *in
	if in.Labels != nil {
		in, out := &in.Labels, &out.Labels
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ServiceMonitorLabels.
func (in *ServiceMonitorLabels) DeepCopy() *ServiceMonitorLabels {
	if in == nil {
		return nil
	}
	out := new(ServiceMonitorLabels)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ServingCerts) DeepCopyInto(out *ServingCerts) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ServingCerts.
func (in *ServingCerts) DeepCopy() *ServingCerts {
	if in == nil {
		return nil
	}
	out := new(ServingCerts)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *TemplatizeDashboard) DeepCopyInto(out *TemplatizeDashboard) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new TemplatizeDashboard.
func (in *TemplatizeDashboard) DeepCopy() *TemplatizeDashboard {
	if in == nil {
		return nil
	}
	out := new(TemplatizeDashboard)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *Trickster) DeepCopyInto(out *Trickster) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ObjectMeta.DeepCopyInto(&out.ObjectMeta)
	in.Spec.DeepCopyInto(&out.Spec)
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new Trickster.
func (in *Trickster) DeepCopy() *Trickster {
	if in == nil {
		return nil
	}
	out := new(Trickster)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *Trickster) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *TricksterList) DeepCopyInto(out *TricksterList) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ListMeta.DeepCopyInto(&out.ListMeta)
	if in.Items != nil {
		in, out := &in.Items, &out.Items
		*out = make([]Trickster, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new TricksterList.
func (in *TricksterList) DeepCopy() *TricksterList {
	if in == nil {
		return nil
	}
	out := new(TricksterList)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *TricksterList) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *TricksterSidecars) DeepCopyInto(out *TricksterSidecars) {
	*out = *in
	if in.Spec != nil {
		in, out := &in.Spec, &out.Spec
		*out = make(map[string]v1.Container, len(*in))
		for key, val := range *in {
			(*out)[key] = *val.DeepCopy()
		}
	}
	if in.Volumes != nil {
		in, out := &in.Volumes, &out.Volumes
		*out = make([]v1.Volume, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new TricksterSidecars.
func (in *TricksterSidecars) DeepCopy() *TricksterSidecars {
	if in == nil {
		return nil
	}
	out := new(TricksterSidecars)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *TricksterSpec) DeepCopyInto(out *TricksterSpec) {
	*out = *in
	out.Image = in.Image
	if in.ImagePullSecrets != nil {
		in, out := &in.ImagePullSecrets, &out.ImagePullSecrets
		*out = make([]string, len(*in))
		copy(*out, *in)
	}
	in.ServiceAccount.DeepCopyInto(&out.ServiceAccount)
	if in.PodAnnotations != nil {
		in, out := &in.PodAnnotations, &out.PodAnnotations
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.PodSecurityContext != nil {
		in, out := &in.PodSecurityContext, &out.PodSecurityContext
		*out = new(v1.PodSecurityContext)
		(*in).DeepCopyInto(*out)
	}
	if in.SecurityContext != nil {
		in, out := &in.SecurityContext, &out.SecurityContext
		*out = new(v1.SecurityContext)
		(*in).DeepCopyInto(*out)
	}
	out.Service = in.Service
	in.Resources.DeepCopyInto(&out.Resources)
	out.Autoscaling = in.Autoscaling
	if in.NodeSelector != nil {
		in, out := &in.NodeSelector, &out.NodeSelector
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.Tolerations != nil {
		in, out := &in.Tolerations, &out.Tolerations
		*out = make([]v1.Toleration, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
	if in.Affinity != nil {
		in, out := &in.Affinity, &out.Affinity
		*out = new(v1.Affinity)
		(*in).DeepCopyInto(*out)
	}
	in.Monitoring.DeepCopyInto(&out.Monitoring)
	in.Ingress.DeepCopyInto(&out.Ingress)
	in.Sidecars.DeepCopyInto(&out.Sidecars)
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new TricksterSpec.
func (in *TricksterSpec) DeepCopy() *TricksterSpec {
	if in == nil {
		return nil
	}
	out := new(TricksterSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *WebHookSpec) DeepCopyInto(out *WebHookSpec) {
	*out = *in
	out.Healthcheck = in.Healthcheck
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new WebHookSpec.
func (in *WebHookSpec) DeepCopy() *WebHookSpec {
	if in == nil {
		return nil
	}
	out := new(WebHookSpec)
	in.DeepCopyInto(out)
	return out
}
