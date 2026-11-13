mock_provider "hcloud" {
  override_during = plan

  # Numeric IDs so values passed between submodules as numbers stay known at plan.
  mock_resource "hcloud_firewall" {
    defaults = {
      id = "1001"
    }
  }

  mock_resource "hcloud_firewall_attachment" {
    defaults = {
      id = "3001"
    }
  }

  mock_resource "hcloud_load_balancer" {
    defaults = {
      id = "2001"
    }
  }

  mock_resource "hcloud_load_balancer_network" {
    defaults = {
      network_id = 12345
    }
  }
}

run "firewall_attachment_disabled_by_default" {
  command = plan

  variables {
    name            = "test"
    create_firewall = true
  }

  assert {
    condition     = module.firewall_attachment.firewall_attachment == null
    error_message = "Firewall attachment must not be created without server_ids or label_selectors."
  }
}

run "firewall_attachment_with_label_selector" {
  command = plan

  variables {
    name                     = "test"
    create_firewall          = true
    firewall_server_ids      = [101]
    firewall_label_selectors = ["role=web"]
  }

  assert {
    condition     = module.firewall_attachment.firewall_attachment.label_selectors == toset(["role=web"])
    error_message = "Firewall attachment must use the given label selectors."
  }

  assert {
    condition     = module.firewall_attachment.firewall_attachment.server_ids == toset([101])
    error_message = "Firewall attachment must use the given server IDs."
  }
}

run "load_balancer_subnet_ip_and_primary_ips" {
  command = plan

  variables {
    name                     = "test"
    create_load_balancer     = true
    load_balancer_subnet_id  = "12345-10.0.1.0/24"
    load_balancer_network_ip = "10.0.1.10"
    load_balancer_ipv4_id    = 111
    load_balancer_ipv6_id    = 222
  }

  assert {
    condition     = module.load_balancer.network_attachment.subnet_id == "12345-10.0.1.0/24"
    error_message = "Load balancer network attachment must use the given subnet_id."
  }

  assert {
    condition     = module.load_balancer.network_attachment.ip == "10.0.1.10"
    error_message = "Load balancer network attachment must use the given IP."
  }

  assert {
    condition     = module.load_balancer.load_balancer.ipv4_id == 111 && module.load_balancer.load_balancer.ipv6_id == 222
    error_message = "Load balancer must use the given Primary IP IDs."
  }
}

run "load_balancer_submodule_rejects_network_and_subnet" {
  command = plan

  module {
    source = "./modules/load-balancer"
  }

  variables {
    name       = "test"
    network_id = 12345
    subnet_id  = "12345-10.0.1.0/24"
  }

  expect_failures = [
    hcloud_load_balancer_network.this,
  ]
}

run "rejects_invalid_lb_network_ip" {
  command = plan

  variables {
    name                     = "test"
    load_balancer_network_ip = "not-an-ip"
  }

  expect_failures = [
    var.load_balancer_network_ip,
  ]
}
