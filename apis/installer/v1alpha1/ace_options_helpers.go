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

package v1alpha1

import "strings"

func (r RegistrySpec) Configured() bool {
	return r.RegistryFQDN != ""
}

func (r RegistrySpec) DockerHubProxy() string {
	addr := r.Proxies.DockerHub
	if addr == "" {
		addr = r.RegistryFQDN
	}
	addr = strings.TrimSpace(addr)
	addr = strings.TrimSuffix(addr, "/")
	return addr
}

func (r RegistrySpec) DockerLibraryProxy() string {
	addr := r.Proxies.DockerLibrary
	if addr == "" {
		addr = r.Proxies.DockerHub
	}
	if addr == "" {
		addr = r.RegistryFQDN
	}
	addr = strings.TrimSpace(addr)
	addr = strings.TrimSuffix(addr, "/")
	return addr
}

func (r RegistrySpec) GHCRProxy() string {
	addr := r.Proxies.GHCR
	if addr == "" {
		addr = r.RegistryFQDN
	}
	addr = strings.TrimSpace(addr)
	addr = strings.TrimSuffix(addr, "/")
	return addr
}

func (r RegistrySpec) KubernetesRegistryProxy() string {
	addr := r.Proxies.Kubernetes
	if addr == "" {
		addr = r.RegistryFQDN
	}
	addr = strings.TrimSpace(addr)
	addr = strings.TrimSuffix(addr, "/")
	return addr
}

func (r RegistrySpec) AppsCodeRegistryProxy() string {
	addr := r.Proxies.AppsCode
	if addr == "" {
		addr = r.RegistryFQDN
	}
	addr = strings.TrimSpace(addr)
	addr = strings.TrimSuffix(addr, "/")
	return addr
}
