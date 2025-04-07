terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
#   backend "s3" {
#     bucket = "mybucket"
#     key    = "path/to/my/key"
#     region = "eu-west-1"
#   }
}

provider "aws" {
  region = var.region
  profile = "databricks-sandbox"
}

// initialize provider in "MWS" mode to provision new workspace
provider "databricks" {
  alias         = "mws"
  host          = "https://accounts.cloud.databricks.com"
  account_id    = var.databricks_account_id
  client_id     = var.client_id
  client_secret = var.client_secret
}