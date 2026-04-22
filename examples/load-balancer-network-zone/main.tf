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
# Network Module - Load Balancer using Network Zone
################################################################################

module "network" {
  source = "../../"

  name     = local.name
  ip_range = "10.40.0.0/16"
  labels   = local.tags

  subnets = [
    {
      ip_range     = "10.40.1.0/24"
      network_zone = "us-east"
    }
  ]

  create_load_balancer    = true
  load_balancer_type      = "lb11"
  load_balancer_location  = "fsn1"
  load_balancer_name      = "${local.name}-lb"
  load_balancer_algorithm = "round_robin"

  # Note: module uses `load_balancer_location` (location) today; this example
  # focuses on creating resources in a non-default network zone via subnets.
  load_balancer_services = [
    {
      protocol         = "tcp"
      listen_port      = 443
      destination_port = 443
    }
  ]
}
