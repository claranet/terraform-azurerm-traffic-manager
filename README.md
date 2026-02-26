# Traffic Manager
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/traffic-manager/azurerm/latest)

Azure module to deploy a [Traffic Manager](https://docs.microsoft.com/en-us/azure/xxxxxxx).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "traffic_manager" {
  source  = "claranet/traffic-manager/azurerm"
  version = "x.x.x"

  resource_group_name = module.rg.name

  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  traffic_routing_method = "Performance"

  dns_config = {
    relative_name = "my_traffic_manager_profile"
    ttl           = 100
  }

  monitor_config = {
    protocol                    = "HTTP"
    port                        = 80
    path                        = "/"
    expected_status_code_ranges = ["200-299"]
    custom_header = [
      {
        name  = "my-custom-header"
        value = "Content-Type"
      },
    ]
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2.29 |
| azurerm | ~> 4.31 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 8.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_traffic_manager_profile.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_profile) | resource |
| [azurecaf_name.traffic_manager](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_name | Custom Traffic Manager, generated if not set. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostics settings, name will be `default` if not set. | `string` | `"default"` | no |
| dns\_config | DNS configuration for the Traffic Manager profile. | <pre>object({<br/>    relative_name = string<br/>    ttl           = number<br/>  })</pre> | <pre>{<br/>  "relative_name": "",<br/>  "ttl": 30<br/>}</pre> | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add on resources. | `map(string)` | `{}` | no |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| max\_return | The amount of endpoints to return for DNS queries to this Profile. | `number` | `null` | no |
| monitor\_config | Monitor configuration for the Traffic Manager profile. | <pre>object({<br/>    protocol                    = string<br/>    port                        = number<br/>    path                        = optional(string)<br/>    expected_status_code_ranges = optional(list(string))<br/>    custom_header = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })))<br/>    interval_in_seconds          = optional(number)<br/>    timeout_in_seconds           = optional(number)<br/>    tolerated_number_of_failures = optional(number)<br/>  })</pre> | <pre>{<br/>  "custom_header": null,<br/>  "expected_status_code_ranges": [],<br/>  "interval_in_seconds": 30,<br/>  "port": 22,<br/>  "protocol": "TCP",<br/>  "timeout_in_seconds": 10,<br/>  "tolerated_number_of_failures": 3<br/>}</pre> | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| profile\_status | Whether to enable the profile. Possible values are `Enabled` or `Disabled`. | `string` | `"Enabled"` | no |
| resource\_group\_name | Name of the resource group. | `string` | n/a | yes |
| stack | Project stack name. | `string` | n/a | yes |
| traffic\_routing\_method | Specify which routing method is preferred between the following: `Geographic`, `Performance`, `Priority`, `Weighted`, `MultiValue`, `Subnet`. | `string` | `"Performance"` | no |
| traffic\_view\_enabled | Whether Traffic View is enabled for the Traffic Manager profile. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| fqdn | Traffic Manager FQDN. |
| id | Traffic Manager ID. |
| module\_diagnostics | Diagnostics settings module output. |
| name | Traffic Manager name. |
| resource | Traffic Manager output object. |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure documentation: xxxx
