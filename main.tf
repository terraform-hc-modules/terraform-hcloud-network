################################################################################
# VPC
################################################################################

module "vpc" {
  source = "./modules/vpc"

  create = var.create_vpc

  name     = var.name
  ip_range = var.ip_range
  labels   = var.labels
  subnets  = var.subnets
  routes   = var.routes
}

################################################################################
# Firewall
################################################################################

module "firewall" {
  source = "./modules/firewall"

  create = var.create_firewall

  name           = coalesce(var.firewall_name, "${var.name}-firewall")
  labels         = var.labels
  inbound_rules  = var.inbound_rules
  outbound_rules = var.outbound_rules
}

module "firewall_attachment" {
  source = "./modules/firewall-attachment"

  create = var.create_firewall && (length(var.firewall_server_ids) > 0 || length(var.firewall_label_selectors) > 0)

  firewall_id     = module.firewall.firewall_id
  server_ids      = var.firewall_server_ids
  label_selectors = var.firewall_label_selectors
}

################################################################################
# Load Balancer
################################################################################

module "load_balancer" {
  source = "./modules/load-balancer"

  create = var.create_load_balancer

  name               = coalesce(var.load_balancer_name, "${var.name}-lb")
  load_balancer_type = var.load_balancer_type
  location           = var.load_balancer_location
  labels             = var.labels
  algorithm          = var.load_balancer_algorithm
  network_id         = var.create_vpc && var.load_balancer_subnet_id == null ? module.vpc.network_id : null
  subnet_id          = var.load_balancer_subnet_id
  network_ip         = var.load_balancer_network_ip
  ipv4_id            = var.load_balancer_ipv4_id
  ipv6_id            = var.load_balancer_ipv6_id
  services           = var.load_balancer_services
  targets            = var.load_balancer_targets
}
