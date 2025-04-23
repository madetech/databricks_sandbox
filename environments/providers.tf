terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.54.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.76.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.3"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.12.1"
    }
    }
      backend "s3" {
      bucket = "made-tech-databricks-sandbox-tfstate"
      key    = "dev/terraform.tfstate"
      region = "eu-west-2"
  }
}

#This block is required to  authenticate and deploy AWS resources, and profile refers to AWS CLI profile
provider "aws" {
  region                      = var.region
  skip_credentials_validation = false
  skip_metadata_api_check     = false
  skip_requesting_account_id  = false
}

provider "databricks" {
  alias         = "mws"
  host          = "https://accounts.cloud.databricks.com"
  account_id    = var.databricks_account_id
  client_id     = var.client_id
  client_secret = var.client_secret
}
