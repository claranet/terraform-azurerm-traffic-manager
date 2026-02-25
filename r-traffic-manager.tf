resource "azurerm_traffic_manager_profile" "main" {
  name                = local.name
  resource_group_name = var.resource_group_name

  profile_status         = var.profile_status
  traffic_routing_method = var.traffic_routing_method
  traffic_view_enabled   = var.traffic_view_enabled

  dns_config {
    relative_name = var.dns_config.relative_name
    ttl           = var.dns_config.ttl
  }

  monitor_config {
    protocol                    = var.monitor_config.protocol
    port                        = var.monitor_config.port
    path                        = var.monitor_config.path
    expected_status_code_ranges = var.monitor_config.expected_status_code_ranges
    dynamic "custom_header" {
      for_each = var.monitor_config.custom_header[*]
      content {
        name  = custom_header.name
        value = custom_header.value
      }
    }
    interval_in_seconds          = var.monitor_config.interval_in_seconds
    timeout_in_seconds           = var.monitor_config.timeout_in_seconds
    tolerated_number_of_failures = var.monitor_config.tolerated_number_of_failures
  }

  max_return = var.max_return

  tags = merge(local.default_tags, var.extra_tags)

  lifecycle {
    precondition {
      condition     = var.traffic_routing_method == "MultiValue" ? try(var.max_return >= 1 && var.max_return <= 8, false) : var.max_return == null
      error_message = "The amount of endpoints to return for DNS queries must be set when the traffic_routing_method is 'MultiValue' and must be in the range of 1 to 8."
    }
  }
}
