provider "hcloud" {}

locals {
  name = "ex-${basename(path.cwd)}"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-hcloud-network"
    GithubOrg  = "terraform-hc-modules"
  }
}

################################################################################
# Network Module - Load Balancer on Private Network
################################################################################

module "network" {
  source = "../../"

  name     = local.name
  ip_range = "10.30.0.0/16"
  labels   = local.tags

  subnets = [
    {
      ip_range     = "10.30.1.0/24"
      network_zone = "eu-central"
    }
  ]

  create_load_balancer    = true
  load_balancer_type      = "lb11"
  load_balancer_location  = "fsn1"
  load_balancer_algorithm = "least_connections"
  load_balancer_name      = "${local.name}-lb"

  load_balancer_services = [
    {
      protocol         = "http"
      listen_port      = 80
      destination_port = 8080
      health_check = {
        protocol = "http"
        port     = 8080
        http = {
          path = "/health"
        }
      }
      http = {
        sticky_sessions = true
        cookie_name     = "route"
        cookie_lifetime = 300
      }
    }
  ]

  load_balancer_targets = [
    {
      type           = "label_selector"
      label_selector = "service=web"
      use_private_ip = true
    }
  ]
}
