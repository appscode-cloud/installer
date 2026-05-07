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
	"context"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

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

// Chart represents a helm chart from opscenter-features
type chartEntry struct {
	Name         string
	Version      string
	Namespace    string
	RepoURL      string
	AceUserRoles bool // whether to set ace-user-roles.enabled=false
}

// All charts referenced by opscenter-features chart
var opscenterCharts = []chartEntry{
	// capi-capa
	{"aws-credential-manager", "v2026.1.20", "capa-system", "ghcr.io/appscode-charts", true},
	{"aws-ebs-csi-driver", "2.23.0", "capa-system", "ghcr.io/appscode-charts", true},
	{"aws-load-balancer-controller", "1.11.0", "capa-system", "ghcr.io/appscode-charts", true},
	{"capa-vpc-peering-operator", "v2023.12.11", "capa-system", "ghcr.io/appscode-charts", true},
	{"cluster-autoscaler", "9.29.0", "capi-system", "ghcr.io/appscode-charts", true},
	// capi-capg
	{"gcp-credential-manager", "v2026.3.11", "capg-system", "ghcr.io/appscode-charts", true},
	// capi-core
	{"capi-catalog", "v2024.10.24", "capi-system", "ghcr.io/appscode-charts", true},
	{"capi-ops-manager", "v2024.8.14", "capi-system", "ghcr.io/appscode-charts", true},
	{"cluster-presets", "v2026.3.30", "kubeops", "ghcr.io/appscode-charts", true},
	// crossplane
	{"crossplane", "1.14.0", "crossplane-system", "ghcr.io/appscode-charts", true},
	{"kubedb-provider-aws", "v2024.1.31", "crossplane-system", "ghcr.io/appscode-charts", true},
	{"kubedb-provider-azure", "v2024.1.31", "crossplane-system", "ghcr.io/appscode-charts", true},
	{"kubedb-provider-gcp", "v2024.1.31", "crossplane-system", "ghcr.io/appscode-charts", true},
	// ocm-hub
	{"cluster-manager-hub", "v2026.2.16", "open-cluster-management", "ghcr.io/appscode-charts", true},
	{"cluster-gateway-manager", "v2026.2.16", "open-cluster-management-addon", "ghcr.io/appscode-charts", true},
	{"cluster-proxy-manager", "v2026.2.16", "open-cluster-management-addon", "ghcr.io/appscode-charts", true},
	{"cluster-auth-manager", "v2026.2.16", "open-cluster-management-addon", "ghcr.io/appscode-charts", true},
	{"cluster-profile-manager", "v2026.2.16", "open-cluster-management-addon", "ghcr.io/appscode-charts", true},
	{"fluxcd-manager", "v2026.2.16", "open-cluster-management-addon", "ghcr.io/appscode-charts", true},
	{"managed-serviceaccount-manager", "v2026.2.16", "open-cluster-management-addon", "ghcr.io/appscode-charts", true},
	{"hub-cluster-robot", "v2026.2.16", "open-cluster-management", "ghcr.io/appscode-charts", true},
	{"license-proxyserver-manager", "v2026.2.16", "open-cluster-management-addon", "ghcr.io/appscode-charts", true},
	// ocm-spoke
	{"cluster-manager-spoke", "v2026.2.16", "open-cluster-management", "ghcr.io/appscode-charts", true},
	// opscenter-backup
	{"kubestash", "v2026.2.26", "stash", "ghcr.io/appscode-charts", true},
	{"stash", "v2025.7.31", "stash", "ghcr.io/appscode-charts", true},
	{"stash-opscenter", "v2025.7.31", "stash", "ghcr.io/appscode-charts", true},
	{"stash-presets", "v2026.3.30", "stash", "ghcr.io/appscode-charts", true},
	// opscenter-core
	{"aceshifter", "v2026.3.30", "kubeops", "ghcr.io/appscode-charts", true},
	{"flux2", "2.17.0", "flux-system", "ghcr.io/appscode-charts", true},
	{"license-proxyserver", "v2026.2.16", "kubeops", "ghcr.io/appscode-charts", true},
	{"kube-ui-server", "v2026.3.30", "kubeops", "ghcr.io/appscode-charts", true},
	// opscenter-cost
	{"opencost", "1.18.1", "opencost", "ghcr.io/appscode-charts", true},
	{"opencost-grafana-dashboards", "v2023.10.1", "opencost", "ghcr.io/appscode-charts", true},
	{"keda", "2.19.0", "keda", "ghcr.io/appscode-charts", true},
	{"keda-add-ons-http", "0.12.0", "keda", "ghcr.io/appscode-charts", true},
	// opscenter-datastore
	{"kubedb", "v2026.2.26", "kubedb", "ghcr.io/appscode-charts", true},
	{"kubedb-opscenter", "v2026.2.26", "kubedb", "ghcr.io/appscode-charts", true},
	{"kubedb-ui-presets", "v2026.3.30", "kubedb", "ghcr.io/appscode-charts", true},
	{"prepare-cluster", "v2023.12.21", "kubedb", "ghcr.io/appscode-charts", true},
	// opscenter-networking
	{"voyager", "v2026.3.23", "voyager", "ghcr.io/appscode-charts", true},
	{"voyager-gateway", "v2026.1.15", "envoy-gateway-system", "ghcr.io/appscode-charts", true},
	{"gateway-api", "v2025.3.14", "envoy-gateway-system", "ghcr.io/appscode-charts", true},
	{"external-dns-operator", "v2026.1.15", "kubeops", "ghcr.io/appscode-charts", true},
	// opscenter-observability
	{"monitoring-operator", "v2026.3.30", "monitoring", "ghcr.io/appscode-charts", true},
	{"grafana-operator", "v2026.3.30", "monitoring", "ghcr.io/appscode-charts", true},
	{"kube-prometheus-stack", "69.2.2", "monitoring", "ghcr.io/appscode-charts", true},
	{"panopticon", "v2026.1.15", "monitoring", "ghcr.io/appscode-charts", true},
	{"metrics-server", "3.11.0", "monitoring", "ghcr.io/appscode-charts", true},
	{"prometheus-adapter", "4.9.0", "monitoring", "ghcr.io/appscode-charts", true},
	{"kube-grafana-dashboards", "v2023.10.1", "monitoring", "ghcr.io/appscode-charts", true},
	{"inbox-server", "v2025.2.28", "ace", "ghcr.io/appscode-charts", true},
	{"inbox-agent", "v2024.12.30", "monitoring", "ghcr.io/appscode-charts", true},
	{"inbox-ui", "v2026.3.30", "ace", "ghcr.io/appscode-charts", true},
	// opscenter-policy-management
	{"gatekeeper", "3.13.3", "gatekeeper-system", "ghcr.io/appscode-charts", true},
	{"gatekeeper-library", "v2023.10.1", "gatekeeper-system", "ghcr.io/appscode-charts", true},
	{"gatekeeper-grafana-dashboards", "v2023.10.1", "kubeops", "ghcr.io/appscode-charts", true},
	{"kyverno", "3.2.6", "kyverno", "ghcr.io/appscode-charts", true},
	{"kyverno-policies", "3.2.5", "kyverno", "ghcr.io/appscode-charts", true},
	// opscenter-secret-management
	{"kubevault", "v2026.2.27", "kubevault", "ghcr.io/appscode-charts", true},
	{"kubevault-opscenter", "v2026.2.27", "kubevault", "ghcr.io/appscode-charts", true},
	{"external-secrets", "0.9.12", "external-secrets", "ghcr.io/appscode-charts", true},
	{"sealed-secrets", "2.14.2", "kube-system", "ghcr.io/appscode-charts", true},
	{"config-syncer", "v0.15.4", "kubeops", "ghcr.io/appscode-charts", true},
	{"reloader", "2.2.9", "kubeops", "ghcr.io/appscode-charts", true},
	{"vault-secrets-operator", "0.4.3", "vault-secrets-operator-system", "ghcr.io/appscode-charts", true},
	{"secrets-store-csi-driver", "1.4.1", "kube-system", "ghcr.io/appscode-charts", true},
	{"secrets-store-csi-driver-provider-aws", "0.3.6", "kube-system", "ghcr.io/appscode-charts", true},
	{"csi-secrets-store-provider-azure", "1.5.2", "kube-system", "ghcr.io/appscode-charts", true},
	{"secrets-store-csi-driver-provider-gcp", "0.1.0", "kube-system", "ghcr.io/appscode-charts", true},
	{"virtual-secrets-server", "v2026.2.27", "kubevault", "ghcr.io/appscode-charts", true},
	{"secrets-store-csi-driver-provider-virtual-secrets", "v2026.2.27", "kube-system", "ghcr.io/appscode-charts", true},
	// opscenter-security
	{"cert-manager", "v1.19.3", "cert-manager", "ghcr.io/appscode-charts", false},
	{"cert-manager-csi-driver-cacerts", "v2026.1.15", "cert-manager", "ghcr.io/appscode-charts", true},
	{"falco", "4.0.0", "falco", "ghcr.io/appscode-charts", true},
	{"falco-ui-server", "v2026.1.15", "falco", "ghcr.io/appscode-charts", true},
	{"scanner", "v2026.1.15", "kubeops", "ghcr.io/appscode-charts", true},
	// opscenter-storage
	{"topolvm", "15.0.0", "topolvm-system", "ghcr.io/appscode-charts", true},
	{"longhorn", "1.7.2", "longhorn-system", "ghcr.io/appscode-charts", true},
	{"snapshot-controller", "3.0.6", "kubeops", "ghcr.io/appscode-charts", true},
	{"csi-driver-nfs", "v4.7.0", "kube-system", "ghcr.io/appscode-charts", true},
	// opscenter-tools
	{"operator-shard-manager", "v2026.1.15", "kubeops", "ghcr.io/appscode-charts", true},
	{"sidekick", "v2026.2.16", "kubeops", "ghcr.io/appscode-charts", true},
	{"supervisor", "v2026.1.15", "kubeops", "ghcr.io/appscode-charts", true},
	// saas-core
	{"catalog-manager", "v2026.3.30", "ace", "ghcr.io/appscode-charts", true},
	{"service-backend", "v2026.3.30", "ace", "ghcr.io/appscode-charts", true},
	{"service-provider", "v2026.3.30", "ace", "ghcr.io/appscode-charts", true},
	{"service-gateway-presets", "v2026.3.30", "ace-gw", "ghcr.io/appscode-charts", true},
}

