# Load Balancer

Manages Hetzner Cloud Load Balancers, services, and targets.

Part of [`terraform-hc-modules/network/hcloud`](../../README.md). Prefer the root module for most use cases; use this submodule directly when you need fine-grained control over just load-balancer resources.

## Usage

```hcl
module "load-balancer" {
  source = "terraform-hc-modules/network/hcloud//modules/load-balancer"
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
| [hcloud_load_balancer.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer) | resource |
| [hcloud_load_balancer_network.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_network) | resource |
| [hcloud_load_balancer_service.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_service) | resource |
| [hcloud_load_balancer_target.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_algorithm"></a> [algorithm](#input\_algorithm) | Algorithm for the load balancer (round\_robin or least\_connections). | `string` | `"round_robin"` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create the load balancer. | `bool` | `true` | no |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | Enable delete protection. | `bool` | `false` | no |
| <a name="input_enable_public_interface"></a> [enable\_public\_interface](#input\_enable\_public\_interface) | Enable public interface. | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the load balancer. | `map(string)` | `{}` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Type of the load balancer. | `string` | `"lb11"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the load balancer. | `string` | `"fsn1"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the load balancer. | `string` | n/a | yes |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | Network ID to attach the load balancer to. | `number` | `null` | no |
| <a name="input_network_zone"></a> [network\_zone](#input\_network\_zone) | Network zone (alternative to location). | `string` | `null` | no |
| <a name="input_services"></a> [services](#input\_services) | List of services for the load balancer. | <pre>list(object({<br/>    protocol         = string<br/>    listen_port      = number<br/>    destination_port = number<br/>    proxyprotocol    = optional(bool, false)<br/>    health_check = optional(object({<br/>      protocol = string<br/>      port     = number<br/>      interval = optional(number, 15)<br/>      timeout  = optional(number, 10)<br/>      retries  = optional(number, 3)<br/>      http = optional(object({<br/>        domain       = optional(string)<br/>        path         = optional(string, "/")<br/>        response     = optional(string)<br/>        status_codes = optional(list(string), ["2??", "3??"])<br/>        tls          = optional(bool, false)<br/>      }))<br/>    }))<br/>    http = optional(object({<br/>      sticky_sessions = optional(bool, false)<br/>      cookie_name     = optional(string)<br/>      cookie_lifetime = optional(number)<br/>      certificates    = optional(list(number))<br/>      redirect_http   = optional(bool, false)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | List of targets for the load balancer. | <pre>list(object({<br/>    type           = string<br/>    server_id      = optional(number)<br/>    label_selector = optional(string)<br/>    ip             = optional(string)<br/>    use_private_ip = optional(bool, false)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ipv4"></a> [ipv4](#output\_ipv4) | IPv4 address of the load balancer. |
| <a name="output_ipv6"></a> [ipv6](#output\_ipv6) | IPv6 address of the load balancer. |
| <a name="output_load_balancer"></a> [load\_balancer](#output\_load\_balancer) | Load balancer attributes. |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | ID of the load balancer. |
| <a name="output_load_balancer_name"></a> [load\_balancer\_name](#output\_load\_balancer\_name) | Name of the load balancer. |
| <a name="output_network_attachment"></a> [network\_attachment](#output\_network\_attachment) | Load balancer network attachment attributes. |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | Network ID the load balancer is attached to. |
| <a name="output_network_ip"></a> [network\_ip](#output\_network\_ip) | Private IP in the network. |
| <a name="output_service_ids"></a> [service\_ids](#output\_service\_ids) | Map of load balancer service IDs keyed by index. |
| <a name="output_services"></a> [services](#output\_services) | Map of created load balancer services keyed by index. |
| <a name="output_target_ids"></a> [target\_ids](#output\_target\_ids) | Map of load balancer target IDs keyed by index. |
| <a name="output_targets"></a> [targets](#output\_targets) | Map of created load balancer targets keyed by index. |
<!-- END_TF_DOCS -->
