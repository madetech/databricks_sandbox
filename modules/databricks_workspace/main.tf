provider "databricks" {
  alias  = "mws"
  host   = "https://accounts.cloud.databricks.com"
  client_id     = var.client_id
  client_secret = var.client_secret
}

resource "databricks_mws_workspaces" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  aws_region         = var.region
  workspace_name     = "${var.resource_prefix}-workspace"
  deployment_name    = "${var.resource_prefix}-deployment"
  pricing_tier       = var.pricing_tier
  credentials_id     = var.credentials_id
  storage_configuration_id = var.storage_config_id
  network_id         = var.network_id
  customer_managed_key_id = null
  admin_users        = [var.admin_user]
}
