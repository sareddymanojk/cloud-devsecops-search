variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for the resource"
}

variable "env" {
  type        = string
  description = "Environment tag (dev, qa, stg, prd)"
  validation {
    condition     = contains(["dev", "qa", "stg", "prd"], var.env)
    error_message = "env must be one of: dev, qa, stg, prd."
  }
}

# Key Vault (required when create_keyvault = true)
variable "keyvault_name" {
  type        = string
  default     = ""
  description = "Name of the Key Vault"
}

variable "keyvault_soft_delete_retention_days" {
  type        = number
  default     = 7
  description = "Soft delete retention in days"
}

variable "keyvault_public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is allowed"
}

variable "keyvault_purge_protection_enabled" {
  type        = bool
  default     = false
  description = "Enable purge protection (recommended for prd; prevents permanent delete during retention)"
}

# Storage (used per instance; required only when create_storage = true)
variable "storage_account_name" {
  type        = string
  default     = ""
  description = "Name of the storage account (globally unique)"
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "Replication type: LRS, GRS, RAGRS, etc."
}

variable "storage_public_access_enabled" {
  type        = bool
  default     = false
  description = "Allow blob public access (nested items can be public)"
}

variable "storage_infrastructure_encryption" {
  type        = bool
  default     = false
  description = "Enable double encryption at rest (infrastructure layer)"
}

variable "storage_network_default_action" {
  type        = string
  default     = "Allow"
  description = "Network rules default action: Allow or Deny (use Deny + ip_rules for lockdown)"
}

variable "storage_blob_versioning_enabled" {
  type        = bool
  default     = false
  description = "Enable blob versioning for recovery"
}

variable "create_keyvault" {
  type        = bool
  default     = true
  description = "Set to true to create Key Vault in this module invocation"
}

variable "create_storage" {
  type        = bool
  default     = true
  description = "Set to true to create Storage Account in this module invocation"
}

variable "tenant_id" {
  type        = string
  default     = ""
  description = "Azure AD tenant ID (for Key Vault access policy)"
}

variable "object_id" {
  type        = string
  default     = ""
  description = "Object ID of the user/SP that needs Key Vault access"
}
