provider "hcloud" {
  token = "dummy"
}

variables {
  name     = "test-network"
  ip_range = "10.99.0.0/16"

  labels = {
    test = "true"
  }

  subnets = [
    {
      ip_range     = "10.99.1.0/24"
      network_zone = "eu-central"
    }
  ]

  create_firewall = true
  inbound_rules = [
    {
      protocol   = "tcp"
      port       = "22"
      source_ips = ["0.0.0.0/0"]
    }
  ]

  create_load_balancer = false
}

run "plan_offline" {
  command = plan

  plan_options {
    refresh = false
  }
}
