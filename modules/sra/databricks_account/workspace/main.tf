resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]
  create_duration = "30s"
}

resource "databricks_mws_credentials" "this" {
  role_arn         = var.cross_account_role_arn
  credentials_name = "${var.resource_prefix}-credentials"
  depends_on       = [time_sleep.wait_30_seconds]
}

resource "databricks_mws_storage_configurations" "this" {
  account_id                 = var.databricks_account_id
  bucket_name                = var.bucket_name
  storage_configuration_name = "${var.resource_prefix}-storage"
}

resource "databricks_mws_networks" "this" {
  account_id         = var.databricks_account_id
  network_name       = "${var.resource_prefix}-network"
  security_group_ids = var.security_group_ids
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
}

resource "databricks_mws_workspaces" "workspace" {
  account_id           = var.databricks_account_id
  aws_region           = var.region
  workspace_name       = var.resource_prefix
  deployment_name      = var.deployment_name

  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id               = databricks_mws_networks.this.network_id

  pricing_tier         = "STANDARD" # or omit entirely for default

  depends_on = [databricks_mws_networks.this]
}
