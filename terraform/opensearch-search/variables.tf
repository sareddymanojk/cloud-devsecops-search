variable "project_name" {
  type        = string
  description = "Project or application name"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment (dev, staging, prod)"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnets for OpenSearch (2+ for HA)"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDRs allowed to hit OpenSearch (e.g. app subnets)"
}

variable "instance_type" {
  type    = string
  default = "r6g.large.search"
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "ebs_volume_size" {
  type    = number
  default = 100
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "KMS key for encryption; null = default key"
}

variable "master_user_name" {
  type      = string
  sensitive = true
}

variable "master_user_password" {
  type      = string
  sensitive = true
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags"
}
