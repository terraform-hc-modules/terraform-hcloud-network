variable "create" {
  description = "Whether to create the load balancer."
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the load balancer."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The `name` value must be a non-empty string."
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

variable "location" {
  description = "Location of the load balancer."
  type        = string
  default     = "fsn1"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "The `location` value must be a non-empty string (for example, fsn1)."
  }
}

variable "network_zone" {
  description = "Network zone (alternative to location)."
  type        = string
  default     = null

  validation {
    condition     = var.network_zone == null ? true : contains(["eu-central", "us-east", "us-west"], var.network_zone)
    error_message = "If set, `network_zone` must be one of eu-central/us-east/us-west."
  }
}

variable "labels" {
  description = "Labels to apply to the load balancer."
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

variable "algorithm" {
  description = "Algorithm for the load balancer (round_robin or least_connections)."
  type        = string
  default     = "round_robin"

  validation {
    condition     = contains(["round_robin", "least_connections"], var.algorithm)
    error_message = "The `algorithm` value must be one of: round_robin, least_connections."
  }
}

variable "delete_protection" {
  description = "Enable delete protection."
  type        = bool
  default     = false
}

variable "network_id" {
  description = "Network ID to attach the load balancer to."
  type        = number
  default     = null

  validation {
    condition     = var.network_id == null ? true : var.network_id > 0
    error_message = "If set, `network_id` must be > 0."
  }
}

variable "enable_public_interface" {
  description = "Enable public interface."
  type        = bool
  default     = true
}

variable "services" {
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
      for s in var.services : (
        contains(["tcp", "http", "https"], lower(s.protocol)) &&
        s.listen_port >= 1 && s.listen_port <= 65535 &&
        s.destination_port >= 1 && s.destination_port <= 65535 &&
        (
          s.health_check == null ? true : (
            contains(["tcp", "http", "https"], lower(s.health_check.protocol)) &&
            s.health_check.port >= 1 && s.health_check.port <= 65535
          )
        )
      )
    ])
    error_message = "Each service must have protocol in tcp/http/https and ports between 1 and 65535. If health_check is set, it must also have a supported protocol and valid port."
  }
}

variable "targets" {
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
      for t in var.targets : (
        contains(["server", "label_selector", "ip"], lower(t.type)) &&
        (lower(t.type) != "server" || try(t.server_id, null) != null) &&
        (lower(t.type) != "label_selector" || length(trimspace(try(t.label_selector, ""))) > 0) &&
        (lower(t.type) != "ip" || can(cidrhost(try(t.ip, ""), 0)))
      )
    ])
    error_message = "Each target must have type server/label_selector/ip and provide the corresponding attribute (server_id, label_selector, or ip)."
  }
}
