terraform {
  backend "s3" {
    bucket         = "made-tech-databricks-sandbox-tfstate"
    key            = "zeerak/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}
