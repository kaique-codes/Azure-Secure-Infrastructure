output "resource_group_name" {
  description = "Resource Group criado por esta configuração."
  value       = azurerm_resource_group.this.name
}

output "virtual_network_name" {
  description = "Nome da Virtual Network."
  value       = azurerm_virtual_network.this.name
}

output "virtual_network_id" {
  description = "ID da Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "IDs das subnets criadas."
  value       = { for key, subnet in azurerm_subnet.this : key => subnet.id }
}

output "network_security_group_id" {
  description = "ID do Network Security Group associado às subnets."
  value       = azurerm_network_security_group.this.id
}

output "log_analytics_workspace_id" {
  description = "ID do workspace opcional; null quando enable_log_analytics=false."
  value       = var.enable_log_analytics ? azurerm_log_analytics_workspace.this[0].id : null
}
