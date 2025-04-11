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

variable "log_delivery_mws_credentials_name" {
  type        = string
  description = "Custom name for log delivery credentials"
  default     = "Usage Delivery"
}
variable "workspace_sku" {
  description = "The pricing tier for the Databricks workspace (STANDARD or PREMIUM)"
  type        = string
  default     = "STANDARD"
}

variable "enable_nat" {
  description = "Whether to enable NAT gateway for private subnet access"
  type        = bool
  default     = true
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for public subnets (used for NAT Gateway)"
  type        = list(string)
  default     = []
}

variable "vpc_cidr_range" {
  type        = string
  description = "CIDR block for VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}
variable "private_subnets_cidr" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}
variable "privatelink_subnets_cidr" {
  type        = list(string)
  description = "List of private link subnet CIDR blocks"
}
variable "sg_egress_ports" {
  description = "List of ports to open for egress rules"
  type        = list(string)
}

variable "network_configuration" {
  description = "The type of network set-up for the workspace network configuration."
  type        = string
  default     = "isolated"

  validation {
    condition     = contains(["custom", "isolated"], var.network_configuration)
    error_message = "Invalid network configuration. Allowed values are: custom, isolated."
  }
}
