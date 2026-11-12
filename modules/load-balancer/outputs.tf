output "load_balancer_id" {
  description = "ID of the load balancer."
  value       = try(hcloud_load_balancer.this[0].id, null)
}

output "load_balancer_name" {
  description = "Name of the load balancer."
  value       = try(hcloud_load_balancer.this[0].name, null)
}

output "ipv4" {
  description = "IPv4 address of the load balancer."
  value       = try(hcloud_load_balancer.this[0].ipv4, null)
}

output "ipv6" {
  description = "IPv6 address of the load balancer."
  value       = try(hcloud_load_balancer.this[0].ipv6, null)
}

output "load_balancer" {
  description = "Load balancer attributes."
  value = try({
    id                 = hcloud_load_balancer.this[0].id
    name               = hcloud_load_balancer.this[0].name
    location           = hcloud_load_balancer.this[0].location
    network_zone       = hcloud_load_balancer.this[0].network_zone
    load_balancer_type = hcloud_load_balancer.this[0].load_balancer_type
    labels             = hcloud_load_balancer.this[0].labels
    ipv4               = hcloud_load_balancer.this[0].ipv4
    ipv6               = hcloud_load_balancer.this[0].ipv6
    ipv4_id            = hcloud_load_balancer.this[0].ipv4_id
    ipv6_id            = hcloud_load_balancer.this[0].ipv6_id
    delete_protection  = hcloud_load_balancer.this[0].delete_protection
    algorithm          = try(hcloud_load_balancer.this[0].algorithm[0].type, null)
  }, null)
}

output "network_id" {
  description = "Network ID the load balancer is attached to."
  value       = try(hcloud_load_balancer_network.this[0].network_id, null)
}

output "network_ip" {
  description = "Private IP in the network."
  value       = try(hcloud_load_balancer_network.this[0].ip, null)
}

output "network_attachment" {
  description = "Load balancer network attachment attributes."
  value = try({
    load_balancer_id        = hcloud_load_balancer_network.this[0].load_balancer_id
    network_id              = hcloud_load_balancer_network.this[0].network_id
    subnet_id               = hcloud_load_balancer_network.this[0].subnet_id
    ip                      = hcloud_load_balancer_network.this[0].ip
    enable_public_interface = hcloud_load_balancer_network.this[0].enable_public_interface
  }, null)
}

output "service_ids" {
  description = "Map of load balancer service IDs keyed by index."
  value       = { for k, v in hcloud_load_balancer_service.this : k => v.id }
}

output "services" {
  description = "Map of created load balancer services keyed by index."
  value = {
    for k, v in hcloud_load_balancer_service.this : k => {
      id               = v.id
      protocol         = v.protocol
      listen_port      = v.listen_port
      destination_port = v.destination_port
      proxyprotocol    = v.proxyprotocol
    }
  }
}

output "target_ids" {
  description = "Map of load balancer target IDs keyed by index."
  value       = { for k, v in hcloud_load_balancer_target.this : k => v.id }
}

output "targets" {
  description = "Map of created load balancer targets keyed by index."
  value = {
    for k, v in hcloud_load_balancer_target.this : k => {
      id             = v.id
      type           = v.type
      server_id      = v.server_id
      label_selector = v.label_selector
      ip             = v.ip
      use_private_ip = v.use_private_ip
    }
  }
}
