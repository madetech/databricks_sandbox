// Prefix used in naming resources like VPC and subnet
variable "resource_prefix" {
  description = "Prefix to use for naming"
  type        = string
  default     = "sandbox"
}

// IP range for the VPC (big enough to fit multiple subnets)
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

// IP range for the subnet within the VPC
variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

// The Availability Zone to place the subnet in (e.g., us-west-2a)
variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}
