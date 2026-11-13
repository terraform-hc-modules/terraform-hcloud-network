################################################################################
# VPC
################################################################################

output "network_id" {
  description = "ID of the network."
  value       = module.vpc.network_id
}

output "network_name" {
  description = "Name of the network."
  value       = module.vpc.network_name
}

output "ip_range" {
  description = "IP range of the network."
  value       = module.vpc.ip_range
}

output "network" {
  description = "Network attributes."
  value       = module.vpc.network
}

output "subnet_ids" {
  description = "Map of subnet IDs."
  value       = module.vpc.subnet_ids
}

output "subnets" {
  description = "Map of created subnets keyed by index."
  value       = module.vpc.subnets
}

output "route_ids" {
  description = "Map of route IDs."
  value       = module.vpc.route_ids
}

output "routes" {
  description = "Map of created routes keyed by index."
  value       = module.vpc.routes
}

################################################################################
# Firewall
################################################################################

output "firewall_id" {
  description = "ID of the firewall."
  value       = module.firewall.firewall_id
}

output "firewall_name" {
  description = "Name of the firewall."
  value       = module.firewall.firewall_name
}

output "firewall" {
  description = "Firewall attributes."
  value       = module.firewall.firewall
}

output "firewall_attachment" {
  description = "Firewall attachment attributes."
  value       = module.firewall_attachment.firewall_attachment
}

################################################################################
# Load Balancer
################################################################################

output "load_balancer_id" {
  description = "ID of the load balancer."
  value       = module.load_balancer.load_balancer_id
}

output "load_balancer_ipv4" {
  description = "IPv4 address of the load balancer."
  value       = module.load_balancer.ipv4
}

output "load_balancer_ipv6" {
  description = "IPv6 address of the load balancer."
  value       = module.load_balancer.ipv6
}

output "load_balancer" {
  description = "Load balancer attributes."
  value       = module.load_balancer.load_balancer
}

output "load_balancer_network_attachment" {
  description = "Load balancer network attachment attributes."
  value       = module.load_balancer.network_attachment
}

output "load_balancer_service_ids" {
  description = "Map of load balancer service IDs keyed by index."
  value       = module.load_balancer.service_ids
}

output "load_balancer_services" {
  description = "Map of created load balancer services keyed by index."
  value       = module.load_balancer.services
}

output "load_balancer_target_ids" {
  description = "Map of load balancer target IDs keyed by index."
  value       = module.load_balancer.target_ids
}

output "load_balancer_targets" {
  description = "Map of created load balancer targets keyed by index."
  value       = module.load_balancer.targets
}
