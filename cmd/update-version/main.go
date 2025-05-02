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
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"time"

	"go.bytebuilders.dev/installer/apis/installer/v1alpha1"

	"sigs.k8s.io/kustomize/kyaml/yaml"
	y2 "sigs.k8s.io/yaml"
)

type ChartMetadata struct {
	Name       string `json:"name"`
	Version    string `json:"version"`
	AppVersion string `json:"appVersion"`
}

func main() {
	dirs, err := os.ReadDir("charts")
	if err != nil {
		panic(err)
	}

	charts := map[string]string{}
	for _, chart := range dirs {
		if chart.Type() != fs.ModeDir {
			continue
		}
		name := chart.Name()

		data, err := os.ReadFile(filepath.Join("charts", name, "Chart.yaml"))
		if err != nil {
			log.Fatal(err)
		}
		var md ChartMetadata
		err = y2.Unmarshal(data, &md)
		if err != nil {
			log.Fatal(err)
		}
		charts[name] = md.Version

		if name == "ace-installer" {
			charts["kube-ui-server"] = md.Version
		}
	}

	err = process("charts/ace-installer/values.yaml", charts)
	if err != nil {
		panic(err)
	}

	err = process("charts/opscenter-features/values.yaml", charts)
	if err != nil {
		panic(err)
	}
}

func process(filename string, charts map[string]string) error {
	// Read YAML file with comments
	inputYAML, err := os.ReadFile(filename)
	if err != nil {
		return err
	}

	var spec v1alpha1.OpscenterFeaturesSpec
	err = yaml.Unmarshal(inputYAML, &spec)
	if err != nil {
		return err
	}

	obj, err := yaml.Parse(string(inputYAML))
	if err != nil {
		log.Fatalf("Failed to parse YAML: %v", err)
	}

	for name, chartVersion := range charts {
		rs, err := obj.Pipe(yaml.Lookup("helm", "releases", name))
		if err != nil {
			panic(err)
		}
		if rs != nil {
			_, err = obj.Pipe(
				yaml.Lookup("helm", "releases", name),
				yaml.SetField("version", yaml.NewScalarRNode(chartVersion)))
			if err != nil {
				log.Fatal(err)
			}
		}
	}

	// Write updated YAML to file
	err = os.WriteFile(filename, []byte(obj.MustString()), 0o644)
	if err != nil {
		return err
	}
	return nil
}

type fakeDir struct {
	name string
	cp   os.DirEntry
}

var _ os.DirEntry = &fakeDir{}

func (f fakeDir) Name() string {
	return f.name
}

func (f fakeDir) IsDir() bool {
	return f.cp.IsDir()
}

func (f fakeDir) Type() fs.FileMode {
	return f.cp.Type()
}

func (f fakeDir) Info() (fs.FileInfo, error) {
	fi, err := f.cp.Info()
	if err != nil {
		return nil, err
	}
	return &fakeFileInfo{name: f.name, cp: fi}, nil
}

type fakeFileInfo struct {
	name string
	cp   os.FileInfo
}

var _ os.FileInfo = &fakeFileInfo{}

func (f fakeFileInfo) Name() string {
	return f.name
}

func (f fakeFileInfo) Size() int64 {
	return f.cp.Size()
}

func (f fakeFileInfo) Mode() fs.FileMode {
	return f.cp.Mode()
}

func (f fakeFileInfo) ModTime() time.Time {
	return f.cp.ModTime()
}

func (f fakeFileInfo) IsDir() bool {
	return f.cp.IsDir()
}

func (f fakeFileInfo) Sys() any {
	return f.cp.Sys()
}
