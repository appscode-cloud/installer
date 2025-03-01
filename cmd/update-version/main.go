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

	"go.bytebuilders.dev/installer/apis/installer/v1alpha1"

	flag "github.com/spf13/pflag"
	"sigs.k8s.io/kustomize/kyaml/yaml"
)

var chartVersion = flag.String("chart.version", "v2025.3.14", "Chart version")

func main() {
	flag.Parse()

	charts, err := os.ReadDir("charts")
	if err != nil {
		panic(err)
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

func process(filename string, charts []fs.DirEntry) error {
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

	for _, chart := range charts {
		if chart.Type() != fs.ModeDir {
			continue
		}
		name := chart.Name()

		rs, err := obj.Pipe(yaml.Lookup("helm", "releases", name))
		if err != nil {
			panic(err)
		}
		if rs != nil {
			_, err = obj.Pipe(
				yaml.Lookup("helm", "releases", name),
				yaml.SetField("version", yaml.NewScalarRNode(*chartVersion)))
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
