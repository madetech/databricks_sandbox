variable "databricks_account_id" {
  description = "ID of the Databricks account."
  type        = string
}

variable "resource_prefix" {
  description = "Prefix for the resource names."
  type        = string
}

variable "log_delivery_mws_credentials_name" {
  type        = string
  description = "Override name for the Databricks MWS credential used for log delivery"
  default     = "Usage Delivery"
}
