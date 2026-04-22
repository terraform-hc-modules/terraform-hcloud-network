# Firewall

Manages Hetzner Cloud Firewalls and rules.

Part of [`terraform-hc-modules/network/hcloud`](../../README.md). Prefer the root module for most use cases; use this submodule directly when you need fine-grained control over just firewall resources.

## Usage

```hcl
module "firewall" {
  source = "terraform-hc-modules/network/hcloud//modules/firewall"
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
| [hcloud_firewall.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_apply_to"></a> [apply\_to](#input\_apply\_to) | Resources to apply the firewall to. | <pre>list(object({<br/>    label_selector = optional(string)<br/>    server         = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create the firewall. | `bool` | `true` | no |
| <a name="input_inbound_rules"></a> [inbound\_rules](#input\_inbound\_rules) | List of inbound firewall rules. | <pre>list(object({<br/>    description     = optional(string)<br/>    direction       = optional(string, "in")<br/>    protocol        = string<br/>    port            = optional(string)<br/>    source_ips      = optional(list(string), ["0.0.0.0/0", "::/0"])<br/>    destination_ips = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the firewall. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the firewall. | `string` | n/a | yes |
| <a name="input_outbound_rules"></a> [outbound\_rules](#input\_outbound\_rules) | List of outbound firewall rules. | <pre>list(object({<br/>    description     = optional(string)<br/>    direction       = optional(string, "out")<br/>    protocol        = string<br/>    port            = optional(string)<br/>    source_ips      = optional(list(string))<br/>    destination_ips = optional(list(string), ["0.0.0.0/0", "::/0"])<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_firewall"></a> [firewall](#output\_firewall) | Firewall attributes. |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | ID of the firewall. |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | Name of the firewall. |
<!-- END_TF_DOCS -->
