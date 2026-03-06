output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Name of the resource group"
}

output "key_vault_id" {
  value       = module.keyvault.key_vault_id
  description = "Key Vault resource ID"
}

output "key_vault_name" {
  value       = module.keyvault.key_vault_name
  description = "Key Vault name"
}

output "storage_lrs_name" {
  value       = module.storage_lrs.storage_account_name
  description = "LRS storage account name (Canada Central, public access disabled)"
}

output "storage_ragrs_name" {
  value       = module.storage_ragrs.storage_account_name
  description = "RA-GRS storage account name (Canada East, public access enabled)"
}
