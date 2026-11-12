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
# Network Module - Firewall Attached by Label Selector
################################################################################

module "network" {
  source = "../../"

  name   = local.name
  labels = local.tags

  create_vpc = false

  create_firewall = true
  inbound_rules = [
    {
      description = "Allow SSH"
      protocol    = "tcp"
      port        = "22"
      source_ips  = ["0.0.0.0/0", "::/0"]
    }
  ]

  # Attach the firewall to every server labelled role=web
  firewall_label_selectors = ["role=web"]
}

output "firewall_id" {
  description = "ID of the firewall"
  value       = module.network.firewall_id
}

output "firewall_attachment" {
  description = "Firewall attachment attributes"
  value       = module.network.firewall_attachment
}
