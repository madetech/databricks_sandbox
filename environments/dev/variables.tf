variable "region" {
  default     = "eu-west-2"
  description = "AWS region to deploy Databricks workspace in."
}

variable "region_name" {
  default     = "london"
  description = "Human-readable region name, used for tagging or naming buckets."
}

variable "region_bucket_name" {
  default     = "sandbox-bucket-eu-west-2"
  description = "Name of the root S3 bucket used by Databricks."
}

variable "resource_prefix" {
  default     = "sandbox"
  description = "Prefix for naming all provisioned resources."
}

variable "aws_account_id" {
  description = "AWS account ID where Databricks will be deployed."
  type        = string
  sensitive   = true
}

variable "databricks_account_id" {
  description = "Databricks account ID for control plane setup."
  type        = string
  sensitive   = true
}

variable "admin_user" {
  description = "Email of initial Databricks workspace admin."
  type        = string
}

variable "client_id" {
  description = "Databricks client ID (Service Principal)."
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Databricks client secret (Service Principal)."
  type        = string
  sensitive   = true
}

variable "metastore_exists" {
  description = "If true, reference existing Unity Catalog metastore instead of creating one."
  type        = bool
  default     = false
}
