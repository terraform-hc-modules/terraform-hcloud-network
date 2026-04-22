output "network" {
  description = "Network attributes"
  value       = module.network.network
}

output "subnets" {
  description = "Created subnets keyed by index"
  value       = module.network.subnets
}

output "routes" {
  description = "Created routes keyed by index"
  value       = module.network.routes
}