// Charts that are expected to have ignoreDifferences (from helm template double-render analysis)
// These charts produce different certificate/annotation values on each render.
var chartsWithExpectedDifferences = map[string]bool{
	"aws-credential-manager": true,
	"capi-ops-manager":       true,
	"falco-ui-server":        true,
	"gcp-credential-manager": true,
	"grafana-operator":       true,
	"inbox-agent":            true,
	"kube-ui-server":         true,
	"kubedb-opscenter":       true,
	"kubedb":                 true,
	"kubestash":              true,
	"kubevault":              true,
	"license-proxyserver":    true,
	"monitoring-operator":    true,
	"operator-shard-manager": true,
	"panopticon":             true,
	"scanner":                true,
	"service-provider":       true,
	"sidekick":               true,
	"snapshot-controller":    true,
	"stash-opscenter":        true,
	"supervisor":             true,
	"virtual-secrets-server": true,
	"voyager":                true,
}

// Expected ignoreDifferences kinds for charts that have differences
var expectedDiffKinds = map[string][]string{
	"kubedb":                 {"Secret", "MutatingWebhookConfiguration", "ValidatingWebhookConfiguration", "Deployment"},
	"kubevault":              {"Secret", "MutatingWebhookConfiguration", "ValidatingWebhookConfiguration", "APIService", "Deployment"},
	"kubestash":              {"Secret", "MutatingWebhookConfiguration", "ValidatingWebhookConfiguration", "Deployment"},
	"voyager":                {"Secret", "MutatingWebhookConfiguration", "ValidatingWebhookConfiguration", "APIService", "Deployment"},
	"license-proxyserver":    {"Secret", "APIService"},
	"monitoring-operator":    {"Secret", "APIService", "Deployment"},
	"panopticon":             {"Secret", "APIService", "Deployment"},
	"scanner":                {"Secret", "APIService", "Deployment"},
	"crossplane":             {"MutatingWebhookConfiguration", "ValidatingWebhookConfiguration"},
	"gatekeeper":             {"MutatingWebhookConfiguration", "ValidatingWebhookConfiguration"},
	"kyverno":                {"MutatingWebhookConfiguration", "ValidatingWebhookConfiguration"},
	"keda":                   {"MutatingWebhookConfiguration", "ValidatingWebhookConfiguration"},
	"external-secrets":       {"MutatingWebhookConfiguration", "ValidatingWebhookConfiguration", "Deployment"},
	"cert-manager":           {"Secret", "MutatingWebhookConfiguration", "ValidatingWebhookConfiguration"},
	"flux2":                  {"Secret"},
	"vault-secrets-operator": {"MutatingWebhookConfiguration", "ValidatingWebhookConfiguration", "Deployment"},
	"inbox-agent":            {"Secret", "MutatingWebhookConfiguration", "ValidatingWebhookConfiguration"},
	"snapshot-controller":    {"Secret", "MutatingWebhookConfiguration"},
}

