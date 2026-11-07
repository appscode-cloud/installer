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
	v1 "go.bytebuilders.dev/installer/apis/installer/v1"

	"k8s.io/apimachinery/pkg/runtime"
	"sigs.k8s.io/yaml"
)

func TestInstallerAPIGroup(t *testing.T) {
	const group = "installer.akp.appscode.com"
	if installer.GroupName != group || v1.SchemeGroupVersion.Group != group || v1.SchemeGroupVersion.Version != "v1" {
		t.Fatalf("installer API group/version = %q, scheme group/version = %v", installer.GroupName, v1.SchemeGroupVersion)
	}
	scheme := runtime.NewScheme()
	if err := v1.AddToScheme(scheme); err != nil {
		t.Fatal(err)
	}
	for _, kind := range []string{"AceInstaller", "AkpInstaller"} {
		if !scheme.Recognizes(v1.SchemeGroupVersion.WithKind(kind)) {
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
					Group    string `json:"group"`
					Versions []struct {
						Name    string `json:"name"`
						Served  bool   `json:"served"`
						Storage bool   `json:"storage"`
					} `json:"versions"`
				} `json:"spec"`
			}
			if err := yaml.Unmarshal(data, &crd); err != nil {
				t.Fatal(err)
			}
			if crd.Spec.Group != group || crd.Metadata.Name != "akpinstallers."+group {
				t.Errorf("CRD name = %q, group = %q", crd.Metadata.Name, crd.Spec.Group)
			}
			if len(crd.Spec.Versions) != 1 || crd.Spec.Versions[0].Name != "v1" || !crd.Spec.Versions[0].Served || !crd.Spec.Versions[0].Storage {
				t.Errorf("CRD versions = %+v, want only served storage version v1", crd.Spec.Versions)
			}
		})
	}
}
