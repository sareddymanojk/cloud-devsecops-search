variable "env" {
  type        = string
  default     = "dev"
  description = "Environment: dev, qa, stg, or prd"
  validation {
    condition     = contains(["dev", "qa", "stg", "prd"], var.env)
    error_message = "env must be one of: dev, qa, stg, prd."
  }
}

variable "project_name" {
  type        = string
  default     = "tfassignment"
  description = "Short name used in resource names (lowercase, no spaces)"
}

variable "location_kv" {
  type        = string
  default     = "canadaeast"
  description = "Region for Key Vault (Canada East)"
}

variable "location_storage_lrs" {
  type        = string
  default     = "canadacentral"
  description = "Region for LRS storage (Canada Central)"
}

variable "location_storage_ragrs" {
  type        = string
  default     = "canadaeast"
  description = "Region for RA-GRS storage (Canada East)"
}