// renderChartForTest is the test helper that renders a chart using Helm SDK
func renderChartForTest(t *testing.T, c chartEntry, renderCount int) []string {
	t.Helper()

	settings := cli.New()

	// Create registry client
	regClient, err := newTestRegistryClient(settings)
	if err != nil {
		t.Fatalf("registry client: %v", err)
	}

	// Init action config with memory storage
	actionConfig := new(action.Configuration)
	actionConfig.Releases = storage.Init(driver.NewMemory())
	actionConfig.KubeClient = &testKubeClient{}
	actionConfig.Log = func(format string, v ...interface{}) {}
	actionConfig.RegistryClient = regClient

	// Build values
	values := make(map[string]interface{})
	if c.AceUserRoles {
		values["ace-user-roles"] = map[string]interface{}{"enabled": false}
	}

	var manifests []string

	for i := 0; i < renderCount; i++ {
		// Pull chart
		pullClient := action.NewPullWithOpts(action.WithConfig(actionConfig))
		pullClient.Version = c.Version
		pullClient.Settings = settings
		pullClient.SetRegistryClient(regClient)

		tmpDir := t.TempDir()
		pullClient.DestDir = tmpDir

		chartRef := fmt.Sprintf("oci://%s/%s", c.RepoURL, c.Name)
		if _, err := pullClient.Run(chartRef); err != nil {
			t.Fatalf("pull %s:%s: %v", chartRef, c.Version, err)
		}

		// Load chart
		var chartPath string
		entries, _ := os.ReadDir(tmpDir)
		for _, e := range entries {
			if strings.HasSuffix(e.Name(), ".tgz") {
				chartPath = filepath.Join(tmpDir, e.Name())
				break
			}
		}
		if chartPath == "" {
			t.Fatalf("no .tgz found in %s", tmpDir)
		}

		chart, err := loader.Load(chartPath)
		if err != nil {
			t.Fatalf("load chart: %v", err)
		}

		// Install (dry-run)
		installClient := action.NewInstall(actionConfig)
		installClient.DryRunOption = "client"
		installClient.ReleaseName = c.Name
		installClient.Namespace = c.Namespace
		installClient.ClientOnly = true
		installClient.IncludeCRDs = true
		installClient.Replace = true
		installClient.SetRegistryClient(regClient)

		kv, _ := chartutil.ParseKubeVersion("v1.31.0")
		installClient.KubeVersion = kv

		rel, err := installClient.RunWithContext(context.Background(), chart, values)
		if err != nil {
			t.Fatalf("render %s (attempt %d): %v", c.Name, i+1, err)
		}

		manifests = append(manifests, rel.Manifest)
	}

	return manifests
}

