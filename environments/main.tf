// ------------------------------------------
// ENVIRONMENT: dev
// This file wires together Terraform modules
// It wires in the inputs and is where we run `terraform init/plan/apply`
// ------------------------------------------
module "sra" {
  source = "../modules/sra"

  providers = {
    aws            = aws
    databricks.mws = databricks.mws
  }

  region          = var.region
  resource_prefix = var.resource_prefix
  region_name     = var.region

  aws_account_id        = var.aws_account_id
  databricks_account_id = var.databricks_account_id
  admin_user            = var.admin_user
  client_id             = var.client_id
  client_secret         = var.client_secret
  metastore_exists      = true #tells module to  create a new Unity Catalog metastore. this value needs to be manually switched later

  network_configuration             = "isolated"
  vpc_cidr_range                    = "10.0.0.0/16"
  private_subnets_cidr              = ["10.0.10.0/24", "10.0.11.0/24"]
  public_subnets_cidr               = ["10.0.20.0/24", "10.0.21.0/24"]
  privatelink_subnets_cidr          = ["10.0.30.0/24", "10.0.31.0/24"]
  availability_zones                = ["eu-west-2a", "eu-west-2b"]
  sg_egress_ports                   = ["443", "2443", "6666", "8443", "8451"]
  region_bucket_name                = "sandbox-bucket-${var.region}"
  log_delivery_mws_credentials_name = "Usage Delivery v3"
}
