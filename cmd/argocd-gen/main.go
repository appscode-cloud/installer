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
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"github.com/spf13/pflag"
	"helm.sh/helm/v3/pkg/action"
	"helm.sh/helm/v3/pkg/chart/loader"
	"helm.sh/helm/v3/pkg/chartutil"
	"helm.sh/helm/v3/pkg/cli"
	"helm.sh/helm/v3/pkg/kube"
	"helm.sh/helm/v3/pkg/registry"
	"helm.sh/helm/v3/pkg/storage"
	"helm.sh/helm/v3/pkg/storage/driver"
	v1 "k8s.io/api/core/v1"
	"sigs.k8s.io/yaml"
)

var (
	chartName       string
	chartVersion    string
	namespace       string
	releaseName     string
	repoURL         string
	outputFile      string
	renderCount     int
	installCRDs     bool
	platformToken   string
	platformBaseURL string
	aceUserRoles    bool
)

func main() {
	pflag.StringVar(&chartName, "chart", "", "Chart name (required)")
	pflag.StringVar(&chartVersion, "version", "", "Chart version (required)")
	pflag.StringVar(&namespace, "namespace", "", "Namespace for the chart (required)")
	pflag.StringVar(&releaseName, "release-name", "", "Helm release name (default: chart name)")
	pflag.StringVar(&repoURL, "repo-url", "ghcr.io/appscode-charts", "OCI registry URL")
	pflag.StringVar(&outputFile, "output", "", "Output file (default: stdout)")
	pflag.IntVar(&renderCount, "renders", 3, "Number of times to render the chart")
	pflag.BoolVar(&installCRDs, "install-crds", false, "Set installCRDs=true in values")
	pflag.StringVar(&platformToken, "platform-token", "", "Set platform.token in values")
	pflag.StringVar(&platformBaseURL, "platform-base-url", "", "Set platform.baseURL in values")
	pflag.BoolVar(&aceUserRoles, "ace-user-roles", true, "Set ace-user-roles.enabled=false in values")

	pflag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [flags]\n\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "Generate ArgoCD Application objects for helm charts.\n")
		fmt.Fprintf(os.Stderr, "Renders the chart multiple times using Helm Go SDK, identifies fields\n")
		fmt.Fprintf(os.Stderr, "that change between renders, and generates appropriate ignoreDifferences.\n\n")
		fmt.Fprintf(os.Stderr, "Flags:\n")
		pflag.PrintDefaults()
		fmt.Fprintf(os.Stderr, "\nExample:\n")
		fmt.Fprintf(os.Stderr, "  %s --chart kubedb --version v2026.2.26 --namespace kubedb\n", os.Args[0])
	}

	pflag.Parse()

	if chartName == "" || chartVersion == "" || namespace == "" {
		pflag.Usage()
		os.Exit(1)
	}

	if releaseName == "" {
		releaseName = chartName
	}

	values := buildValuesMap()

	var manifests []string
	for i := 0; i < renderCount; i++ {
		m, err := renderChart(releaseName, namespace, values)
		if err != nil {
			log.Fatalf("Render %d failed: %v", i+1, err)
		}
		manifests = append(manifests, m)
	}

	ignoreRules := findIgnoreDifferences(manifests)
	app := generateArgoCDApp(chartName, chartVersion, namespace, ignoreRules, values)

	output, err := yaml.Marshal(app)
	if err != nil {
		log.Fatalf("Marshal failed: %v", err)
	}

	if outputFile != "" {
		if err := os.WriteFile(outputFile, output, 0o644); err != nil {
			log.Fatalf("Write failed: %v", err)
		}
		fmt.Fprintf(os.Stderr, "Generated: %s (%d rules)\n", outputFile, len(ignoreRules))
	} else {
		os.Stdout.Write(output)
		fmt.Fprintf(os.Stderr, "\n# %d ignoreDifferences rules\n", len(ignoreRules))
	}
}

