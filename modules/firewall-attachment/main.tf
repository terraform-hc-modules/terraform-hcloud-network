resource "hcloud_firewall_attachment" "this" {
  count = var.create ? 1 : 0

  firewall_id     = var.firewall_id
  server_ids      = length(var.server_ids) > 0 ? var.server_ids : null
  label_selectors = length(var.label_selectors) > 0 ? var.label_selectors : null

  lifecycle {
    precondition {
      condition     = length(var.server_ids) > 0 || length(var.label_selectors) > 0
      error_message = "At least one of `server_ids` or `label_selectors` must be set."
    }
  }
}
