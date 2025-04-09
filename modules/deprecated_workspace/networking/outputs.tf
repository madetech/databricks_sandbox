// Output the VPC ID so it can be reused elsewhere (e.g., in IAM, routing)
output "vpc_id" {
  value = aws_vpc.sandbox_vpc.id
}

// Output the Subnet ID – this will be passed to the Databricks workspace module
output "subnet_id" {
  value = aws_subnet.sandbox_subnet.id
}