func newTestRegistryClient(settings *cli.EnvSettings) (*registry.Client, error) {
	opts := []registry.ClientOption{
		registry.ClientOptDebug(settings.Debug),
		registry.ClientOptEnableCache(true),
		registry.ClientOptWriter(os.Stderr),
		registry.ClientOptCredentialsFile(settings.RegistryConfig),
	}
	return registry.NewClient(opts...)
}

// testKubeClient implements kube.Interface for dry-run mode
type testKubeClient struct{}

func (c *testKubeClient) Create(resources kube.ResourceList) (*kube.Result, error) {
	return &kube.Result{Created: resources}, nil
}

func (c *testKubeClient) Wait(resources kube.ResourceList, timeout time.Duration) error {
	return nil
}

func (c *testKubeClient) WaitWithJobs(resources kube.ResourceList, timeout time.Duration) error {
	return nil
}

func (c *testKubeClient) Delete(resources kube.ResourceList) (*kube.Result, []error) {
	return &kube.Result{Deleted: resources}, nil
}

func (c *testKubeClient) WatchUntilReady(resources kube.ResourceList, timeout time.Duration) error {
	return nil
}

func (c *testKubeClient) Update(original, target kube.ResourceList, force bool) (*kube.Result, error) {
	return &kube.Result{Updated: target}, nil
}

func (c *testKubeClient) Build(reader io.Reader, validate bool) (kube.ResourceList, error) {
	return kube.ResourceList{}, nil
}

func (c *testKubeClient) WaitAndGetCompletedPodPhase(name string, timeout time.Duration) (v1.PodPhase, error) {
	return v1.PodSucceeded, nil
}

func (c *testKubeClient) IsReachable() error {
	return nil
}

