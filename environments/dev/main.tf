// ------------------------------------------
// ENVIRONMENT: dev
// This file *uses* the databricks_workspace module
// It wires in the inputs and is where we run `terraform init/plan/apply`
// ------------------------------------------

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.33.0"
    }
  }
}

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
  network_id            = var.network_id
}
