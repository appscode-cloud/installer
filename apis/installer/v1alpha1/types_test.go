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
	"testing"

	"go.bytebuilders.dev/installer/apis/installer/v1alpha1"

	sc "kmodules.xyz/schema-checker"
)

func TestDefaultValues(t *testing.T) {
	checker := sc.New(os.DirFS("../../.."),
		sc.TestCase{Obj: v1alpha1.AccountsUiSpec{}},
		sc.TestCase{Obj: v1alpha1.AceSpec{}},
		sc.TestCase{Obj: v1alpha1.BillingSpec{}},
		sc.TestCase{Obj: v1alpha1.ClusterUiSpec{}},
		sc.TestCase{Obj: v1alpha1.DeployUiSpec{}},
		sc.TestCase{Obj: v1alpha1.DnsProxySpec{}},
		sc.TestCase{Obj: v1alpha1.GrafanaSpec{}},
		sc.TestCase{Obj: v1alpha1.KubedbUiSpec{}},
		sc.TestCase{Obj: v1alpha1.LicenseProxyserverSpec{}},
		sc.TestCase{Obj: v1alpha1.MarketplaceUiSpec{}},
		sc.TestCase{Obj: v1alpha1.MinioSpec{}},
		sc.TestCase{Obj: v1alpha1.OpscenterConfigSpec{}},
		sc.TestCase{Obj: v1alpha1.OpscenterCoreSpec{}},
		sc.TestCase{Obj: v1alpha1.PlatformApiSpec{}},
		sc.TestCase{Obj: v1alpha1.PlatformUiSpec{}},
		sc.TestCase{Obj: v1alpha1.PromProxySpec{}},
		sc.TestCase{Obj: v1alpha1.SmtprelaySpec{}},
		sc.TestCase{Obj: v1alpha1.UiPresetsSpec{}},
		sc.TestCase{Obj: v1alpha1.NatsSpec{}, File: "https://github.com/nats-io/k8s/raw/nats-0.17.0/helm/charts/nats/values.yaml"},
		sc.TestCase{Obj: v1alpha1.ReloaderSpec{}, File: "https://github.com/stakater/Reloader/raw/v0.0.113/deployments/kubernetes/chart/reloader/values.yaml"},
	)
	checker.TestAll(t)
}
