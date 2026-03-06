locals {
  common_tags = {
    env = var.env
  }
}

# Key Vault
resource "azurerm_key_vault" "main" {
  count                         = var.create_keyvault ? 1 : 0
  name                          = var.keyvault_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = var.keyvault_soft_delete_retention_days
  purge_protection_enabled      = var.keyvault_purge_protection_enabled
  public_network_access_enabled = var.keyvault_public_network_access_enabled
  enable_rbac_authorization     = false

  # Firewall: when public access is on, deny by default and bypass Azure services
  dynamic "network_acls" {
    for_each = var.keyvault_public_network_access_enabled ? [1] : []
    content {
      default_action = "Deny"
      bypass         = "AzureServices"
    }
  }

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
    ]
    key_permissions = [
      "Get", "List", "Create", "Delete", "Recover", "Backup", "Restore"
    ]
    certificate_permissions = [
      "Get", "List", "Create", "Delete", "Recover", "Backup", "Restore"
    ]
  }

  tags = local.common_tags
}

# Storage Account
resource "azurerm_storage_account" "main" {
  count                            = var.create_storage ? 1 : 0
  name                             = var.storage_account_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  account_tier                     = "Standard"
  account_replication_type         = var.account_replication_type
  allow_nested_items_to_be_public  = var.storage_public_access_enabled
  min_tls_version                  = "TLS1_2"
  https_traffic_only_enabled       = true
  infrastructure_encryption_enabled = var.storage_infrastructure_encryption

  # Explicit network rules: allow by default; set to Deny + ip_rules for lockdown
  network_rules {
    default_action             = var.storage_network_default_action
    bypass                     = ["AzureServices"]
  }

  blob_properties {
    versioning_enabled = var.storage_blob_versioning_enabled
  }

  tags = local.common_tags
}
