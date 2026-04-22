mock_provider "hcloud" {
  override_during = plan
}

run "rejects_empty_name" {
  command = plan

  variables {
    name = ""
  }

  expect_failures = [
    var.name,
  ]
}

run "rejects_invalid_ip_range" {
  command = plan

  variables {
    name     = "test"
    ip_range = "not-a-cidr"
  }

  expect_failures = [
    var.ip_range,
  ]
}

run "rejects_invalid_subnet_zone" {
  command = plan

  variables {
    name     = "test"
    ip_range = "10.0.0.0/16"
    subnets = [
      {
        ip_range     = "10.0.1.0/24"
        network_zone = "moon-1"
      }
    ]
  }

  expect_failures = [
    var.subnets,
  ]
}

run "rejects_invalid_lb_algorithm" {
  command = plan

  variables {
    name                    = "test"
    create_load_balancer    = true
    load_balancer_location  = "fsn1"
    load_balancer_algorithm = "random"
  }

  expect_failures = [
    var.load_balancer_algorithm,
  ]
}
