output "network" {
  description = "Network attributes"
  value       = module.network.network
}

output "load_balancer" {
  description = "Load balancer attributes"
  value       = module.network.load_balancer
}
