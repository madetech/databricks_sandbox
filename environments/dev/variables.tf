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

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "AWS Availability Zone to deploy the subnet"
  default     = "eu-west-1a"
}