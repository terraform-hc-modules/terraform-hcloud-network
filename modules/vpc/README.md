# Vpc

Manages Hetzner Cloud private networks and subnets.

Part of [`terraform-hc-modules/network/hcloud`](../../README.md). Prefer the root module for most use cases; use this submodule directly when you need fine-grained control over just vpc resources.

## Usage

```hcl
module "vpc" {
  source = "terraform-hc-modules/network/hcloud//modules/vpc"
  # version = "~> 0.1"

  # See inputs below.
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.45 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | >= 1.45 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [hcloud_network.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network) | resource |
| [hcloud_network_route.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_route) | resource |
| [hcloud_network_subnet.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_create"></a> [create](#input\_create) | Whether to create the network. | `bool` | `true` | no |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | Enable delete protection. | `bool` | `false` | no |
| <a name="input_expose_routes_to_vswitch"></a> [expose\_routes\_to\_vswitch](#input\_expose\_routes\_to\_vswitch) | Enable routing from vSwitch. | `bool` | `false` | no |
| <a name="input_ip_range"></a> [ip\_range](#input\_ip\_range) | IP range of the network (CIDR notation). | `string` | `"10.0.0.0/16"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the network. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the network. | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | List of routes to create. | <pre>list(object({<br/>    destination = string<br/>    gateway     = string<br/>  }))</pre> | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets to create. | <pre>list(object({<br/>    ip_range     = string<br/>    network_zone = string<br/>    type         = optional(string, "cloud")<br/>    vswitch_id   = optional(number)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ip_range"></a> [ip\_range](#output\_ip\_range) | IP range of the network. |
| <a name="output_network"></a> [network](#output\_network) | Network attributes. |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | ID of the network. |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Name of the network. |
| <a name="output_route_ids"></a> [route\_ids](#output\_route\_ids) | Map of route IDs. |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of created routes keyed by index. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet IDs. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Map of created subnets keyed by index. |
<!-- END_TF_DOCS -->
