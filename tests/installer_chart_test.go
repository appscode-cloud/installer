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
	"bytes"
	"io/fs"
	"os"
	"path/filepath"
	"testing"

	"sigs.k8s.io/yaml"
)

func TestLegacyInstallerMatchesAKP(t *testing.T) {
	root, err := rootDir()
	if err != nil {
		t.Fatal(err)
	}
	source := filepath.Join(root, "charts", "akp-installer")
	legacy := filepath.Join(root, "charts", "ace-installer")
	files := func(dir string) map[string][]byte {
		t.Helper()
		result := make(map[string][]byte)
		err := filepath.WalkDir(dir, func(path string, entry fs.DirEntry, err error) error {
			if err != nil {
				return err
			}
			rel, err := filepath.Rel(dir, path)
			if err != nil {
				return err
			}
			if entry.IsDir() {
				if rel == "charts" {
					return filepath.SkipDir
				}
				return nil
			}
			if entry.Name() == ".DS_Store" {
				return nil
			}
			switch rel {
			case "Chart.yaml", "doc.yaml", "README.md":
				return nil
			case "akp-installer.sample.yaml":
				rel = "ace-installer.sample.yaml"
			}
			data, err := os.ReadFile(path)
			if err == nil {
				result[rel] = data
			}
			return err
		})
		if err != nil {
			t.Fatal(err)
		}
		return result
	}
	akpFiles, legacyFiles := files(source), files(legacy)
	for name, data := range akpFiles {
		if other, ok := legacyFiles[name]; !ok || !bytes.Equal(data, other) {
			t.Errorf("legacy chart differs from AKP chart: %s", name)
		}
	}
	for name := range legacyFiles {
		if _, ok := akpFiles[name]; !ok {
			t.Errorf("unexpected legacy chart file: %s", name)
		}
	}
	for _, chart := range []string{"akp-installer", "ace-installer"} {
		data, err := os.ReadFile(filepath.Join(root, "charts", chart, "Chart.yaml"))
		if err != nil {
			t.Fatal(err)
		}
		var metadata struct {
			Name        string            `json:"name"`
			Annotations map[string]string `json:"annotations"`
		}
		if err := yaml.Unmarshal(data, &metadata); err != nil {
			t.Fatal(err)
		}
		if metadata.Name != chart {
			t.Errorf("chart name = %q, want %q", metadata.Name, chart)
		}
		if got := metadata.Annotations["charts.openshift.io/name"]; got != chart {
			t.Errorf("OpenShift chart name = %q, want %q", got, chart)
		}
	}
}

func TestInstallerBootstrapIncludesBothChartNames(t *testing.T) {
	root, err := rootDir()
	if err != nil {
		t.Fatal(err)
	}
	for _, chart := range []string{"ace-installer", "akp-installer", "akp-installer-certified"} {
		t.Run(chart, func(t *testing.T) {
			docs, err := renderChart(filepath.Join(root, "charts", chart), map[string]any{}, t.TempDir())
			if err != nil {
				t.Fatal(err)
			}
			for _, doc := range docs {
				if doc["kind"] != "ClusterChartPreset" || dig(doc, "metadata", "name") != "bootstrap-presets" {
					continue
				}
				for _, name := range []string{"ace-installer", "akp-installer"} {
					if version, ok := dig(doc, "spec", "values", "helm", "releases", name, "version").(string); !ok || version == "" {
						t.Errorf("missing version for %s", name)
					}
				}
				return
			}
			t.Fatal("bootstrap-presets was not rendered")
		})
	}
}
