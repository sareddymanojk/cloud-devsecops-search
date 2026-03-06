data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.env}"
  location = var.location_kv
  tags = {
    env = var.env
  }
}

# Unique suffix so storage account names are globally unique (3-24 chars, alphanumeric)
resource "random_id" "suffix" {
  byte_length = 4
}

# Key Vault: Canada East, public access disabled, soft delete 7 days
module "keyvault" {
  source = "./modules/keyvault-storage"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location_kv
  env                 = var.env
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id

  create_keyvault = true
  create_storage  = false

  keyvault_name                          = "kv-${var.env}-${random_id.suffix.hex}"
  keyvault_soft_delete_retention_days    = 7
  keyvault_public_network_access_enabled = false
  keyvault_purge_protection_enabled      = var.env == "prd"
}

# Storage 1: LRS, Canada Central, public access disabled
module "storage_lrs" {
  source = "./modules/keyvault-storage"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location_storage_lrs
  env                 = var.env
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id

  create_keyvault = false
  create_storage  = true

  storage_account_name           = "st${var.env}lrs${random_id.suffix.hex}"
  account_replication_type       = "LRS"
  storage_public_access_enabled  = false
  storage_blob_versioning_enabled = var.env == "prd"
}

# Storage 2: RA-GRS, Canada East, public access enabled
module "storage_ragrs" {
  source = "./modules/keyvault-storage"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location_storage_ragrs
  env                 = var.env
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id

  create_keyvault = false
  create_storage  = true

  storage_account_name           = "st${var.env}ragrs${random_id.suffix.hex}"
  account_replication_type       = "RAGRS"
  storage_public_access_enabled  = true
  storage_blob_versioning_enabled = var.env == "prd"
}