// TestAllOpscenterCharts renders each chart twice and verifies ignoreDifferences
func TestAllOpscenterCharts(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping long-running test in short mode")
	}

	outDir := t.TempDir()
	renderCount := 2

	for _, c := range opscenterCharts {
		t.Run(c.Name, func(t *testing.T) {
			manifests := renderChartForTest(t, c, renderCount)
			if len(manifests) < 2 {
				t.Fatalf("expected at least 2 renders, got %d", len(manifests))
			}

			rules := findIgnoreDifferences(manifests)

			expectedDiff := chartsWithExpectedDifferences[c.Name]

			if expectedDiff && len(rules) == 0 {
				t.Errorf("expected ignoreDifferences for %s but got none", c.Name)
			}

			if !expectedDiff && len(rules) > 0 {
				t.Logf("chart %s has %d unexpected ignoreDifferences rules", c.Name, len(rules))
				// Not a failure - just means we found more differences than expected
			}

			// Verify expected kinds if specified
			if expectedKinds, ok := expectedDiffKinds[c.Name]; ok {
				actualKinds := make(map[string]bool)
				for _, r := range rules {
					actualKinds[r.Kind] = true
				}
				for _, ek := range expectedKinds {
					if !actualKinds[ek] {
						t.Errorf("expected ignoreDifferences for kind %s in %s but not found", ek, c.Name)
					}
				}
			}

			// Generate the ArgoCD Application and verify it's valid YAML
			values := make(map[string]interface{})
			if c.AceUserRoles {
				values["ace-user-roles"] = map[string]interface{}{"enabled": false}
			}
			app := generateArgoCDApp(c.Name, c.Version, c.Namespace, rules, values)

			appYAML, err := yaml.Marshal(app)
			if err != nil {
				t.Fatalf("marshal app: %v", err)
			}

			// Write output to file for inspection
			outFile := filepath.Join(outDir, c.Name+".yaml")
			if err := os.WriteFile(outFile, appYAML, 0o644); err != nil {
				t.Fatalf("write output: %v", err)
			}

			// Verify app structure
			spec, ok := app["spec"].(map[string]interface{})
			if !ok {
				t.Fatal("app spec is not a map")
			}

			source, ok := spec["source"].(map[string]interface{})
			if !ok {
				t.Fatal("source is not a map")
			}

			if source["chart"] != c.Name {
				t.Errorf("source.chart = %q, want %q", source["chart"], c.Name)
			}
			if source["targetRevision"] != c.Version {
				t.Errorf("source.targetRevision = %q, want %q", source["targetRevision"], c.Version)
			}

			dest, ok := spec["destination"].(map[string]interface{})
			if !ok {
				t.Fatal("destination is not a map")
			}
			if dest["namespace"] != c.Namespace {
				t.Errorf("destination.namespace = %q, want %q", dest["namespace"], c.Namespace)
			}

			t.Logf("generated %d ignoreDifferences rules", len(rules))
		})
	}
}

