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
	"os"
	"path/filepath"
	"runtime"
	"testing"

	"go.bytebuilders.dev/installer/apis/installer/v1alpha1"

	shell "gomodules.xyz/go-sh"
	"gopkg.in/yaml.v3"
)

func Test_checkVersions(t *testing.T) {
	if err := checkVersions(); err != nil {
		t.Errorf("checkVersions() error = %v", err)
	}
}

func checkVersions() error {
	_, file, _, ok := runtime.Caller(1)
	if !ok {
		return errors.New("failed to locate opscenter-features/values.yaml")
	}

	data, err := os.ReadFile(filepath.Join(filepath.Dir(file), "../charts/opscenter-features/values.yaml"))
	if err != nil {
		return err
	}

	var spec v1alpha1.OpscenterFeaturesSpec
	err = yaml.Unmarshal(data, &spec)
	if err != nil {
		return err
	}

	sh := shell.NewSession()
	sh.SetDir("/tmp")
	sh.ShowCMD = true

	for k, v := range spec.Helm.Releases {
		// helm pull appscode/ace-installer --version=v2023.03.23
		fullname := "oci://ghcr.io/appscode-charts/" + k
		err := sh.Command("helm", "pull", fullname, "--version", v.Version).Run()
		if err != nil {
			return err
		}
	}
	return nil
}
