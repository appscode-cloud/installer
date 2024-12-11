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
	"errors"
	"path/filepath"
	"runtime"
	"testing"

	"kmodules.xyz/image-packer/pkg/lib"
)

func Test_CheckImageArchitectures(t *testing.T) {
	dir, err := rootDir()
	if err != nil {
		t.Error(err)
	}

	if err := lib.CheckImageArchitectures([]string{
		filepath.Join(dir, "catalog", "ace.yaml"),
		filepath.Join(dir, "catalog", "editor-charts.yaml"),
		filepath.Join(dir, "catalog", "feature-charts.yaml"),
		filepath.Join(dir, "catalog", "imagelist.yaml"),
		filepath.Join(dir, "catalog", "reusable-ui-charts.yaml"),
	}, []string{
		"ghcr.io/appscode/billing-ui:0.2.3",
		"ghcr.io/appscode/deploy-ui:0.3.6-rc.1",
		"ghcr.io/appscode/inbox-server:latest",
		"ghcr.io/appscode/inbox-ui:0.0.2",
		"ghcr.io/appscode/marketplace-ui:0.3.1-rc.1",
		"ghcr.io/kluster-manager/addon-manager:v0.14.0",
		"ghcr.io/kluster-manager/cluster-gateway-manager:v1.9.2",
		"ghcr.io/kluster-manager/cluster-gateway:v1.9.2",
		"ghcr.io/kluster-manager/cluster-proxy:v0.5.0",
		"ghcr.io/kluster-manager/clusteradm:v0.9.0",
		"ghcr.io/kluster-manager/managed-serviceaccount:v0.6.0",
		"ghcr.io/kluster-manager/multicluster-controlplane:latest",
		"ghcr.io/kluster-manager/placement:v0.14.0",
		"ghcr.io/kluster-manager/registration-operator:v0.14.0",
		"ghcr.io/kluster-manager/registration:v0.14.0",
		"ghcr.io/kluster-manager/work:v0.14.0",
	}); err != nil {
		t.Errorf("CheckImageArchitectures() error = %v", err)
	}
}

func rootDir() (string, error) {
	_, file, _, ok := runtime.Caller(1)
	if !ok {
		return "", errors.New("failed to locate root dir")
	}

	return filepath.Clean(filepath.Join(filepath.Dir(file), "..")), nil
}
