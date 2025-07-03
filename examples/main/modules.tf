module "traffic_manager" {
  source  = "claranet/traffic-manager/azurerm"
  version = "x.x.x"

  resource_group_name = module.rg.name

  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  traffic_routing_method = "Performance"

  dns_config = {
    relative_name = "my_traffic_manager_profile"
    ttl           = 100
  }

  monitor_config = {
    protocol                    = "HTTP"
    port                        = 80
    path                        = "/"
    expected_status_code_ranges = ["200-299"]
    custom_header = [
      {
        name  = "my-custom-header"
        value = "Content-Type"
      },
    ]
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }

  logs_destinations_ids = [
    module.run.logs_storage_account_id,
    module.run.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}
