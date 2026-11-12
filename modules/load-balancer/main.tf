resource "hcloud_load_balancer" "this" {
  count = var.create ? 1 : 0

  name               = var.name
  load_balancer_type = var.load_balancer_type
  location           = var.network_zone == null ? var.location : null
  network_zone       = var.network_zone
  labels             = var.labels
  delete_protection  = var.delete_protection
  ipv4_id            = var.ipv4_id
  ipv6_id            = var.ipv6_id

  algorithm {
    type = var.algorithm
  }
}

resource "hcloud_load_balancer_network" "this" {
  count = var.create && (var.network_id != null || var.subnet_id != null) ? 1 : 0

  load_balancer_id        = hcloud_load_balancer.this[0].id
  network_id              = var.network_id
  subnet_id               = var.subnet_id
  ip                      = var.network_ip
  enable_public_interface = var.enable_public_interface

  lifecycle {
    precondition {
      condition     = var.network_id == null || var.subnet_id == null
      error_message = "Only one of `network_id` or `subnet_id` may be set."
    }
  }
}

resource "hcloud_load_balancer_service" "this" {
  for_each = var.create ? { for idx, svc in var.services : idx => svc } : {}

  load_balancer_id = hcloud_load_balancer.this[0].id
  protocol         = each.value.protocol
  listen_port      = each.value.listen_port
  destination_port = each.value.destination_port
  proxyprotocol    = each.value.proxyprotocol

  dynamic "health_check" {
    for_each = each.value.health_check != null ? [each.value.health_check] : []
    content {
      protocol = health_check.value.protocol
      port     = health_check.value.port
      interval = health_check.value.interval
      timeout  = health_check.value.timeout
      retries  = health_check.value.retries

      dynamic "http" {
        for_each = health_check.value.http != null ? [health_check.value.http] : []
        content {
          domain       = http.value.domain
          path         = http.value.path
          response     = http.value.response
          status_codes = http.value.status_codes
          tls          = http.value.tls
        }
      }
    }
  }

  dynamic "http" {
    for_each = each.value.http != null ? [each.value.http] : []
    content {
      sticky_sessions = http.value.sticky_sessions
      cookie_name     = http.value.cookie_name
      cookie_lifetime = http.value.cookie_lifetime
      certificates    = http.value.certificates
      redirect_http   = http.value.redirect_http
    }
  }
}

resource "hcloud_load_balancer_target" "this" {
  for_each = var.create ? { for idx, target in var.targets : idx => target } : {}

  load_balancer_id = hcloud_load_balancer.this[0].id
  type             = each.value.type
  server_id        = each.value.server_id
  label_selector   = each.value.label_selector
  ip               = each.value.ip
  use_private_ip   = each.value.use_private_ip
}
