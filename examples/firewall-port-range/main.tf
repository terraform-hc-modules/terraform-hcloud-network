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
# Network Module - Firewall with Port Ranges
################################################################################

module "network" {
  source = "../../"

  name     = local.name
  ip_range = "10.20.0.0/16"
  labels   = local.tags

  subnets = [
    {
      ip_range     = "10.20.1.0/24"
      network_zone = "eu-central"
    }
  ]

  create_firewall = true
  firewall_name   = "${local.name}-edge"

  inbound_rules = [
    {
      description = "Allow SSH"
      protocol    = "tcp"
      port        = "22"
      source_ips  = ["0.0.0.0/0", "::/0"]
    },
    {
      description = "Allow NodePort range"
      protocol    = "tcp"
      port        = "30000-32767"
      source_ips  = ["10.20.0.0/16"]
    }
  ]

  outbound_rules = [
    {
      description = "Allow all outbound TCP"
      protocol    = "tcp"
      port        = "1-65535"
      destination_ips = [
        "0.0.0.0/0",
        "::/0",
      ]
    }
  ]
}
