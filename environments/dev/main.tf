// ------------------------------------------
// ENVIRONMENT: dev
// This file wires together Terraform modules to create:
// - Networking (VPC + subnet)
// - Databricks Workspace

// It wires in the inputs and is where we run `terraform init/plan/apply`
// ------------------------------------------

#Contains module block that is called, no actual resources
module "workspace" {
  source = "../../modules/databricks_workspace"

  databricks_account_id = var.databricks_account_id
  client_id             = var.client_id
  client_secret         = var.client_secret
  region                = var.region
  admin_user            = var.admin_user
  resource_prefix       = var.resource_prefix

  pricing_tier          = var.pricing_tier
  credentials_id        = var.credentials_id
  storage_config_id     = var.storage_config_id
  network_id            = module.networking.subnet_id
}

module "networking" {
  source = "../../modules/networking"

  resource_prefix      = var.resource_prefix
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidr   = var.public_subnet_cidr
  availability_zone    = var.availability_zone
}