// renderChart uses Helm Go SDK to pull and render a chart
// Follows https://helm.sh/docs/v3/sdk/examples/ patterns
func renderChart(relName, ns string, vals map[string]interface{}) (string, error) {
	settings := cli.New()

	// Step 1: Create OCI registry client
	registryClient, err := newRegistryClient(settings)
	if err != nil {
		return "", fmt.Errorf("registry client: %w", err)
	}

	// Step 2: Init action config with memory storage driver (no kube needed for dry-run)
	actionConfig, err := initActionConfig(settings, ns, registryClient)
	if err != nil {
		return "", fmt.Errorf("init config: %w", err)
	}

	// Step 3: Create pull client to download the chart from OCI registry
	pullClient := action.NewPullWithOpts(action.WithConfig(actionConfig))
	pullClient.Version = chartVersion
	pullClient.Settings = settings
	pullClient.SetRegistryClient(registryClient)

	tmpDir, err := os.MkdirTemp("", "helm-pull-*")
	if err != nil {
		return "", fmt.Errorf("temp dir: %w", err)
	}
	defer os.RemoveAll(tmpDir)
	pullClient.DestDir = tmpDir

	chartRef := fmt.Sprintf("oci://%s/%s", repoURL, chartName)
	if _, err := pullClient.Run(chartRef); err != nil {
		return "", fmt.Errorf("pull %s:%s: %w", chartRef, chartVersion, err)
	}

	// Step 4: Load the downloaded chart archive
	entries, err := os.ReadDir(tmpDir)
	if err != nil {
		return "", fmt.Errorf("read pull dir: %w", err)
	}
	var chartPath string
	for _, e := range entries {
		if strings.HasSuffix(e.Name(), ".tgz") {
			chartPath = filepath.Join(tmpDir, e.Name())
			break
		}
	}
	if chartPath == "" {
		return "", fmt.Errorf("no .tgz in %s after pull", tmpDir)
	}

	chart, err := loader.Load(chartPath)
	if err != nil {
		return "", fmt.Errorf("load chart: %w", err)
	}

	// Step 5: Create install client for dry-run rendering
	installClient := action.NewInstall(actionConfig)
	installClient.DryRunOption = "client"
	installClient.ReleaseName = relName
	installClient.Namespace = ns
	installClient.ClientOnly = true
	installClient.IncludeCRDs = installCRDs
	installClient.Replace = true
	installClient.SetRegistryClient(registryClient)

	// Set a modern kube version to satisfy chart version constraints
	kv, _ := chartutil.ParseKubeVersion("v1.31.0")
	installClient.KubeVersion = kv

	// Step 6: Render
	rel, err := installClient.RunWithContext(context.Background(), chart, vals)
	if err != nil {
		return "", fmt.Errorf("render: %w", err)
	}

	return rel.Manifest, nil
}

// initActionConfig initializes Helm action configuration.
// Uses memory driver so no kube cluster is needed for dry-run.
func initActionConfig(settings *cli.EnvSettings, ns string, rc *registry.Client) (*action.Configuration, error) {
	actionConfig := new(action.Configuration)

	// Use memory storage driver - stores releases in-memory only
	actionConfig.Releases = storage.Init(driver.NewMemory())

	// Minimal kube client stub for dry-run mode
	actionConfig.KubeClient = &noopKubeClient{}

	// Suppress helm logging
	actionConfig.Log = func(format string, v ...interface{}) {}

	// Attach the OCI registry client
	actionConfig.RegistryClient = rc

	return actionConfig, nil
}

// newRegistryClient creates a client for OCI registries (ghcr.io, etc.)
// Following https://helm.sh/docs/v3/sdk/examples/ patterns
func newRegistryClient(settings *cli.EnvSettings) (*registry.Client, error) {
	opts := []registry.ClientOption{
		registry.ClientOptDebug(settings.Debug),
		registry.ClientOptEnableCache(true),
		registry.ClientOptWriter(os.Stderr),
		registry.ClientOptCredentialsFile(settings.RegistryConfig),
	}
	return registry.NewClient(opts...)
}

// noopKubeClient implements kube.Interface for dry-run mode.
// All methods are no-ops since we only need template rendering.
type noopKubeClient struct{}

func (c *noopKubeClient) Create(resources kube.ResourceList) (*kube.Result, error) {
	return &kube.Result{Created: resources}, nil
}

func (c *noopKubeClient) Wait(resources kube.ResourceList, timeout time.Duration) error {
	return nil
}

func (c *noopKubeClient) WaitWithJobs(resources kube.ResourceList, timeout time.Duration) error {
	return nil
}

func (c *noopKubeClient) Delete(resources kube.ResourceList) (*kube.Result, []error) {
	return &kube.Result{Deleted: resources}, nil
}

func (c *noopKubeClient) WatchUntilReady(resources kube.ResourceList, timeout time.Duration) error {
	return nil
}

