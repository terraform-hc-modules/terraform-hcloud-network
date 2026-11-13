# Firewall Attachment

Attaches an existing Hetzner Cloud Firewall to servers by ID or label selector.

Part of [`terraform-hc-modules/network/hcloud`](../../README.md). Prefer the root module for most use cases; use this submodule directly when the firewall is managed elsewhere or you need to attach it separately from its rules.

## Usage

```hcl
module "firewall-attachment" {
  source = "terraform-hc-modules/network/hcloud//modules/firewall-attachment"
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
| [hcloud_firewall_attachment.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_firewall_id"></a> [firewall\_id](#input\_firewall\_id) | ID of the firewall to attach. | `number` | n/a | yes |
| <a name="input_create"></a> [create](#input\_create) | Whether to create the firewall attachment. | `bool` | `true` | no |
| <a name="input_label_selectors"></a> [label\_selectors](#input\_label\_selectors) | Set of label selectors whose matching servers get the firewall. | `set(string)` | `[]` | no |
| <a name="input_server_ids"></a> [server\_ids](#input\_server\_ids) | Set of server IDs to attach the firewall to. | `set(number)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_firewall_attachment"></a> [firewall\_attachment](#output\_firewall\_attachment) | Firewall attachment attributes. |
| <a name="output_id"></a> [id](#output\_id) | ID of the firewall attachment. |
<!-- END_TF_DOCS -->
