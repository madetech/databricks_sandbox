// ------------------------------------------
// ENVIRONMENT: dev
// This file wires together Terraform modules to create:
// - Networking (VPC + subnet)
// - Databricks Workspace

// It wires in the inputs and is where we run `terraform init/plan/apply`
// ------------------------------------------
module "sra" {
  source = "github.com/databricks/terraform-databricks-sra//aws/tf/modules/sra?ref=main"

  providers = {
    aws            = aws
    databricks.mws = databricks.mws
  }
  
  region          = var.region
  resource_prefix = var.resource_prefix
  region_name               = var.region
  
  aws_account_id            = var.aws_account_id
  databricks_account_id     = var.databricks_account_id
  admin_user                = var.admin_user
  client_id                 = var.client_id
  client_secret             = var.client_secret
  metastore_exists          = false

  network_configuration     = "isolated"
  vpc_cidr_range            = "10.0.0.0/16"
  private_subnets_cidr      = ["10.0.1.0/24"]
  privatelink_subnets_cidr  = ["10.0.2.0/24"]
  availability_zones        = ["eu-west-2"]
  sg_egress_ports           = [443]
  region_bucket_name        = "sandbox-bucket-${var.region}"
  
}