func (c *noopKubeClient) Update(original, target kube.ResourceList, force bool) (*kube.Result, error) {
	return &kube.Result{Updated: target}, nil
}

func (c *noopKubeClient) Build(reader io.Reader, validate bool) (kube.ResourceList, error) {
	return kube.ResourceList{}, nil
}

func (c *noopKubeClient) WaitAndGetCompletedPodPhase(name string, timeout time.Duration) (v1.PodPhase, error) {
	return v1.PodSucceeded, nil
}

func (c *noopKubeClient) IsReachable() error {
	return nil
}

// Resource represents a parsed Kubernetes resource
type Resource struct {
	APIVersion string                 `json:"apiVersion"`
	Kind       string                 `json:"kind"`
	Metadata   map[string]interface{} `json:"metadata"`
	Spec       interface{}            `json:"spec,omitempty"`
	Data       interface{}            `json:"data,omitempty"`
	Raw        map[string]interface{} `json:"-"`
}

func (r *Resource) Group() string {
	parts := strings.SplitN(r.APIVersion, "/", 2)
	if len(parts) == 1 {
		return ""
	}
	return parts[0]
}

func (r *Resource) Version() string {
	parts := strings.SplitN(r.APIVersion, "/", 2)
	if len(parts) == 1 {
		return parts[0]
	}
	return parts[1]
}

func (r *Resource) Name() string {
	if n, ok := r.Metadata["name"].(string); ok {
		return n
	}
	return ""
}

func (r *Resource) NS() string {
	if n, ok := r.Metadata["namespace"].(string); ok {
		return n
	}
	return ""
}

func (r *Resource) Key() string {
	return fmt.Sprintf("%s/%s/%s/%s", r.Group(), r.Kind, r.NS(), r.Name())
}

func parseResources(rendered string) map[string]*Resource {
	resources := make(map[string]*Resource)
	docs := strings.Split(rendered, "---")

	for _, doc := range docs {
		doc = strings.TrimSpace(doc)
		if doc == "" || strings.HasPrefix(doc, "---") {
			continue
		}

		var raw map[string]interface{}
		if err := yaml.Unmarshal([]byte(doc), &raw); err != nil {
			continue
		}

		res := &Resource{Raw: raw}
		res.APIVersion, _ = raw["apiVersion"].(string)
		res.Kind, _ = raw["kind"].(string)
		res.Metadata, _ = raw["metadata"].(map[string]interface{})
		res.Spec = raw["spec"]
		res.Data = raw["data"]

		if res.Kind == "" || res.Name() == "" {
			continue
		}

		resources[res.Key()] = res
	}

	return resources
}

func diffResources(a, b *Resource) []string {
	var diffs []string

	if !deepEqualJSON(a.Data, b.Data) {
		if a.Kind == "Secret" {
			if isCertificateData(a.Data) || isCertificateData(b.Data) {
				diffs = append(diffs, "/data")
			}
		}
	}

	diffs = append(diffs, diffAnnotations(a.Metadata, b.Metadata)...)

	if a.Kind == "MutatingWebhookConfiguration" || a.Kind == "ValidatingWebhookConfiguration" {
		if hasWebhookCaBundleDiff(a.Raw, b.Raw) {
			diffs = append(diffs, "/webhooks[].clientConfig.caBundle")
		}
	}

	if a.Kind == "APIService" {
		if hasAPICaBundleDiff(a.Spec, b.Spec) {
			diffs = append(diffs, "/spec/caBundle")
		}
	}

	if a.Kind == "Deployment" || a.Kind == "StatefulSet" {
		diffs = append(diffs, diffTemplateAnnotations(a.Spec, b.Spec)...)
	}

	if a.Kind == "CustomResourceDefinition" {
		if !deepEqualJSON(a.Spec, b.Spec) {
			diffs = append(diffs, "/spec")
		}
		if annDiffs := diffAnnotations(a.Metadata, b.Metadata); len(annDiffs) > 0 {
			diffs = append(diffs, "/metadata/annotations")
		}
	}

	return diffs
}

func isCertificateData(data interface{}) bool {
	if data == nil {
		return false
	}
	m, ok := data.(map[string]interface{})
	if !ok {
		return false
	}
	for key := range m {
		if key == "ca.crt" || key == "tls.crt" || key == "tls.key" || strings.HasSuffix(key, ".crt") || strings.HasSuffix(key, ".key") {
			return true
		}
	}
	return false
}

