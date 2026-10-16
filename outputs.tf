output "resource_group_id" {
  description = "ID del Resource Group principal"
  value       = azurerm_resource_group.rg.id
}

output "vnet_id" {
  description = "ID de la red virtual privada"
  value       = azurerm_virtual_network.vnet.id
}

output "openai_endpoint" {
  description = "Endpoint privado de Azure OpenAI Service"
  value       = azurerm_cognitive_account.openai.endpoint
  sensitive   = true
}