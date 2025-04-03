// ------------------------------------------
// MODULE: databricks_workspace
// This file defines how to create a Databricks workspace using the Databricks provider
// It is a reusable building block, NOT meant to be run directly.
// ------------------------------------------


#Creates a databricks workspace in AWS using the provided values 
#The Resource block
resource "databricks_mws_workspaces" "databricks_workspace" {
  account_id         = var.databricks_account_id
  aws_region         = var.region
  workspace_name     = "${var.resource_prefix}-workspace"
  deployment_name    = "${var.resource_prefix}-deployment"
  pricing_tier       = var.pricing_tier
  credentials_id     = var.credentials_id
  storage_configuration_id = var.storage_config_id
  network_id         = var.network_id
}
