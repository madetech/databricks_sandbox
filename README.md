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
2. Secure networking: VPC, subnets, NAT gateway, route tables
<<<<<<< HEAD
3. IAM roles and cross-account trust policies
4. KMS encryption for managed and workspace data
=======
5. S3 buckets for root and Unity Catalog storage (with versioning)
6. Optional Unity Catalog metastore (toggleable)
7. A shared compute cluster for testing
8. Unity Catalog metastore, external location, storage credential, and default catalog
>>>>>>> feat/databricks_sra

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
│       ├── terraform.tfvars        # local only, DO NOT COMMIT
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
3. Add the following to the .env file:
```bash
DATABRICKS_ACCOUNT_ID=acc-xxxxxxxxxxxxxxxx
DATABRICKS_CLIENT_ID=your-databricks-client-id
DATABRICKS_CLIENT_SECRET=your-databricks-client-secret
AWS_ACCOUNT_ID=261219435789
AWS_SECRET_ACCESS_KEY=
AWS_ACCESS_KEY_ID=
```
4. Edit the terrraform.tfvars file, insert your name where it says 'yourname' and leave the rest:
```bash
resource_prefix    = "sandbox-yourname"
```
5. Authenticate with AWS SSO:
```bash
aws sso login --profile databricks-sandbox
```
6. Load environment variables from .env:
```bash
source ../../.env (this is in terminal)
```
7. Run terraform:
```bash
terraform init
terraform validate
terraform plan
terraform apply
```
8. To destroy and teardown the sandbox environment:
```bash
terraform destroy
```
