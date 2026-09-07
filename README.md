# Hetzner Cloud Network Module

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-blueviolet)](https://www.terraform.io/)
[![License: MPL-2.0](https://img.shields.io/badge/License-MPL--2.0-blue.svg)](https://opensource.org/licenses/MPL-2.0)
[![CI](https://github.com/terraform-hc-modules/terraform-hcloud-network/actions/workflows/ci.yml/badge.svg)](https://github.com/terraform-hc-modules/terraform-hcloud-network/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/terraform-hc-modules/terraform-hcloud-network)](https://github.com/terraform-hc-modules/terraform-hcloud-network/releases)


Terraform module for comprehensive networking on Hetzner Cloud including VPC, Firewall, and Load Balancer.

## Usage

### Complete Example

```hcl
module "network" {
  source  = "terraform-hc-modules/network/hcloud"
  version = "~> 0.1"

  name     = "my-vpc"
  ip_range = "10.0.0.0/16"

  subnets = [
    {
      ip_range     = "10.0.1.0/24"
      network_zone = "eu-central"
    }
  ]

  create_firewall = true
  inbound_rules = [
    {
      protocol   = "tcp"
      port       = "22"
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  ]

  create_load_balancer = true
  load_balancer_services = [
    {
      protocol         = "http"
      listen_port      = 80
      destination_port = 80
    }
  ]

  labels = {
    Environment = "production"
  }
}
```

### Using Submodules Individually

```hcl
# VPC only
module "vpc" {
  source  = "terraform-hc-modules/network/hcloud//modules/vpc"
  version = "~> 0.1"

  name     = "my-vpc"
  ip_range = "10.0.0.0/16"
  subnets  = [...]
}

# Firewall only
module "firewall" {
  source  = "terraform-hc-modules/network/hcloud//modules/firewall"
  version = "~> 0.1"

  name          = "my-firewall"
  inbound_rules = [...]
}

# Load Balancer only
module "lb" {
  source  = "terraform-hc-modules/network/hcloud//modules/load-balancer"
  version = "~> 0.1"

  name     = "my-lb"
  services = [...]
  targets  = [...]
}
```

## Submodules

| Module | Description |
|--------|-------------|
| [vpc](modules/vpc) | Network, subnets, and routes |
| [firewall](modules/firewall) | Firewall and rules |
| [load-balancer](modules/load-balancer) | Load balancer, services, and targets |

## Examples

- [Simple](examples/simple) - VPC only
- [Complete](examples/complete) - VPC + Firewall + Load Balancer
- [Firewall Only](examples/firewall-only) - Standalone firewall

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.45 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | ./modules/firewall | n/a |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | ./modules/load-balancer | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for resources. | `string` | n/a | yes |
| <a name="input_create_firewall"></a> [create\_firewall](#input\_create\_firewall) | Whether to create the firewall. | `bool` | `false` | no |
| <a name="input_create_load_balancer"></a> [create\_load\_balancer](#input\_create\_load\_balancer) | Whether to create the load balancer. | `bool` | `false` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Whether to create the VPC. | `bool` | `true` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Name of the firewall. Defaults to name-firewall. | `string` | `null` | no |
| <a name="input_inbound_rules"></a> [inbound\_rules](#input\_inbound\_rules) | List of inbound firewall rules. | <pre>list(object({<br/>    description     = optional(string)<br/>    protocol        = string<br/>    port            = optional(string)<br/>    source_ips      = optional(list(string), ["0.0.0.0/0", "::/0"])<br/>    destination_ips = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_ip_range"></a> [ip\_range](#input\_ip\_range) | IP range of the network. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_load_balancer_algorithm"></a> [load\_balancer\_algorithm](#input\_load\_balancer\_algorithm) | Algorithm for the load balancer. | `string` | `"round_robin"` | no |
| <a name="input_load_balancer_location"></a> [load\_balancer\_location](#input\_load\_balancer\_location) | Location of the load balancer. | `string` | `"fsn1"` | no |
| <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name) | Name of the load balancer. Defaults to name-lb. | `string` | `null` | no |
| <a name="input_load_balancer_services"></a> [load\_balancer\_services](#input\_load\_balancer\_services) | List of services for the load balancer. | <pre>list(object({<br/>    protocol         = string<br/>    listen_port      = number<br/>    destination_port = number<br/>    proxyprotocol    = optional(bool, false)<br/>    health_check = optional(object({<br/>      protocol = string<br/>      port     = number<br/>      interval = optional(number, 15)<br/>      timeout  = optional(number, 10)<br/>      retries  = optional(number, 3)<br/>      http = optional(object({<br/>        domain       = optional(string)<br/>        path         = optional(string, "/")<br/>        response     = optional(string)<br/>        status_codes = optional(list(string), ["2??", "3??"])<br/>        tls          = optional(bool, false)<br/>      }))<br/>    }))<br/>    http = optional(object({<br/>      sticky_sessions = optional(bool, false)<br/>      cookie_name     = optional(string)<br/>      cookie_lifetime = optional(number)<br/>      certificates    = optional(list(number))<br/>      redirect_http   = optional(bool, false)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_load_balancer_targets"></a> [load\_balancer\_targets](#input\_load\_balancer\_targets) | List of targets for the load balancer. | <pre>list(object({<br/>    type           = string<br/>    server_id      = optional(number)<br/>    label_selector = optional(string)<br/>    ip             = optional(string)<br/>    use_private_ip = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Type of the load balancer. | `string` | `"lb11"` | no |
| <a name="input_outbound_rules"></a> [outbound\_rules](#input\_outbound\_rules) | List of outbound firewall rules. | <pre>list(object({<br/>    description     = optional(string)<br/>    protocol        = string<br/>    port            = optional(string)<br/>    source_ips      = optional(list(string))<br/>    destination_ips = optional(list(string), ["0.0.0.0/0", "::/0"])<br/>  }))</pre> | `[]` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | List of routes to create. | <pre>list(object({<br/>    destination = string<br/>    gateway     = string<br/>  }))</pre> | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets to create. | <pre>list(object({<br/>    ip_range     = string<br/>    network_zone = string<br/>    type         = optional(string, "cloud")<br/>    vswitch_id   = optional(number)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_firewall"></a> [firewall](#output\_firewall) | Firewall attributes. |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | ID of the firewall. |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | Name of the firewall. |
| <a name="output_ip_range"></a> [ip\_range](#output\_ip\_range) | IP range of the network. |
| <a name="output_load_balancer"></a> [load\_balancer](#output\_load\_balancer) | Load balancer attributes. |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | ID of the load balancer. |
| <a name="output_load_balancer_ipv4"></a> [load\_balancer\_ipv4](#output\_load\_balancer\_ipv4) | IPv4 address of the load balancer. |
| <a name="output_load_balancer_ipv6"></a> [load\_balancer\_ipv6](#output\_load\_balancer\_ipv6) | IPv6 address of the load balancer. |
| <a name="output_load_balancer_network_attachment"></a> [load\_balancer\_network\_attachment](#output\_load\_balancer\_network\_attachment) | Load balancer network attachment attributes. |
| <a name="output_load_balancer_service_ids"></a> [load\_balancer\_service\_ids](#output\_load\_balancer\_service\_ids) | Map of load balancer service IDs keyed by index. |
| <a name="output_load_balancer_services"></a> [load\_balancer\_services](#output\_load\_balancer\_services) | Map of created load balancer services keyed by index. |
| <a name="output_load_balancer_target_ids"></a> [load\_balancer\_target\_ids](#output\_load\_balancer\_target\_ids) | Map of load balancer target IDs keyed by index. |
| <a name="output_load_balancer_targets"></a> [load\_balancer\_targets](#output\_load\_balancer\_targets) | Map of created load balancer targets keyed by index. |
| <a name="output_network"></a> [network](#output\_network) | Network attributes. |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | ID of the network. |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Name of the network. |
| <a name="output_route_ids"></a> [route\_ids](#output\_route\_ids) | Map of route IDs. |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of created routes keyed by index. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet IDs. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Map of created subnets keyed by index. |
<!-- END_TF_DOCS -->

## License

Mozilla Public License 2.0 - see [LICENSE](LICENSE)
