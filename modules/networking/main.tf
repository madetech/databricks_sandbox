// -------------------------------------------------------------
// This module creates a simple AWS VPC with one public subnet 
// Intended to be minimal and cost effective for sandbox use
// -------------------------------------------------------------

//Create a simple virtual private cloud VPC - private network in AWS
resource "aws_vpc" "sandbox_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.resource_prefix}-vpc"
  }
}
//Create a public subnet inside the vpc
resource "aws_subnet" "sandbox_subnet" {
  vpc_id                  = aws_vpc.sandbox_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.resource_prefix}-subnet"
  }
}
