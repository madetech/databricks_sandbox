# Databricks Sandbox Terraform Module
Reusable Terraform modules to provision simple, cost-effective Databricks sandbox environments in AWS. Designed for quick deployment, easy teardown, and alignment with secure reference architectures.

## 1. How it works:
### Secure Reference Architecture
This project aligns with the official Databricks Secure Reference Architecture (SRA):

[Databricks Terraform SRA – Azure](https://github.com/databricks/terraform-databricks-sra)

## 2. What this deploys:

This project provides a modular set of Terraform templates to deploy **Databricks sandbox environments on AWS**. It's designed for simplicity, cost-efficiency, and reusability in mind — enabling data engineers at made tech to quickly spin up and tear down sandbox workspaces with minimal overhead.

## 3. It provisions:
1. A databricks workspace in AWS
2. VPC and subnet (via SRA)
3. Credentials and storage configurations
4. Secure defaults (auto termination, no PrivateLink)

## 4. Prerequisites

- [ ] AWS SSO access to the Made Tech sandbox account
- [ ] A Databricks **account ID** and a **service principal**
- [ ] Terraform CLI (v1.3+)
- [ ] AWS CLI with SSO support (`aws sso login`)
- [ ] Databricks Terraform provider (auto-installed)
---
## 5. Project Structure

```bash
.
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── terraform.tfvars        # local only
│       └── providers.tf
├── modules/                        # Optional for extension
├── .env                            # not committed
├── .gitignore
└── README.md
```
---
 ## 6. Getting started

1. Clone the repo above as usual
2. Create a .env file for secrets at the root of the repository (ie databricks_sandbox/.env)
3. Add the following:
```bash
TF_VAR_databricks_account_id=acc-xxxxxxxxxxxxxxxx
TF_VAR_client_id=your-databricks-client-id
TF_VAR_client_secret=your-databricks-client-secret
TF_VAR_aws_account_id=261219435789
```
4. Authenticate with AWS SSO:
```bash
aws sso login --profile databricks-sandbox
```
5. Load environment variables from .env:
```bash
source ../../.env (this is in terminal)
```
6. Run terraform:
```bash
terraform init
terraform validate
terraform plan
terraform apply
```
7. To destroy and teardown the sandbox environment:
```bash
terraform destroy
```


