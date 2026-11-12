variable "create" {
  description = "Whether to create the firewall attachment."
  type        = bool
  default     = true
}

variable "firewall_id" {
  description = "ID of the firewall to attach."
  type        = number
}

variable "server_ids" {
  description = "Set of server IDs to attach the firewall to."
  type        = set(number)
  default     = []

  validation {
    condition     = alltrue([for id in var.server_ids : id > 0])
    error_message = "Each `server_ids` entry must be > 0."
  }
}

variable "label_selectors" {
  description = "Set of label selectors whose matching servers get the firewall."
  type        = set(string)
  default     = []

  validation {
    condition     = alltrue([for s in var.label_selectors : length(trimspace(s)) > 0])
    error_message = "Each `label_selectors` entry must be a non-empty string."
  }
}
