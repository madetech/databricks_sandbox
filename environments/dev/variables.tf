variable "databricks_account_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "region" {
  default = "eu-west-1"
}
variable "admin_user" {}
variable "resource_prefix" {
  default = "sandbox"
}
variable "pricing_tier" {
  default = "premium"
}
variable "credentials_id" {}
variable "storage_config_id" {}
variable "network_id" {}