func diffAnnotations(metaA, metaB map[string]interface{}) []string {
	annA, _ := metaA["annotations"].(map[string]interface{})
	annB, _ := metaB["annotations"].(map[string]interface{})
	if annA == nil || annB == nil {
		return nil
	}

	var diffs []string
	for k, v1 := range annA {
		v2, exists := annB[k]
		if !exists {
			continue
		}
		if fmt.Sprintf("%v", v1) != fmt.Sprintf("%v", v2) {
			encoded := strings.ReplaceAll(k, "/", "~1")
			diffs = append(diffs, "/metadata/annotations/"+encoded)
		}
	}
	return diffs
}

func diffTemplateAnnotations(specA, specB interface{}) []string {
	sA, _ := specA.(map[string]interface{})
	sB, _ := specB.(map[string]interface{})
	if sA == nil || sB == nil {
		return nil
	}

	tplA, _ := sA["template"].(map[string]interface{})
	tplB, _ := sB["template"].(map[string]interface{})
	if tplA == nil || tplB == nil {
		return nil
	}

	metaA, _ := tplA["metadata"].(map[string]interface{})
	metaB, _ := tplB["metadata"].(map[string]interface{})
	if metaA == nil || metaB == nil {
		return nil
	}

	annA, _ := metaA["annotations"].(map[string]interface{})
	annB, _ := metaB["annotations"].(map[string]interface{})
	if annA == nil || annB == nil {
		return nil
	}

	var diffs []string
	for k, v1 := range annA {
		v2, exists := annB[k]
		if !exists {
			continue
		}
		if fmt.Sprintf("%v", v1) != fmt.Sprintf("%v", v2) {
			encoded := strings.ReplaceAll(k, "/", "~1")
			diffs = append(diffs, "/spec/template/metadata/annotations/"+encoded)
		}
	}
	return diffs
}

func hasWebhookCaBundleDiff(a, b map[string]interface{}) bool {
	webhooksA, _ := a["webhooks"].([]interface{})
	webhooksB, _ := b["webhooks"].([]interface{})
	if len(webhooksA) != len(webhooksB) {
		return false
	}
	for i := 0; i < len(webhooksA); i++ {
		whA, _ := webhooksA[i].(map[string]interface{})
		whB, _ := webhooksB[i].(map[string]interface{})
		if whA == nil || whB == nil {
			continue
		}
		ccA, _ := whA["clientConfig"].(map[string]interface{})
		ccB, _ := whB["clientConfig"].(map[string]interface{})
		if ccA == nil || ccB == nil {
			continue
		}
		cbA, _ := ccA["caBundle"].(string)
		cbB, _ := ccB["caBundle"].(string)
		if cbA != "" && cbB != "" && cbA != cbB {
			return true
		}
	}
	return false
}

func hasAPICaBundleDiff(a, b interface{}) bool {
	specA, _ := a.(map[string]interface{})
	specB, _ := b.(map[string]interface{})
	if specA == nil || specB == nil {
		return false
	}
	cbA, _ := specA["caBundle"].(string)
	cbB, _ := specB["caBundle"].(string)
	return cbA != "" && cbB != "" && cbA != cbB
}

func deepEqualJSON(a, b interface{}) bool {
	if a == nil && b == nil {
		return true
	}
	if a == nil || b == nil {
		return false
	}
	jsonA, _ := json.Marshal(a)
	jsonB, _ := json.Marshal(b)
	return bytes.Equal(jsonA, jsonB)
}

type IgnoreRule struct {
	Group             string
	Kind              string
	Name              string
	Namespace         string
	JSONPointers      []string
	JQPathExpressions []string
}

func (r IgnoreRule) Key() string {
	return fmt.Sprintf("%s/%s/%s", r.Group, r.Kind, r.Name)
}

