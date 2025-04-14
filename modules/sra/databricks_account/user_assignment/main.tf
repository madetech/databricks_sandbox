# Terraform Documentation: https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/service_principal

data "databricks_user" "workspace_access" {
  user_name = var.admin_user
  # depends_on = [var.workspace_id]
}

resource "databricks_mws_permission_assignment" "workspace_access" {
  workspace_id = var.workspace_id
  principal_id = data.databricks_user.workspace_access.id
  permissions  = ["ADMIN"]
}
