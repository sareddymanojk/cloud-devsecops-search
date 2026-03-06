output "key_vault_id" {
  value       = var.create_keyvault ? azurerm_key_vault.main[0].id : null
  description = "Key Vault resource ID"
}

output "key_vault_name" {
  value       = var.create_keyvault ? azurerm_key_vault.main[0].name : null
  description = "Key Vault name"
}

output "storage_account_id" {
  value       = var.create_storage ? azurerm_storage_account.main[0].id : null
  description = "Storage account resource ID"
}

output "storage_account_name" {
  value       = var.create_storage ? azurerm_storage_account.main[0].name : null
  description = "Storage account name"
}

output "storage_primary_connection_string" {
  value       = var.create_storage ? azurerm_storage_account.main[0].primary_connection_string : null
  sensitive   = true
  description = "Primary connection string for the storage account"
}
