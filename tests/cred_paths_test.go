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
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"slices"
	"strings"
	"testing"

	"go.bytebuilders.dev/installer/apis/installer/v1alpha1"

	utilyaml "k8s.io/apimachinery/pkg/util/yaml"
	"sigs.k8s.io/yaml"
)

type cred struct {
	path  string
	owner string
}

type credValues struct {
	vals      map[string]any
	sentinels map[string]cred
}

func newCredValues() *credValues {
	return &credValues{vals: map[string]any{}, sentinels: map[string]cred{}}
}

func (c *credValues) set(path string, v any) {
	keys := strings.Split(path, ".")
	cur := c.vals
	for _, k := range keys[:len(keys)-1] {
		next, ok := cur[k].(map[string]any)
		if !ok {
			next = map[string]any{}
			cur[k] = next
		}
		cur = next
	}
	cur[keys[len(keys)-1]] = v
}

// setCreds sets each path under prefix to a unique sentinel that the HelmRelease or Feature named owner must receive through valuesFrom.
func (c *credValues) setCreds(owner, prefix string, paths []string) {
	for _, p := range paths {
		s := fmt.Sprintf("cred-sentinel-%04d", len(c.sentinels))
		c.sentinels[s] = cred{path: prefix + p, owner: owner}
		c.set(prefix+p, s)
	}
}

func installerCredValues() *credValues {
	c := newCredValues()
	for _, r := range []string{"ace", "opscenter-features", "stash-presets", "service-gateway-presets"} {
		c.set("helm.releases."+r+".enabled", true)
	}
	c.setCreds("ace", "helm.releases.ace.values.", v1alpha1.ACECredPaths)
	c.setCreds("opscenter-features", "helm.releases.opscenter-features.values.", v1alpha1.OpscenterFeaturesCredPaths())
	c.setCreds("stash-presets", "helm.releases.stash-presets.values.", v1alpha1.FeatureCredPaths["stash-presets"])
	c.setCreds("service-gateway-presets", "helm.releases.service-gateway-presets.values.", v1alpha1.GatewayCredPaths)
	return c
}

func opscenterFeaturesCredValues() *credValues {
	c := newCredValues()
	for _, p := range v1alpha1.OpscenterFeaturesCredPaths() {
		owner := "opscenter-features"
		if rest, ok := strings.CutPrefix(p, "helm.releases."); ok {
			owner, _, _ = strings.Cut(rest, ".")
		}
		c.setCreds(owner, "", []string{p})
	}
	return c
}

func Test_CredsNotInReleaseValues(t *testing.T) {
	dir, err := rootDir()
	if err != nil {
		t.Fatal(err)
	}

	for chart, c := range map[string]*credValues{
		"ace-installer":           installerCredValues(),
		"ace-installer-certified": installerCredValues(),
		"opscenter-features":      opscenterFeaturesCredValues(),
	} {
		t.Run(chart, func(t *testing.T) {
			docs, err := renderChart(filepath.Join(dir, "charts", chart), c.vals, t.TempDir())
			if err != nil {
				t.Fatal(err)
			}
			for _, msg := range checkCreds(docs, c.sentinels) {
				t.Error(msg)
			}
		})
	}
}

func renderChart(chartDir string, vals map[string]any, tmpDir string) ([]map[string]any, error) {
	data, err := yaml.Marshal(vals)
	if err != nil {
		return nil, err
	}
	valuesFile := filepath.Join(tmpDir, "creds.yaml")
	if err := os.WriteFile(valuesFile, data, 0o600); err != nil {
		return nil, err
	}

	var stdout, stderr bytes.Buffer
	cmd := exec.Command("helm", "template", "cred-check", chartDir, "--namespace", "ace", "--values", valuesFile)
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		return nil, fmt.Errorf("helm template %s: %w: %s", chartDir, err, stderr.String())
	}

	var docs []map[string]any
	dec := utilyaml.NewYAMLOrJSONDecoder(&stdout, 4096)
	for {
		var doc map[string]any
		if err := dec.Decode(&doc); err != nil {
			if errors.Is(err, io.EOF) {
				return docs, nil
			}
			return nil, err
		}
		if doc != nil {
			docs = append(docs, doc)
		}
	}
}

// checkCreds reports sentinels rendered in a HelmRelease or Feature spec.values, and sentinels missing from the
// Secret keys that their owner pulls in through valuesFrom.
func checkCreds(docs []map[string]any, sentinels map[string]cred) []string {
	var msgs []string
	secrets := map[string]map[string]any{}
	refs := map[string][][2]string{}
	for _, doc := range docs {
		kind, _ := doc["kind"].(string)
		name, _ := dig(doc, "metadata", "name").(string)
		switch kind {
		case "Secret":
			data, _ := doc["stringData"].(map[string]any)
			secrets[name] = data
		case "HelmRelease", "Feature":
			raw, err := yaml.Marshal(dig(doc, "spec", "values"))
			if err != nil {
				msgs = append(msgs, fmt.Sprintf("%s/%s: %v", kind, name, err))
				continue
			}
			for _, s := range sortedKeys(sentinels) {
				if bytes.Contains(raw, []byte(s)) {
					msgs = append(msgs, fmt.Sprintf("%s/%s: raw cred %s rendered in spec.values; unset it there and pass it via valuesFrom", kind, name, sentinels[s].path))
				}
			}

			refs[name] = [][2]string{}
			from, _ := dig(doc, "spec", "valuesFrom").([]any)
			for _, f := range from {
				if m, ok := f.(map[string]any); ok && m["kind"] == "Secret" {
					refs[name] = append(refs[name], [2]string{fmt.Sprint(m["name"]), fmt.Sprint(m["valuesKey"])})
				}
			}
		}
	}

	for _, s := range sortedKeys(sentinels) {
		c := sentinels[s]
		ownerRefs, ok := refs[c.owner]
		if !ok {
			msgs = append(msgs, fmt.Sprintf("cred %s: owner HelmRelease/Feature %q not rendered", c.path, c.owner))
			continue
		}
		routed := slices.ContainsFunc(ownerRefs, func(ref [2]string) bool {
			v, _ := secrets[ref[0]][ref[1]].(string)
			return strings.Contains(v, s)
		})
		if !routed {
			msgs = append(msgs, fmt.Sprintf("cred %s is not in any Secret that %s references via valuesFrom", c.path, c.owner))
		}
	}
	return msgs
}

func dig(m map[string]any, keys ...string) any {
	var v any = m
	for _, k := range keys {
		mm, ok := v.(map[string]any)
		if !ok {
			return nil
		}
		v = mm[k]
	}
	return v
}

func sortedKeys(m map[string]cred) []string {
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	slices.Sort(keys)
	return keys
}
