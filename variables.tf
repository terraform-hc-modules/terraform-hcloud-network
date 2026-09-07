################################################################################
# Common
################################################################################

variable "name" {
  description = "Name prefix for resources."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The `name` value must be a non-empty string."
  }
}

variable "labels" {
  description = "Labels to apply to all resources."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.labels : (
        length(k) > 0 &&
        length(k) <= 63 &&
        length(v) <= 63 &&
        can(regex("^[A-Za-z0-9][A-Za-z0-9_.-]{0,62}$", k))
      )
    ])
    error_message = "The `labels` map keys must match ^[A-Za-z0-9][A-Za-z0-9_.-]{0,62}$ (max 63 chars). Label values must be <= 63 chars."
  }
}

################################################################################
# VPC
################################################################################

variable "create_vpc" {
  description = "Whether to create the VPC."
  type        = bool
  default     = true
}

variable "ip_range" {
  description = "IP range of the network."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.ip_range))
    error_message = "The `ip_range` value must be a valid CIDR (for example, 10.0.0.0/16)."
  }
}

variable "subnets" {
  description = "List of subnets to create."
  type = list(object({
    ip_range     = string
    network_zone = string
    type         = optional(string, "cloud")
    vswitch_id   = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.subnets : (
        can(cidrnetmask(s.ip_range)) &&
        contains(["eu-central", "us-east", "us-west"], s.network_zone) &&
        contains(["cloud", "vswitch"], try(s.type, "cloud")) &&
        (try(s.vswitch_id, null) == null ? true : s.vswitch_id > 0)
      )
    ])
    error_message = "Each subnet must have a valid `ip_range` CIDR; `network_zone` must be one of eu-central/us-east/us-west; `type` must be cloud or vswitch; and `vswitch_id` (if set) must be > 0."
  }
}

variable "routes" {
  description = "List of routes to create."
  type = list(object({
    destination = string
    gateway     = string
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.routes : (
        can(cidrhost(r.destination, 0)) &&
        (can(cidrhost("${r.gateway}/32", 0)) || can(cidrhost("${r.gateway}/128", 0)))
      )
    ])
    error_message = "Each route must have `destination` as a CIDR and `gateway` as a valid IP address."
  }
}

################################################################################
# Firewall
################################################################################

variable "create_firewall" {
  description = "Whether to create the firewall."
  type        = bool
  default     = false
}

variable "firewall_name" {
  description = "Name of the firewall. Defaults to name-firewall."
  type        = string
  default     = null

  validation {
    condition     = var.firewall_name == null ? true : length(trimspace(var.firewall_name)) > 0
    error_message = "If set, `firewall_name` must be a non-empty string."
  }
}

variable "inbound_rules" {
  description = "List of inbound firewall rules."
  type = list(object({
    description     = optional(string)
    protocol        = string
    port            = optional(string)
    source_ips      = optional(list(string), ["0.0.0.0/0", "::/0"])
    destination_ips = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.inbound_rules : (
        contains(["tcp", "udp", "icmp", "esp", "gre"], lower(r.protocol)) &&
        (try(r.port, null) == null || can(regex("^([0-9]{1,5})(-[0-9]{1,5})?$", r.port))) &&
        alltrue([for ip in coalesce(try(r.source_ips, null), []) : can(cidrhost(ip, 0))]) &&
        alltrue([for ip in coalesce(try(r.destination_ips, null), []) : can(cidrhost(ip, 0))])
      )
    ])
    error_message = "Inbound rules: `protocol` must be one of tcp/udp/icmp/esp/gre; `port` (if set) must be like 80 or 80-90; and IPs must be valid CIDR blocks."
  }
}

