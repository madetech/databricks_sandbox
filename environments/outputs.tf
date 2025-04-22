output "databricks_host" {
  value = module.sra.databricks_host
}

output "vpc_private_subnet_ids" {
  value = aws_subnet.private[*].id
}
