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

package main

import (
	"os"
	"path/filepath"
	"testing"

	"go.bytebuilders.dev/installer/apis/installer"
	"go.bytebuilders.dev/installer/apis/installer/v1alpha1"

	"k8s.io/apimachinery/pkg/runtime"
	"sigs.k8s.io/yaml"
)

func TestInstallerAPIGroup(t *testing.T) {
	const group = "installer.akp.appscode.com"
	if installer.GroupName != group || v1alpha1.SchemeGroupVersion.Group != group {
		t.Fatalf("installer API group = %q, scheme group = %q", installer.GroupName, v1alpha1.SchemeGroupVersion.Group)
	}
	scheme := runtime.NewScheme()
	if err := v1alpha1.AddToScheme(scheme); err != nil {
		t.Fatal(err)
	}
	for _, kind := range []string{"AceInstaller", "AkpInstaller"} {
		if !scheme.Recognizes(v1alpha1.SchemeGroupVersion.WithKind(kind)) {
			t.Errorf("%s is not registered in %s", kind, group)
		}
	}

	root, err := rootDir()
	if err != nil {
		t.Fatal(err)
	}
	for _, name := range []string{
		"config/crd/bases/installer.akp.appscode.com_akpinstallers.yaml",
		"bundle/manifests/installer.akp.appscode.com_akpinstallers.yaml",
	} {
		t.Run(name, func(t *testing.T) {
			data, err := os.ReadFile(filepath.Join(root, name))
			if err != nil {
				t.Fatal(err)
			}
			var crd struct {
				Metadata struct {
					Name string `json:"name"`
				} `json:"metadata"`
				Spec struct {
					Group string `json:"group"`
				} `json:"spec"`
			}
			if err := yaml.Unmarshal(data, &crd); err != nil {
				t.Fatal(err)
			}
			if crd.Spec.Group != group || crd.Metadata.Name != "akpinstallers."+group {
				t.Errorf("CRD name = %q, group = %q", crd.Metadata.Name, crd.Spec.Group)
			}
		})
	}
}