variable "outbound_rules" {
  description = "List of outbound firewall rules."
  type = list(object({
    description     = optional(string)
    protocol        = string
    port            = optional(string)
    source_ips      = optional(list(string))
    destination_ips = optional(list(string), ["0.0.0.0/0", "::/0"])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.outbound_rules : (
        contains(["tcp", "udp", "icmp", "esp", "gre"], lower(r.protocol)) &&
        (try(r.port, null) == null || can(regex("^([0-9]{1,5})(-[0-9]{1,5})?$", r.port))) &&
        alltrue([for ip in coalesce(try(r.source_ips, null), []) : can(cidrhost(ip, 0))]) &&
        alltrue([for ip in coalesce(try(r.destination_ips, null), []) : can(cidrhost(ip, 0))])
      )
    ])
    error_message = "Outbound rules: `protocol` must be one of tcp/udp/icmp/esp/gre; `port` (if set) must be like 80 or 80-90; and IPs must be valid CIDR blocks."
  }
}

################################################################################
# Load Balancer
################################################################################

variable "create_load_balancer" {
  description = "Whether to create the load balancer."
  type        = bool
  default     = false
}

variable "load_balancer_name" {
  description = "Name of the load balancer. Defaults to name-lb."
  type        = string
  default     = null

  validation {
    condition     = var.load_balancer_name == null ? true : length(trimspace(var.load_balancer_name)) > 0
    error_message = "If set, `load_balancer_name` must be a non-empty string."
  }
}

variable "load_balancer_type" {
  description = "Type of the load balancer."
  type        = string
  default     = "lb11"

  validation {
    condition     = can(regex("^lb[0-9]+$", var.load_balancer_type))
    error_message = "The `load_balancer_type` value must look like lb11, lb21, etc."
  }
}

variable "load_balancer_location" {
  description = "Location of the load balancer."
  type        = string
  default     = "fsn1"

  validation {
    condition     = length(trimspace(var.load_balancer_location)) > 0
    error_message = "The `load_balancer_location` value must be a non-empty string (for example, fsn1)."
  }
}

variable "load_balancer_algorithm" {
  description = "Algorithm for the load balancer."
  type        = string
  default     = "round_robin"

  validation {
    condition     = contains(["round_robin", "least_connections"], var.load_balancer_algorithm)
    error_message = "The `load_balancer_algorithm` value must be one of: round_robin, least_connections."
  }
}

variable "load_balancer_services" {
  description = "List of services for the load balancer."
  type = list(object({
    protocol         = string
    listen_port      = number
    destination_port = number
    proxyprotocol    = optional(bool, false)
    health_check = optional(object({
      protocol = string
      port     = number
      interval = optional(number, 15)
      timeout  = optional(number, 10)
      retries  = optional(number, 3)
      http = optional(object({
        domain       = optional(string)
        path         = optional(string, "/")
        response     = optional(string)
        status_codes = optional(list(string), ["2??", "3??"])
        tls          = optional(bool, false)
      }))
    }))
    http = optional(object({
      sticky_sessions = optional(bool, false)
      cookie_name     = optional(string)
      cookie_lifetime = optional(number)
      certificates    = optional(list(number))
      redirect_http   = optional(bool, false)
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.load_balancer_services : (
        contains(["tcp", "http", "https"], lower(s.protocol)) &&
        s.listen_port >= 1 && s.listen_port <= 65535 &&
        s.destination_port >= 1 && s.destination_port <= 65535
      )
    ])
    error_message = "Each load balancer service must have `protocol` in tcp/http/https and ports between 1 and 65535."
  }
}

variable "load_balancer_targets" {
  description = "List of targets for the load balancer."
  type = list(object({
    type           = string
    server_id      = optional(number)
    label_selector = optional(string)
    ip             = optional(string)
    use_private_ip = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for t in var.load_balancer_targets : (
        contains(["server", "label_selector", "ip"], lower(t.type)) &&
        (lower(t.type) != "server" || try(t.server_id, null) != null) &&
        (lower(t.type) != "label_selector" || length(trimspace(try(t.label_selector, ""))) > 0) &&
        (lower(t.type) != "ip" || can(cidrhost(try(t.ip, ""), 0)))
      )
    ])
    error_message = "Each load balancer target must have type server/label_selector/ip and provide the corresponding attribute (server_id, label_selector, or ip)."
  }
}