// TestSpecificCharts tests key charts in detail
func TestSpecificCharts(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping long-running test in short mode")
	}

	tests := []struct {
		name            string
		chart           chartEntry
		wantRuleCount   int // minimum expected rules
		wantKinds       []string
		wantSecretNames []string
	}{
		{
			name: "kubedb",
			chart: chartEntry{
				Name:         "kubedb",
				Version:      "v2026.2.26",
				Namespace:    "kubedb",
				RepoURL:      "ghcr.io/appscode-charts",
				AceUserRoles: true,
			},
			wantRuleCount:   10,
			wantKinds:       []string{"Secret", "MutatingWebhookConfiguration", "ValidatingWebhookConfiguration", "Deployment"},
			wantSecretNames: []string{"kubedb-kubedb-webhook-server-cert", "kubedb-petset-cert", "kubedb-sidekick-cert"},
		},
		{
			name: "kubevault",
			chart: chartEntry{
				Name:         "kubevault",
				Version:      "v2026.2.27",
				Namespace:    "kubevault",
				RepoURL:      "ghcr.io/appscode-charts",
				AceUserRoles: true,
			},
			wantRuleCount:   5,
			wantKinds:       []string{"Secret", "APIService", "Deployment"},
			wantSecretNames: []string{"kubevault-kubevault-webhook-server-apiserver-cert"},
		},
		{
			name: "kubestash",
			chart: chartEntry{
				Name:         "kubestash",
				Version:      "v2026.2.26",
				Namespace:    "stash",
				RepoURL:      "ghcr.io/appscode-charts",
				AceUserRoles: true,
			},
			wantRuleCount:   3,
			wantKinds:       []string{"Secret", "Deployment"},
			wantSecretNames: []string{"kubestash-kubestash-operator-cert"},
		},
		{
			name: "voyager",
			chart: chartEntry{
				Name:         "voyager",
				Version:      "v2026.3.23",
				Namespace:    "voyager",
				RepoURL:      "ghcr.io/appscode-charts",
				AceUserRoles: true,
			},
			wantRuleCount:   4,
			wantKinds:       []string{"Secret", "APIService", "Deployment"},
			wantSecretNames: []string{"voyager-apiserver-cert"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			manifests := renderChartForTest(t, tt.chart, 2)
			rules := findIgnoreDifferences(manifests)

			if len(rules) < tt.wantRuleCount {
				t.Errorf("got %d rules, want at least %d", len(rules), tt.wantRuleCount)
			}

			// Check expected kinds are present
			actualKinds := make(map[string]bool)
			for _, r := range rules {
				actualKinds[r.Kind] = true
			}
			for _, ek := range tt.wantKinds {
				if !actualKinds[ek] {
					t.Errorf("expected kind %q not found in rules", ek)
				}
			}

			// Check secret names
			actualSecrets := make(map[string]bool)
			for _, r := range rules {
				if r.Kind == "Secret" {
					actualSecrets[r.Name] = true
				}
			}
			for _, es := range tt.wantSecretNames {
				if !actualSecrets[es] {
					t.Errorf("expected Secret %q not found in rules", es)
				}
			}

			// Verify webhook rules use jqPathExpressions
			for _, r := range rules {
				if r.Kind == "MutatingWebhookConfiguration" || r.Kind == "ValidatingWebhookConfiguration" {
					if len(r.JQPathExpressions) == 0 {
						t.Errorf("webhook %s has no jqPathExpressions", r.Name)
					}
				}
			}

			// Verify secret rules use jsonPointers with /data
			for _, r := range rules {
				if r.Kind == "Secret" {
					hasData := false
					for _, p := range r.JSONPointers {
						if p == "/data" {
							hasData = true
							break
						}
					}
					if !hasData {
						t.Errorf("secret %s has no /data jsonPointer", r.Name)
					}
				}
			}

			t.Logf("rules: %d, kinds: %v", len(rules), actualKinds)
		})
	}
}

// TestIgnoreDifferencesStructure validates the structure of generated ignoreDifferences
func TestIgnoreDifferencesStructure(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping long-running test in short mode")
	}

	c := chartEntry{
		Name:         "kubedb",
		Version:      "v2026.2.26",
		Namespace:    "kubedb",
		RepoURL:      "ghcr.io/appscode-charts",
		AceUserRoles: true,
	}

	manifests := renderChartForTest(t, c, 2)
	rules := findIgnoreDifferences(manifests)

	for _, r := range rules {
		// Every rule must have a kind
		if r.Kind == "" {
			t.Error("rule has empty Kind")
		}

		// Every rule must have at least one jsonPointer or jqPathExpression
		if len(r.JSONPointers) == 0 && len(r.JQPathExpressions) == 0 {
			t.Errorf("rule %s/%s has no jsonPointers or jqPathExpressions", r.Kind, r.Name)
		}

		// jsonPointers must start with /
		for _, p := range r.JSONPointers {
			if !strings.HasPrefix(p, "/") {
				t.Errorf("jsonPointer %q does not start with /", p)
			}
		}

		// jqPathExpressions must start with .
		for _, e := range r.JQPathExpressions {
			if !strings.HasPrefix(e, ".") {
				t.Errorf("jqPathExpression %q does not start with .", e)
			}
		}
	}
}

