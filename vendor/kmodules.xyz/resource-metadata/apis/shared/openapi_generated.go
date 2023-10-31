//go:build !ignore_autogenerated
// +build !ignore_autogenerated

/*
Copyright AppsCode Inc. and Contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Code generated by openapi-gen. DO NOT EDIT.

// This file was autogenerated by openapi-gen. Do not edit it manually!

package shared

import (
	common "k8s.io/kube-openapi/pkg/common"
	spec "k8s.io/kube-openapi/pkg/validation/spec"
)

func GetOpenAPIDefinitions(ref common.ReferenceCallback) map[string]common.OpenAPIDefinition {
	return map[string]common.OpenAPIDefinition{
		"kmodules.xyz/resource-metadata/apis/shared.Action":               schema_kmodulesxyz_resource_metadata_apis_shared_Action(ref),
		"kmodules.xyz/resource-metadata/apis/shared.ActionGroup":          schema_kmodulesxyz_resource_metadata_apis_shared_ActionGroup(ref),
		"kmodules.xyz/resource-metadata/apis/shared.ActionInfo":           schema_kmodulesxyz_resource_metadata_apis_shared_ActionInfo(ref),
		"kmodules.xyz/resource-metadata/apis/shared.ActionTemplate":       schema_kmodulesxyz_resource_metadata_apis_shared_ActionTemplate(ref),
		"kmodules.xyz/resource-metadata/apis/shared.ActionTemplateGroup":  schema_kmodulesxyz_resource_metadata_apis_shared_ActionTemplateGroup(ref),
		"kmodules.xyz/resource-metadata/apis/shared.BootstrapPresets":     schema_kmodulesxyz_resource_metadata_apis_shared_BootstrapPresets(ref),
		"kmodules.xyz/resource-metadata/apis/shared.Dashboard":            schema_kmodulesxyz_resource_metadata_apis_shared_Dashboard(ref),
		"kmodules.xyz/resource-metadata/apis/shared.DashboardVar":         schema_kmodulesxyz_resource_metadata_apis_shared_DashboardVar(ref),
		"kmodules.xyz/resource-metadata/apis/shared.DeploymentParameters": schema_kmodulesxyz_resource_metadata_apis_shared_DeploymentParameters(ref),
		"kmodules.xyz/resource-metadata/apis/shared.HelmInfo":             schema_kmodulesxyz_resource_metadata_apis_shared_HelmInfo(ref),
		"kmodules.xyz/resource-metadata/apis/shared.HelmRelease":          schema_kmodulesxyz_resource_metadata_apis_shared_HelmRelease(ref),
		"kmodules.xyz/resource-metadata/apis/shared.HelmRepository":       schema_kmodulesxyz_resource_metadata_apis_shared_HelmRepository(ref),
		"kmodules.xyz/resource-metadata/apis/shared.If":                   schema_kmodulesxyz_resource_metadata_apis_shared_If(ref),
		"kmodules.xyz/resource-metadata/apis/shared.ImageRegistrySpec":    schema_kmodulesxyz_resource_metadata_apis_shared_ImageRegistrySpec(ref),
		"kmodules.xyz/resource-metadata/apis/shared.RegistryInfo":         schema_kmodulesxyz_resource_metadata_apis_shared_RegistryInfo(ref),
		"kmodules.xyz/resource-metadata/apis/shared.RegistryProxies":      schema_kmodulesxyz_resource_metadata_apis_shared_RegistryProxies(ref),
		"kmodules.xyz/resource-metadata/apis/shared.ResourceLocator":      schema_kmodulesxyz_resource_metadata_apis_shared_ResourceLocator(ref),
		"kmodules.xyz/resource-metadata/apis/shared.ResourceQuery":        schema_kmodulesxyz_resource_metadata_apis_shared_ResourceQuery(ref),
		"kmodules.xyz/resource-metadata/apis/shared.SourceLocator":        schema_kmodulesxyz_resource_metadata_apis_shared_SourceLocator(ref),
		"kmodules.xyz/resource-metadata/apis/shared.UIParameterTemplate":  schema_kmodulesxyz_resource_metadata_apis_shared_UIParameterTemplate(ref),
		"kmodules.xyz/resource-metadata/apis/shared.UIParameters":         schema_kmodulesxyz_resource_metadata_apis_shared_UIParameters(ref),
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_Action(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"name": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"description": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"icons": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Default: map[string]interface{}{},
										Ref:     ref("x-helm.dev/apimachinery/apis/shared.ImageSpec"),
									},
								},
							},
						},
					},
					"operationId": {
						SchemaProps: spec.SchemaProps{
							Default: "",
							Type:    []string{"string"},
							Format:  "",
						},
					},
					"flow": {
						SchemaProps: spec.SchemaProps{
							Default: "",
							Type:    []string{"string"},
							Format:  "",
						},
					},
					"disabled": {
						SchemaProps: spec.SchemaProps{
							Default: false,
							Type:    []string{"boolean"},
							Format:  "",
						},
					},
					"editor": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"),
						},
					},
				},
				Required: []string{"operationId", "flow", "disabled"},
			},
		},
		Dependencies: []string{
			"x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef", "x-helm.dev/apimachinery/apis/shared.ImageSpec"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_ActionGroup(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"name": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"description": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"items": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Default: map[string]interface{}{},
										Ref:     ref("kmodules.xyz/resource-metadata/apis/shared.Action"),
									},
								},
							},
						},
					},
				},
				Required: []string{"items"},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/resource-metadata/apis/shared.Action"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_ActionInfo(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"name": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"description": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
				},
			},
		},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_ActionTemplate(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"name": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"description": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"icons": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Default: map[string]interface{}{},
										Ref:     ref("x-helm.dev/apimachinery/apis/shared.ImageSpec"),
									},
								},
							},
						},
					},
					"operationId": {
						SchemaProps: spec.SchemaProps{
							Default: "",
							Type:    []string{"string"},
							Format:  "",
						},
					},
					"flow": {
						SchemaProps: spec.SchemaProps{
							Default: "",
							Type:    []string{"string"},
							Format:  "",
						},
					},
					"disabledTemplate": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"editor": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"),
						},
					},
					"enforceQuota": {
						SchemaProps: spec.SchemaProps{
							Default: false,
							Type:    []string{"boolean"},
							Format:  "",
						},
					},
				},
				Required: []string{"operationId", "flow", "enforceQuota"},
			},
		},
		Dependencies: []string{
			"x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef", "x-helm.dev/apimachinery/apis/shared.ImageSpec"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_ActionTemplateGroup(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"name": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"description": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"items": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Default: map[string]interface{}{},
										Ref:     ref("kmodules.xyz/resource-metadata/apis/shared.ActionTemplate"),
									},
								},
							},
						},
					},
				},
				Required: []string{"items"},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/resource-metadata/apis/shared.ActionTemplate"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_BootstrapPresets(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"image": {
						SchemaProps: spec.SchemaProps{
							Default: map[string]interface{}{},
							Ref:     ref("kmodules.xyz/resource-metadata/apis/shared.ImageRegistrySpec"),
						},
					},
					"registry": {
						SchemaProps: spec.SchemaProps{
							Default: map[string]interface{}{},
							Ref:     ref("kmodules.xyz/resource-metadata/apis/shared.RegistryInfo"),
						},
					},
					"helm": {
						SchemaProps: spec.SchemaProps{
							Default: map[string]interface{}{},
							Ref:     ref("kmodules.xyz/resource-metadata/apis/shared.HelmInfo"),
						},
					},
				},
				Required: []string{"image", "registry", "helm"},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/resource-metadata/apis/shared.HelmInfo", "kmodules.xyz/resource-metadata/apis/shared.ImageRegistrySpec", "kmodules.xyz/resource-metadata/apis/shared.RegistryInfo"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_Dashboard(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"title": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"vars": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Default: map[string]interface{}{},
										Ref:     ref("kmodules.xyz/resource-metadata/apis/shared.DashboardVar"),
									},
								},
							},
						},
					},
					"panels": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Default: "",
										Type:    []string{"string"},
										Format:  "",
									},
								},
							},
						},
					},
					"if": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("kmodules.xyz/resource-metadata/apis/shared.If"),
						},
					},
				},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/resource-metadata/apis/shared.DashboardVar", "kmodules.xyz/resource-metadata/apis/shared.If"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_DashboardVar(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"name": {
						SchemaProps: spec.SchemaProps{
							Default: "",
							Type:    []string{"string"},
							Format:  "",
						},
					},
					"value": {
						SchemaProps: spec.SchemaProps{
							Default: "",
							Type:    []string{"string"},
							Format:  "",
						},
					},
					"type": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
				},
				Required: []string{"name", "value"},
			},
		},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_DeploymentParameters(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"productID": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"planID": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"chart": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"),
						},
					},
				},
			},
		},
		Dependencies: []string{
			"x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_HelmInfo(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"repositories": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"object"},
							AdditionalProperties: &spec.SchemaOrBool{
								Allows: true,
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Ref: ref("kmodules.xyz/resource-metadata/apis/shared.HelmRepository"),
									},
								},
							},
						},
					},
					"releases": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"object"},
							AdditionalProperties: &spec.SchemaOrBool{
								Allows: true,
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Ref: ref("kmodules.xyz/resource-metadata/apis/shared.HelmRelease"),
									},
								},
							},
						},
					},
				},
				Required: []string{"repositories", "releases"},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/resource-metadata/apis/shared.HelmRelease", "kmodules.xyz/resource-metadata/apis/shared.HelmRepository"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_HelmRelease(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"enabled": {
						SchemaProps: spec.SchemaProps{
							Default: false,
							Type:    []string{"boolean"},
							Format:  "",
						},
					},
					"version": {
						SchemaProps: spec.SchemaProps{
							Default: "",
							Type:    []string{"string"},
							Format:  "",
						},
					},
					"values": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("k8s.io/apimachinery/pkg/runtime.RawExtension"),
						},
					},
				},
				Required: []string{"enabled", "version"},
			},
		},
		Dependencies: []string{
			"k8s.io/apimachinery/pkg/runtime.RawExtension"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_HelmRepository(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"url": {
						SchemaProps: spec.SchemaProps{
							Description: "URL of the Helm repository, a valid URL contains at least a protocol and host.",
							Default:     "",
							Type:        []string{"string"},
							Format:      "",
						},
					},
					"secretName": {
						SchemaProps: spec.SchemaProps{
							Description: "SecretRef specifies the Secret containing authentication credentials for the HelmRepository. For HTTP/S basic auth the secret must contain 'username' and 'password' fields. For TLS the secret must contain a 'certFile' and 'keyFile', and/or 'caFile' fields.",
							Type:        []string{"string"},
							Format:      "",
						},
					},
					"interval": {
						SchemaProps: spec.SchemaProps{
							Description: "Interval at which to check the URL for updates.",
							Ref:         ref("k8s.io/apimachinery/pkg/apis/meta/v1.Duration"),
						},
					},
					"timeout": {
						SchemaProps: spec.SchemaProps{
							Description: "The timeout of index downloading, defaults to 60s.",
							Ref:         ref("k8s.io/apimachinery/pkg/apis/meta/v1.Duration"),
						},
					},
					"type": {
						SchemaProps: spec.SchemaProps{
							Description: "Type of the HelmRepository. When this field is set to  \"oci\", the URL field value must be prefixed with \"oci://\".",
							Type:        []string{"string"},
							Format:      "",
						},
					},
					"provider": {
						SchemaProps: spec.SchemaProps{
							Description: "Provider used for authentication, can be 'aws', 'azure', 'gcp' or 'generic'. This field is optional, and only taken into account if the .spec.type field is set to 'oci'. When not specified, defaults to 'generic'.",
							Type:        []string{"string"},
							Format:      "",
						},
					},
				},
				Required: []string{"url"},
			},
		},
		Dependencies: []string{
			"k8s.io/apimachinery/pkg/apis/meta/v1.Duration"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_If(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"condition": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"connected": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("kmodules.xyz/resource-metadata/apis/shared.ResourceLocator"),
						},
					},
				},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/resource-metadata/apis/shared.ResourceLocator"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_ImageRegistrySpec(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"proxies": {
						SchemaProps: spec.SchemaProps{
							Default: map[string]interface{}{},
							Ref:     ref("kmodules.xyz/resource-metadata/apis/shared.RegistryProxies"),
						},
					},
				},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/resource-metadata/apis/shared.RegistryProxies"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_RegistryInfo(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"credentials": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"object"},
							AdditionalProperties: &spec.SchemaOrBool{
								Allows: true,
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Default: "",
										Type:    []string{"string"},
										Format:  "",
									},
								},
							},
						},
					},
				},
			},
		},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_RegistryProxies(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"dockerHub": {
						SchemaProps: spec.SchemaProps{
							Description: "company/bin:1.23",
							Default:     "",
							Type:        []string{"string"},
							Format:      "",
						},
					},
					"dockerLibrary": {
						SchemaProps: spec.SchemaProps{
							Description: "alpine, nginx etc.",
							Default:     "",
							Type:        []string{"string"},
							Format:      "",
						},
					},
					"ghcr": {
						SchemaProps: spec.SchemaProps{
							Description: "ghcr.io",
							Default:     "",
							Type:        []string{"string"},
							Format:      "",
						},
					},
					"quay": {
						SchemaProps: spec.SchemaProps{
							Description: "quay.io",
							Default:     "",
							Type:        []string{"string"},
							Format:      "",
						},
					},
					"kubernetes": {
						SchemaProps: spec.SchemaProps{
							Description: "registry.k8s.io",
							Default:     "",
							Type:        []string{"string"},
							Format:      "",
						},
					},
					"appscode": {
						SchemaProps: spec.SchemaProps{
							Description: "r.appscode.com",
							Default:     "",
							Type:        []string{"string"},
							Format:      "",
						},
					},
				},
			},
		},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_ResourceLocator(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"ref": {
						SchemaProps: spec.SchemaProps{
							Default: map[string]interface{}{},
							Ref:     ref("k8s.io/apimachinery/pkg/apis/meta/v1.GroupKind"),
						},
					},
					"query": {
						SchemaProps: spec.SchemaProps{
							Default: map[string]interface{}{},
							Ref:     ref("kmodules.xyz/resource-metadata/apis/shared.ResourceQuery"),
						},
					},
				},
				Required: []string{"ref", "query"},
			},
		},
		Dependencies: []string{
			"k8s.io/apimachinery/pkg/apis/meta/v1.GroupKind", "kmodules.xyz/resource-metadata/apis/shared.ResourceQuery"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_ResourceQuery(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"type": {
						SchemaProps: spec.SchemaProps{
							Default: "",
							Type:    []string{"string"},
							Format:  "",
						},
					},
					"byLabel": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
					"raw": {
						SchemaProps: spec.SchemaProps{
							Type:   []string{"string"},
							Format: "",
						},
					},
				},
				Required: []string{"type"},
			},
		},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_SourceLocator(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"resource": {
						SchemaProps: spec.SchemaProps{
							Default: map[string]interface{}{},
							Ref:     ref("kmodules.xyz/client-go/api/v1.ResourceID"),
						},
					},
					"ref": {
						SchemaProps: spec.SchemaProps{
							Default: map[string]interface{}{},
							Ref:     ref("kmodules.xyz/client-go/api/v1.ObjectReference"),
						},
					},
				},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/client-go/api/v1.ObjectReference", "kmodules.xyz/client-go/api/v1.ResourceID"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_UIParameterTemplate(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"options": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"),
						},
					},
					"editor": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"),
						},
					},
					"enforceQuota": {
						SchemaProps: spec.SchemaProps{
							Default: false,
							Type:    []string{"boolean"},
							Format:  "",
						},
					},
					"actions": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Ref: ref("kmodules.xyz/resource-metadata/apis/shared.ActionTemplateGroup"),
									},
								},
							},
						},
					},
					"instanceLabelPaths": {
						SchemaProps: spec.SchemaProps{
							Description: "app.kubernetes.io/instance label must be updated at these paths when refilling metadata",
							Type:        []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Default: "",
										Type:    []string{"string"},
										Format:  "",
									},
								},
							},
						},
					},
				},
				Required: []string{"enforceQuota"},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/resource-metadata/apis/shared.ActionTemplateGroup", "x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"},
	}
}

func schema_kmodulesxyz_resource_metadata_apis_shared_UIParameters(ref common.ReferenceCallback) common.OpenAPIDefinition {
	return common.OpenAPIDefinition{
		Schema: spec.Schema{
			SchemaProps: spec.SchemaProps{
				Type: []string{"object"},
				Properties: map[string]spec.Schema{
					"options": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"),
						},
					},
					"editor": {
						SchemaProps: spec.SchemaProps{
							Ref: ref("x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"),
						},
					},
					"actions": {
						SchemaProps: spec.SchemaProps{
							Type: []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Ref: ref("kmodules.xyz/resource-metadata/apis/shared.ActionGroup"),
									},
								},
							},
						},
					},
					"instanceLabelPaths": {
						SchemaProps: spec.SchemaProps{
							Description: "app.kubernetes.io/instance label must be updated at these paths when refilling metadata",
							Type:        []string{"array"},
							Items: &spec.SchemaOrArray{
								Schema: &spec.Schema{
									SchemaProps: spec.SchemaProps{
										Default: "",
										Type:    []string{"string"},
										Format:  "",
									},
								},
							},
						},
					},
				},
			},
		},
		Dependencies: []string{
			"kmodules.xyz/resource-metadata/apis/shared.ActionGroup", "x-helm.dev/apimachinery/apis/releases/v1alpha1.ChartSourceRef"},
	}
}
