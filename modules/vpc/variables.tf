variable "create" {
  description = "Whether to create the network."
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the network."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The `name` value must be a non-empty string."
  }
}

variable "ip_range" {
  description = "IP range of the network (CIDR notation)."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.ip_range))
    error_message = "The `ip_range` value must be a valid CIDR (for example, 10.0.0.0/16)."
  }
}

variable "labels" {
  description = "Labels to apply to the network."
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

variable "delete_protection" {
  description = "Enable delete protection."
  type        = bool
  default     = false
}

variable "expose_routes_to_vswitch" {
  description = "Enable routing from vSwitch."
  type        = bool
  default     = false
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
        can(cidrnetmask(r.destination)) &&
        can(cidrhost(r.gateway, 0))
      )
    ])
    error_message = "Each route must have `destination` as a CIDR and `gateway` as a valid IP address."
  }
}
