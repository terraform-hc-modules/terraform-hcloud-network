output "firewall" {
  description = "Firewall attributes"
  value       = module.network.firewall
}

output "firewall_id" {
  description = "Firewall id"
  value       = module.network.firewall_id
}
