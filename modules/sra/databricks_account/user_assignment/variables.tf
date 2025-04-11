variable "workspace_id" {
  description = "workspace ID of deployed workspace."
  type        = string
}

variable "workspace_access" {
  type        = string
  description = "data source for the workspace access."
}

variable "admin_user" {
  description = "Email of initial Databricks workspace admin."
  type        = string
}