func findIgnoreDifferences(renders []string) []IgnoreRule {
	if len(renders) < 2 {
		return nil
	}

	var allParsed []map[string]*Resource
	for _, render := range renders {
		allParsed = append(allParsed, parseResources(render))
	}

	ruleMap := make(map[string]*IgnoreRule)

	for key, res1 := range allParsed[0] {
		for i := 1; i < len(allParsed); i++ {
			res2, exists := allParsed[i][key]
			if !exists {
				continue
			}

			diffs := diffResources(res1, res2)
			if len(diffs) > 0 {
				rule := getOrCreateRule(ruleMap, res1)
				for _, d := range diffs {
					addPathToRule(rule, d)
				}
			}
		}
	}

	var rules []IgnoreRule
	for _, r := range ruleMap {
		if len(r.JSONPointers) > 0 || len(r.JQPathExpressions) > 0 {
			rules = append(rules, *r)
		}
	}

	sort.Slice(rules, func(i, j int) bool {
		return rules[i].Key() < rules[j].Key()
	})

	return rules
}

func getOrCreateRule(ruleMap map[string]*IgnoreRule, res *Resource) *IgnoreRule {
	key := res.Key()
	if r, exists := ruleMap[key]; exists {
		return r
	}
	rule := &IgnoreRule{
		Group:     res.Group(),
		Kind:      res.Kind,
		Name:      res.Name(),
		Namespace: res.NS(),
	}
	ruleMap[key] = rule
	return rule
}

func addPathToRule(rule *IgnoreRule, path string) {
	if strings.Contains(path, "caBundle") {
		if rule.Kind == "MutatingWebhookConfiguration" || rule.Kind == "ValidatingWebhookConfiguration" {
			expr := ".webhooks[].clientConfig.caBundle"
			for _, e := range rule.JQPathExpressions {
				if e == expr {
					return
				}
			}
			rule.JQPathExpressions = append(rule.JQPathExpressions, expr)
			return
		}
	}

	for _, p := range rule.JSONPointers {
		if p == path {
			return
		}
	}
	rule.JSONPointers = append(rule.JSONPointers, path)
}

func buildValuesMap() map[string]interface{} {
	values := make(map[string]interface{})
	if aceUserRoles {
		values["ace-user-roles"] = map[string]interface{}{"enabled": false}
	}
	if installCRDs {
		values["installCRDs"] = true
	}
	if platformToken != "" || platformBaseURL != "" {
		platform := make(map[string]interface{})
		if platformToken != "" {
			platform["token"] = platformToken
		}
		if platformBaseURL != "" {
			platform["baseURL"] = platformBaseURL
		}
		values["platform"] = platform
	}
	return values
}

func generateArgoCDApp(chart, version, ns string, rules []IgnoreRule, vals map[string]interface{}) map[string]interface{} {
	app := map[string]interface{}{
		"apiVersion": "argoproj.io/v1alpha1",
		"kind":       "Application",
		"metadata": map[string]interface{}{
			"name":      chart,
			"namespace": "argocd",
		},
		"spec": map[string]interface{}{
			"project": "default",
			"source": map[string]interface{}{
				"chart":          chart,
				"repoURL":        "ghcr.io/appscode-charts",
				"targetRevision": version,
			},
			"destination": map[string]interface{}{
				"server":    "https://kubernetes.default.svc",
				"namespace": ns,
			},
			"syncPolicy": map[string]interface{}{
				"automated": map[string]interface{}{},
				"syncOptions": []interface{}{
					"CreateNamespace=true",
				},
			},
		},
	}

	if len(vals) > 0 {
		spec := app["spec"].(map[string]interface{})
		source := spec["source"].(map[string]interface{})
		valsYAML, _ := yaml.Marshal(vals)
		source["helm"] = map[string]interface{}{
			"values": string(valsYAML),
		}
	}

	if len(rules) > 0 {
		var diffs []interface{}
		for _, r := range rules {
			d := make(map[string]interface{})
			if r.Group != "" {
				d["group"] = r.Group
			}
			d["kind"] = r.Kind
			if r.Name != "" {
				d["name"] = r.Name
			}
			if r.Namespace != "" {
				d["namespace"] = r.Namespace
			}
			if len(r.JSONPointers) > 0 {
				ptrs := make([]interface{}, len(r.JSONPointers))
				for i, p := range r.JSONPointers {
					ptrs[i] = p
				}
				d["jsonPointers"] = ptrs
			}
			if len(r.JQPathExpressions) > 0 {
				exprs := make([]interface{}, len(r.JQPathExpressions))
				for i, e := range r.JQPathExpressions {
					exprs[i] = e
				}
				d["jqPathExpressions"] = exprs
			}
			diffs = append(diffs, d)
		}
		spec := app["spec"].(map[string]interface{})
		spec["ignoreDifferences"] = diffs
	}

	return app
}
