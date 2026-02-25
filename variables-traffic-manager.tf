variable "profile_status" {
  description = "Whether to enable the profile. Possible values are `Enabled` or `Disabled`."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.profile_status)
    error_message = "The value of profile_status must be either `Enabled` or `Disabled`."
  }
}

variable "traffic_routing_method" {
  description = "Specify which routing method is preferred between the following: `Geographic`, `Performance`, `Priority`, `Weighted`, `MultiValue`, `Subnet`."
  type        = string
  default     = "Performance"
}

variable "traffic_view_enabled" {
  description = "Whether Traffic View is enabled for the Traffic Manager profile."
  type        = bool
  default     = false
}

variable "dns_config" {
  description = "DNS configuration for the Traffic Manager profile."
  type = object({
    relative_name = string
    ttl           = number
  })
  default = {
    relative_name = ""
    ttl           = 30
  }
}

variable "monitor_config" {
  description = "Monitor configuration for the Traffic Manager profile."
  type = object({
    protocol                    = string
    port                        = number
    path                        = optional(string)
    expected_status_code_ranges = optional(list(string))
    custom_header = optional(list(object({
      name  = string
      value = string
    })))
    interval_in_seconds          = optional(number)
    timeout_in_seconds           = optional(number)
    tolerated_number_of_failures = optional(number)
  })
  default = {
    protocol                     = "TCP"
    port                         = 22
    expected_status_code_ranges  = []
    custom_header                = null
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }

  validation {
    condition     = contains(["HTTP", "HTTPS", "TCP"], var.monitor_config.protocol)
    error_message = "The value of protocol can only be `HTTP`, `HTTPS` or `TCP`."
  }

  validation {
    condition     = (contains(["HTTP", "HTTPS"], var.monitor_config.protocol) && var.monitor_config.path != null) || (contains(["TCP"], var.monitor_config.protocol) && var.monitor_config.path == null)
    error_message = "The value of path is required when the protocol is set to `HTTP` or `HTTPS` and cannot be used when the protocol is set to `TCP`."
  }

  validation {
    condition     = contains([30, 10], var.monitor_config.interval_in_seconds)
    error_message = "The value of interval_in_seconds either be 30 (for normal probing) or 10 (for fast probing)."
  }

  validation {
    condition     = var.monitor_config.interval_in_seconds == 30 ? var.monitor_config.timeout_in_seconds >= 5 && var.monitor_config.timeout_in_seconds <= 10 : var.monitor_config.interval_in_seconds == 10 && var.monitor_config.timeout_in_seconds >= 5 && var.monitor_config.timeout_in_seconds <= 9
    error_message = "The value of timeout_in_seconds must be within 5 and 10 for normal probing and 5 and 9 for fast probing."
  }

  validation {
    condition     = var.monitor_config.tolerated_number_of_failures >= 0 && var.monitor_config.tolerated_number_of_failures <= 9
    error_message = "The value of tolerated_number_of_failures must be between 0 and 9."
  }
}

variable "max_return" {
  description = "The amount of endpoints to return for DNS queries to this Profile."
  type        = number
  default     = null
}