// TestDiffResourcesUnit tests the diffResources function directly
func TestDiffResourcesUnit(t *testing.T) {
	tests := []struct {
		name     string
		a, b     *Resource
		wantDiff bool
		wantPath string
	}{
		{
			name: "secret with changing cert data",
			a: &Resource{
				Kind:     "Secret",
				Metadata: map[string]interface{}{"name": "test", "namespace": "ns"},
				Data:     map[string]interface{}{"tls.crt": "abc123", "tls.key": "def456"},
				Raw:      map[string]interface{}{"kind": "Secret", "data": map[string]interface{}{"tls.crt": "abc123"}},
			},
			b: &Resource{
				Kind:     "Secret",
				Metadata: map[string]interface{}{"name": "test", "namespace": "ns"},
				Data:     map[string]interface{}{"tls.crt": "xyz789", "tls.key": "ghi012"},
				Raw:      map[string]interface{}{"kind": "Secret", "data": map[string]interface{}{"tls.crt": "xyz789"}},
			},
			wantDiff: true,
			wantPath: "/data",
		},
		{
			name: "deployment with reload annotation",
			a: &Resource{
				Kind:     "Deployment",
				Metadata: map[string]interface{}{"name": "deploy", "namespace": "ns"},
				Spec: map[string]interface{}{
					"template": map[string]interface{}{
						"metadata": map[string]interface{}{
							"annotations": map[string]interface{}{"reload": "abc123"},
						},
					},
				},
				Raw: map[string]interface{}{"kind": "Deployment"},
			},
			b: &Resource{
				Kind:     "Deployment",
				Metadata: map[string]interface{}{"name": "deploy", "namespace": "ns"},
				Spec: map[string]interface{}{
					"template": map[string]interface{}{
						"metadata": map[string]interface{}{
							"annotations": map[string]interface{}{"reload": "xyz789"},
						},
					},
				},
				Raw: map[string]interface{}{"kind": "Deployment"},
			},
			wantDiff: true,
			wantPath: "/spec/template/metadata/annotations/reload",
		},
		{
			name: "webhook with caBundle",
			a: &Resource{
				Kind:     "MutatingWebhookConfiguration",
				Metadata: map[string]interface{}{"name": "wh"},
				Raw: map[string]interface{}{
					"kind": "MutatingWebhookConfiguration",
					"webhooks": []interface{}{
						map[string]interface{}{
							"clientConfig": map[string]interface{}{"caBundle": "abc123"},
						},
					},
				},
			},
			b: &Resource{
				Kind:     "MutatingWebhookConfiguration",
				Metadata: map[string]interface{}{"name": "wh"},
				Raw: map[string]interface{}{
					"kind": "MutatingWebhookConfiguration",
					"webhooks": []interface{}{
						map[string]interface{}{
							"clientConfig": map[string]interface{}{"caBundle": "xyz789"},
						},
					},
				},
			},
			wantDiff: true,
			wantPath: "/webhooks[].clientConfig.caBundle",
		},
		{
			name: "api service with caBundle",
			a: &Resource{
				Kind:     "APIService",
				Metadata: map[string]interface{}{"name": "v1.foo"},
				Spec:     map[string]interface{}{"caBundle": "abc123"},
				Raw:      map[string]interface{}{"kind": "APIService"},
			},
			b: &Resource{
				Kind:     "APIService",
				Metadata: map[string]interface{}{"name": "v1.foo"},
				Spec:     map[string]interface{}{"caBundle": "xyz789"},
				Raw:      map[string]interface{}{"kind": "APIService"},
			},
			wantDiff: true,
			wantPath: "/spec/caBundle",
		},
		{
			name: "identical resources",
			a: &Resource{
				Kind:     "Deployment",
				Metadata: map[string]interface{}{"name": "deploy", "namespace": "ns"},
				Spec:     map[string]interface{}{"replicas": 1},
				Raw:      map[string]interface{}{"kind": "Deployment"},
			},
			b: &Resource{
				Kind:     "Deployment",
				Metadata: map[string]interface{}{"name": "deploy", "namespace": "ns"},
				Spec:     map[string]interface{}{"replicas": 1},
				Raw:      map[string]interface{}{"kind": "Deployment"},
			},
			wantDiff: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			diffs := diffResources(tt.a, tt.b)

			if tt.wantDiff && len(diffs) == 0 {
				t.Error("expected differences but got none")
			}

			if !tt.wantDiff && len(diffs) > 0 {
				t.Errorf("expected no differences but got: %v", diffs)
			}

			if tt.wantPath != "" {
				found := false
				for _, d := range diffs {
					if d == tt.wantPath {
						found = true
						break
					}
				}
				if !found {
					t.Errorf("expected path %q not found in diffs: %v", tt.wantPath, diffs)
				}
			}
		})
	}
}

