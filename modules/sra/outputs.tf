output "databricks_host" {
  description = "Host name of the workspace URL"
  value       = module.databricks_mws_workspace.workspace_url
}

output "duplicated_private_subnet_ids" {
  description = "Duplicated private subnet ID to satisfy Databricks 2-subnet minimum requirement"
  value       = [module.vpc[0].private_subnets[0], module.vpc[0].private_subnets[0]]
}
