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
	"go.bytebuilders.dev/installer/apis/installer"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
)

var SchemeGroupVersion = schema.GroupVersion{Group: installer.GroupName, Version: "v1alpha1"}

var (
	// TODO: move SchemeBuilder with zz_generated.deepcopy.go to k8s.io/api.
	// localSchemeBuilder and AddToScheme will stay in k8s.io/kubernetes.
	SchemeBuilder      runtime.SchemeBuilder
	localSchemeBuilder = &SchemeBuilder
	AddToScheme        = localSchemeBuilder.AddToScheme
)

func init() {
	// We only register manually written functions here. The registration of the
	// generated functions takes place in the generated files. The separation
	// makes the code compile even when the generated files are missing.
	localSchemeBuilder.Register(addKnownTypes)
}

// Kind takes an unqualified kind and returns a Group qualified GroupKind
func Kind(kind string) schema.GroupKind {
	return SchemeGroupVersion.WithKind(kind).GroupKind()
}

// Resource takes an unqualified resource and returns a Group qualified GroupResource
func Resource(resource string) schema.GroupResource {
	return SchemeGroupVersion.WithResource(resource).GroupResource()
}

// Adds the list of known types to api.Scheme.
func addKnownTypes(scheme *runtime.Scheme) error {
	scheme.AddKnownTypes(SchemeGroupVersion,
		&Acaas{},
		&AcaasList{},
		&AccountsUi{},
		&AccountsUiList{},
		&Ace{},
		&AceList{},
		&AceInstaller{},
		&AceInstallerList{},
		&Aceshifter{},
		&AceshifterList{},
		&Billing{},
		&BillingList{},
		&BillingUi{},
		&BillingUiList{},
		&CatalogManager{},
		&CatalogManagerList{},
		&CertManagerWebhookAce{},
		&CertManagerWebhookAceList{},
		&ClusterImporter{},
		&ClusterImporterList{},
		&ClusterPresets{},
		&ClusterPresetsList{},
		&ClusterUi{},
		&ClusterUiList{},
		&DeployUi{},
		&DeployUiList{},
		&DnsProxy{},
		&DnsProxyList{},
		&GhCiWebhook{},
		&GhCiWebhookList{},
		&Grafana{},
		&GrafanaList{},
		&InboxUi{},
		&InboxUiList{},
		&IngressNginx{},
		&IngressNginxList{},
		&KubedbUi{},
		&KubedbUiList{},
		&KubedbUiPresets{},
		&KubedbUiPresetsList{},
		&LicenseProxyserver{},
		&LicenseProxyserverList{},
		&LicenseProxyserverManager{},
		&LicenseProxyserverManagerList{},
		&MarketplaceApi{},
		&MarketplaceApiList{},
		&MarketplaceUi{},
		&MarketplaceUiList{},
		&Minio{},
		&MinioList{},
		&OfflineLicenseServer{},
		&OfflineLicenseServerList{},
		&OpscenterFeatures{},
		&OpscenterFeaturesList{},
		&OutboxSyncer{},
		&OutboxSyncerList{},
		&PlatformApi{},
		&PlatformApiList{},
		&PlatformLinks{},
		&PlatformLinksList{},
		&PlatformUi{},
		&PlatformUiList{},
		&Smtprelay{},
		&SmtprelayList{},
		&StashPresets{},
		&StashPresetsList{},
		&Nats{},
		&NatsList{},
		&Openfga{},
		&OpenfgaList{},
		&Reloader{},
		&ReloaderList{},
		&S3proxy{},
		&S3proxyList{},
		&ServiceGateway{},
		&ServiceGatewayList{},
		&ServiceGatewayPresets{},
		&ServiceGatewayPresetsList{},
		&ServiceProvider{},
		&ServiceProviderList{},
		&ServiceVault{},
		&ServiceVaultList{},
		&ServiceBackend{},
		&ServiceBackendList{},
		&Website{},
		&WebsiteList{},
	)

	scheme.AddKnownTypes(SchemeGroupVersion,
		&metav1.Status{},
	)
	metav1.AddToGroupVersion(scheme, SchemeGroupVersion)
	return nil
}