// TestArgoCDAppStructure verifies the generated ArgoCD Application has correct structure
func TestArgoCDAppStructure(t *testing.T) {
	rules := []IgnoreRule{
		{
			Group:             "admissionregistration.k8s.io",
			Kind:              "MutatingWebhookConfiguration",
			Name:              "test-webhook",
			JQPathExpressions: []string{".webhooks[].clientConfig.caBundle"},
		},
		{
			Kind:         "Secret",
			Name:         "test-cert",
			Namespace:    "default",
			JSONPointers: []string{"/data"},
		},
	}

	app := generateArgoCDApp("test-chart", "v1.0.0", "default", rules, map[string]interface{}{
		"ace-user-roles": map[string]interface{}{"enabled": false},
	})

	// Verify apiVersion and kind
	if app["apiVersion"] != "argoproj.io/v1alpha1" {
		t.Errorf("apiVersion = %v, want argoproj.io/v1alpha1", app["apiVersion"])
	}
	if app["kind"] != "Application" {
		t.Errorf("kind = %v, want Application", app["kind"])
	}

	// Verify metadata
	metadata, ok := app["metadata"].(map[string]interface{})
	if !ok {
		t.Fatal("metadata is not a map")
	}
	if metadata["name"] != "test-chart" {
		t.Errorf("name = %v, want test-chart", metadata["name"])
	}
	if metadata["namespace"] != "argocd" {
		t.Errorf("namespace = %v, want argocd", metadata["namespace"])
	}

	// Verify ignoreDifferences is present
	spec, ok := app["spec"].(map[string]interface{})
	if !ok {
		t.Fatal("spec is not a map")
	}

	ignoreDiffs, ok := spec["ignoreDifferences"].([]interface{})
	if !ok {
		t.Fatal("ignoreDifferences is not a slice")
	}

	if len(ignoreDiffs) != 2 {
		t.Errorf("len(ignoreDifferences) = %d, want 2", len(ignoreDiffs))
	}

	// Verify webhook rule has jqPathExpressions
	for _, d := range ignoreDiffs {
		diff, ok := d.(map[string]interface{})
		if !ok {
			continue
		}
		if diff["kind"] == "MutatingWebhookConfiguration" {
			if diff["jqPathExpressions"] == nil {
				t.Error("webhook rule missing jqPathExpressions")
			}
		}
		if diff["kind"] == "Secret" {
			if diff["jsonPointers"] == nil {
				t.Error("secret rule missing jsonPointers")
			}
		}
	}

	// Verify syncPolicy
	syncPolicy, ok := spec["syncPolicy"].(map[string]interface{})
	if !ok {
		t.Fatal("syncPolicy is not a map")
	}

	if syncPolicy["automated"] == nil {
		t.Error("syncPolicy.automated is nil")
	}

	syncOpts, ok := syncPolicy["syncOptions"].([]interface{})
	if !ok || len(syncOpts) == 0 {
		t.Error("syncPolicy.syncOptions is empty")
	}
}

// BenchmarkRenderChart benchmarks chart rendering
func BenchmarkRenderChart(b *testing.B) {
	c := chartEntry{
		Name:         "kubedb",
		Version:      "v2026.2.26",
		Namespace:    "kubedb",
		RepoURL:      "ghcr.io/appscode-charts",
		AceUserRoles: true,
	}

	settings := cli.New()
	regClient, _ := newTestRegistryClient(settings)

	actionConfig := new(action.Configuration)
	actionConfig.Releases = storage.Init(driver.NewMemory())
	actionConfig.KubeClient = &testKubeClient{}
	actionConfig.Log = func(format string, v ...interface{}) {}
	actionConfig.RegistryClient = regClient

	values := map[string]interface{}{
		"ace-user-roles": map[string]interface{}{"enabled": false},
	}

	for i := 0; i < b.N; i++ {
		pullClient := action.NewPullWithOpts(action.WithConfig(actionConfig))
		pullClient.Version = c.Version
		pullClient.Settings = settings
		pullClient.SetRegistryClient(regClient)

		tmpDir := b.TempDir()
		pullClient.DestDir = tmpDir

		chartRef := fmt.Sprintf("oci://%s/%s", c.RepoURL, c.Name)
		pullClient.Run(chartRef)

		var chartPath string
		entries, _ := os.ReadDir(tmpDir)
		for _, e := range entries {
			if strings.HasSuffix(e.Name(), ".tgz") {
				chartPath = filepath.Join(tmpDir, e.Name())
				break
			}
		}

		chart, _ := loader.Load(chartPath)

		installClient := action.NewInstall(actionConfig)
		installClient.DryRunOption = "client"
		installClient.ReleaseName = c.Name
		installClient.Namespace = c.Namespace
		installClient.ClientOnly = true
		installClient.IncludeCRDs = true
		installClient.Replace = true
		installClient.SetRegistryClient(regClient)

		kv, _ := chartutil.ParseKubeVersion("v1.31.0")
		installClient.KubeVersion = kv

		installClient.RunWithContext(context.Background(), chart, values)
	}
}

// Helper to get rule key
func ruleKey(r IgnoreRule) string {
	return fmt.Sprintf("%s/%s/%s", r.Group, r.Kind, r.Name)
}

// diffResources is reused from main.go
func diffResourcesUnit(a, b *Resource) []string {
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
