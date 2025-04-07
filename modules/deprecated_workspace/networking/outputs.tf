// Output the VPC ID so it can be reused elsewhere (e.g., in IAM, routing)
output "vpc_id" {
  value = aws_vpc.this.id
}

// Output the Subnet ID – this will be passed to the Databricks workspace module
output "subnet_id" {
  value = aws_subnet.this.id
}
