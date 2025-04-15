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
3. IAM roles and cross-account trust policies
4. KMS encryption for managed and workspace data
5. S3 buckets for root and Unity Catalog storage (with versioning)
6. Optional Unity Catalog metastore (toggleable)
7. A shared compute cluster for testing
8. Unity Catalog metastore, external location, storage credential, and default catalog

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

1. Clone the repo above as usual and
```bash
cd databricks_sandbox/environments/dev
```
2. Create your .env file for secrets at the root of the repository (ie databricks_sandbox/.env)
3. Add the following to the .env file:
```bash
DATABRICKS_ACCOUNT_ID=acc-xxxxxxxxxxxxxxxx
DATABRICKS_CLIENT_ID=your-databricks-client-id
DATABRICKS_CLIENT_SECRET=your-databricks-client-secret
AWS_ACCOUNT_ID=your-aws-account-id
AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
AWS_ACCESS_KEY_ID=your-aws-key-id

Where to find your credentials:
DATABRICKS_ACCOUNT_ID: Databricks Account Console (e.g. https://accounts.cloud.databricks.com/?o=acc-xxxxxxxxxxxxxxxx) → top right dropdown → copy Account ID 
DATABRICKS_CLIENT_ID & DATABRICKS_CLIENT_SECRET: From the Service Principal you created in the Databricks console
DATABRICKS_CLIENT_SECRET: From the same Service Prinicpal — secret is visible once at creation; store in .env_2 ideally
AWS_ACCOUNT_ID: Ask the infra team or retrieve via aws sts get-caller-identity
AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY: From an AWS IAM user or programmatic access setup (if not using SSO)
```
4. Edit the terrraform.tfvars file, insert your name where it says 'yourname' and leave the rest:
```bash
resource_prefix    = "sandbox-yourname" #Provisioned resources will be based on your resource_prefix (e.g. sandbox-alex-shared-cluster)
admin_user = "your.email@madetech.com" #To grant admin access to the workspace
```
The resource_prefix must be unique across the AWS account to avoid naming collisions.
5. Authenticate with AWS SSO:
```bash
aws sso login or aws configure sso
```
6. Load environment variables from .env:
```bash
source ../../.env (this is in terminal)
```
7. Unity Catalog
The first user of the week should deploy Unity Catalog if it hasn't yet been created. If it has already been created in your Databricks account, set:
```bash
metastore_exists = true
```
When metastore_exists=false, Terraform will:
* Create a new Unity Catalog metastore
* Configure the root storage bucket and KMS key
* Set up storage credentials and external locations
* Create the default catalog and system schemas
8. Run terraform:
```bash
terraform init
terraform validate
terraform plan #errors may start cropping up here, in which case troubleshooting will be required, read the errors carefully they explain quite well
terraform apply
```
9. To destroy and teardown the sandbox environment:
```bash
terraform destroy
```

## Notes for Contributors
* Do not commit your .env or terraform.tfvars files.
* Validate all Terraform changes using terraform validate.
* Format changes using terraform fmt.
* Follow the standard GitHub PR workflow and use feature branches.

## Known Limitations
* CloudTrail is not enabled automatically.
* Public subnet routing is not included by default.
* Not all workspace-level permissions (e.g. SQL access) are fully automat

## Support
If you encounter issues with Terraform state, network setup, or authentication, reach out in the #cop-cloud or #data-practice Slack channel or tag/message me @ZeerakAziz for infrastructure-related questions.
