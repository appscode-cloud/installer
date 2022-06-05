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

	schemachecker "kmodules.xyz/schema-checker"
)

func TestDefaultValues(t *testing.T) {
	checker := schemachecker.New(os.DirFS("../../.."),
		v1alpha1.AccountsUiSpec{},
		v1alpha1.BillingSpec{},
		v1alpha1.ClusterUiSpec{},
		v1alpha1.DeployUiSpec{},
		v1alpha1.GrafanaSpec{},
		v1alpha1.KubedbUiSpec{},
		v1alpha1.MarketplaceUiSpec{},
		v1alpha1.OpscenterConfigSpec{},
		v1alpha1.OpscenterCoreSpec{},
		v1alpha1.PlatformApiSpec{},
		v1alpha1.PlatformUiSpec{},
		v1alpha1.PromProxySpec{},
	)
	checker.TestAll(t)
}
