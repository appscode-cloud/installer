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

package v1alpha1_test

import (
	"os"
	"path/filepath"
	"runtime"
	"testing"

	"go.bytebuilders.dev/installer/apis/installer/v1alpha1"

	sc "kmodules.xyz/schema-checker"
	"sigs.k8s.io/yaml"
)

func TestDefaultValues(t *testing.T) {
	checker := sc.New(os.DirFS("../../.."),
		sc.TestCase{Obj: v1alpha1.AcaasSpec{}},
		sc.TestCase{Obj: v1alpha1.AccountsUiSpec{}},
		sc.TestCase{Obj: v1alpha1.AceInstallerSpec{}},
		sc.TestCase{Obj: v1alpha1.AcerproxySpec{}},
		sc.TestCase{Obj: v1alpha1.AceshifterSpec{}},
		sc.TestCase{Obj: v1alpha1.AceSpec{}},
		sc.TestCase{Obj: v1alpha1.BillingSpec{}},
		sc.TestCase{Obj: v1alpha1.BillingUiSpec{}},
		sc.TestCase{Obj: v1alpha1.CatalogManagerSpec{}},
		sc.TestCase{Obj: v1alpha1.CertManagerWebhookAceSpec{}},
		sc.TestCase{Obj: v1alpha1.ClusterImporterSpec{}},
		sc.TestCase{Obj: v1alpha1.ClusterPresetsSpec{}},
		sc.TestCase{Obj: v1alpha1.ClusterUiSpec{}},
		sc.TestCase{Obj: v1alpha1.DeployUiSpec{}},
		sc.TestCase{Obj: v1alpha1.DnsProxySpec{}},
		sc.TestCase{Obj: v1alpha1.GhCiWebhookSpec{}},
		sc.TestCase{Obj: v1alpha1.GrafanaSpec{}},
		sc.TestCase{Obj: v1alpha1.InboxUiSpec{}},
		sc.TestCase{Obj: v1alpha1.KubedbUiPresetsSpec{}},
		sc.TestCase{Obj: v1alpha1.KubedbUiSpec{}},
		sc.TestCase{Obj: v1alpha1.LicenseProxyserverManagerSpec{}},
		sc.TestCase{Obj: v1alpha1.LicenseProxyserverSpec{}},
		sc.TestCase{Obj: v1alpha1.MarketplaceApiSpec{}},
		sc.TestCase{Obj: v1alpha1.MarketplaceUiSpec{}},
		sc.TestCase{Obj: v1alpha1.MinioSpec{}},
		sc.TestCase{Obj: v1alpha1.OfflineLicenseServerSpec{}},
		sc.TestCase{Obj: v1alpha1.OpscenterFeaturesSpec{}},
		sc.TestCase{Obj: v1alpha1.OutboxSyncerSpec{}},
		sc.TestCase{Obj: v1alpha1.PlatformApiSpec{}},
		sc.TestCase{Obj: v1alpha1.PlatformLinksSpec{}},
		sc.TestCase{Obj: v1alpha1.PlatformUiSpec{}},
		sc.TestCase{Obj: v1alpha1.S3proxySpec{}},
		sc.TestCase{Obj: v1alpha1.ServiceBackendSpec{}},
		sc.TestCase{Obj: v1alpha1.ServiceGatewayPresetsSpec{}},
		sc.TestCase{Obj: v1alpha1.ServiceGatewaySpec{}},
		sc.TestCase{Obj: v1alpha1.ServiceProviderSpec{}},
		sc.TestCase{Obj: v1alpha1.ServiceVaultSpec{}},
		sc.TestCase{Obj: v1alpha1.SmtprelaySpec{}},
		sc.TestCase{Obj: v1alpha1.StashPresetsSpec{}},
		sc.TestCase{Obj: v1alpha1.WebsiteSpec{}},
		sc.TestCase{Obj: v1alpha1.NatsSpec{}, File: "https://github.com/nats-io/k8s/raw/nats-0.19.17/helm/charts/nats/values.yaml"},
		sc.TestCase{Obj: v1alpha1.OpenfgaSpec{}, File: "https://github.com/tamalsaha/openfga-helm-charts/raw/release-0.2.22/charts/openfga/values.yaml"},
		sc.TestCase{Obj: v1alpha1.ReloaderSpec{}, File: "https://github.com/stakater/Reloader/raw/v1.0.79/deployments/kubernetes/chart/reloader/values.yaml"},
	)
	checker.TestAll(t)
}

func TestOptionsJson(t *testing.T) {
	_, file, _, ok := runtime.Caller(0)
	if !ok {
		t.Fatal("failed to detect caller")
	}

	var obj v1alpha1.AceOptionsSpec
	data, err := os.ReadFile(filepath.Join(filepath.Dir(file), "../../../tests/testdata/options.old.yaml"))
	if err != nil {
		t.Fatal(err)
	}
	err = yaml.Unmarshal(data, &obj)
	if err != nil {
		t.Fatal(err)
	}
}
