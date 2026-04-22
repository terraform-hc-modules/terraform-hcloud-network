output "load_balancer" {
  description = "Load balancer attributes"
  value       = module.network.load_balancer
}

output "load_balancer_services" {
  description = "Created load balancer services keyed by index"
  value       = module.network.load_balancer_services
}

output "load_balancer_targets" {
  description = "Created load balancer targets keyed by index"
  value       = module.network.load_balancer_targets
}
