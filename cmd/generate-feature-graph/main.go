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
	"os"

	shell "gomodules.xyz/go-sh"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"kmodules.xyz/client-go/tools/parser"
	uiv1alpha1 "kmodules.xyz/resource-metadata/apis/ui/v1alpha1"
)

var featureGVK = schema.GroupVersionKind{
	Group:   "ui.k8s.appscode.com",
	Version: "v1alpha1",
	Kind:    "Feature",
}

type pair struct {
	A, B string
}

func main() {
	sh := shell.NewSession()
	sh.ShowCMD = true

	out, err := sh.Command("helm", "template", "charts/opscenter-features").Output()
	if err != nil {
		panic(err)
	}

	helmout, err := parser.ListResources(out)
	if err != nil {
		panic(err)
	}

	var list []pair
	for _, ri := range helmout {
		if ri.Object.GetObjectKind().GroupVersionKind() == featureGVK {
			var f uiv1alpha1.Feature
			err := runtime.DefaultUnstructuredConverter.FromUnstructured(ri.Object.UnstructuredContent(), &f)
			if err != nil {
				panic(err)
			}
			for _, req := range f.Spec.Requirements.Features {
				list = append(list, pair{
					A: f.Name,
					B: req,
				})
			}
		}
	}

	var buf bytes.Buffer
	buf.WriteString("# Feature Graph")
	buf.WriteRune('\n')
	buf.WriteRune('\n')

	buf.WriteString("```mermaid")
	buf.WriteRune('\n')

	buf.WriteString("graph TD;")
	buf.WriteRune('\n')

	for _, p := range list {
		buf.WriteString("  ")
		buf.WriteString(p.A)
		buf.WriteString("-->")
		buf.WriteString(p.B)
		buf.WriteString(";")
		buf.WriteRune('\n')
	}
	buf.WriteString("```")
	buf.WriteRune('\n')

	err = os.WriteFile("features.md", buf.Bytes(), 0o644)
	if err != nil {
		panic(err)
	}
}
