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
# Network Module - Routes & Subnets
################################################################################

module "network" {
  source = "../../"

  name     = local.name
  ip_range = "10.10.0.0/16"
  labels   = local.tags

  subnets = [
    {
      ip_range     = "10.10.1.0/24"
      network_zone = "eu-central"
    },
    {
      ip_range     = "10.10.2.0/24"
      network_zone = "eu-central"
    }
  ]

  routes = [
    {
      destination = "10.200.0.0/16"
      gateway     = "10.10.1.1"
    },
    {
      destination = "10.201.0.0/16"
      gateway     = "10.10.2.1"
    }
  ]
}
