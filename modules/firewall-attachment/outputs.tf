output "id" {
  description = "ID of the firewall attachment."
  value       = try(hcloud_firewall_attachment.this[0].id, null)
}

output "firewall_attachment" {
  description = "Firewall attachment attributes."
  value = try({
    id              = hcloud_firewall_attachment.this[0].id
    firewall_id     = hcloud_firewall_attachment.this[0].firewall_id
    server_ids      = hcloud_firewall_attachment.this[0].server_ids
    label_selectors = hcloud_firewall_attachment.this[0].label_selectors
  }, null)
}
