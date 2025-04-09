variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "client_id" {
  description = "Databricks client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Databricks client secret"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region to deploy workspace into"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "sandbox"
}

variable "admin_user" {
  description = "Admin user email for Databricks workspace"
  type        = string
}

variable "pricing_tier" {
  description = "Workspace pricing tier"
  type        = string
  default     = "premium"
}

variable "credentials_id" {
  description = "ID of the credential configuration"
  type        = string
}

variable "storage_config_id" {
  description = "ID of the storage config"
  type        = string
}

variable "network_id" {
  description = "ID of the workspace VPC"
  type        = string
}
