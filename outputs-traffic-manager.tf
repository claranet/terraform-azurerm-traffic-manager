output "resource" {
  description = "Traffic Manager output object."
  value       = azurerm_traffic_manager_profile.main
}

output "id" {
  description = "Traffic Manager ID."
  value       = azurerm_traffic_manager_profile.main.id
}

output "name" {
  description = "Traffic Manager name."
  value       = azurerm_traffic_manager_profile.main.name
}

output "fqdn" {
  description = "Traffic Manager FQDN."
  value       = azurerm_traffic_manager_profile.main.fqdn
}
