locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  traffic_manager_name = coalesce(var.custom_name, data.azurecaf_name.traffic_manager.result)
}
