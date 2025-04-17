# Databricks Sandbox Terraform Module
Reusable Terraform modules to provision simple, cost-effective Databricks sandbox environments in AWS. Designed for quick deployment, easy teardown, and alignment with secure reference architectures.

## 1. How it works:
### Secure Reference Architecture
This project aligns with the official Databricks Secure Reference Architecture (SRA):

[Databricks Terraform SRA – Azure](https://github.com/databricks/terraform-databricks-sra)

## 2. What this deploys:

This project provides a modular set of Terraform templates to deploy **Databricks sandbox environments on AWS**. It's designed for simplicity, cost-efficiency, and reusability in mind — enabling data engineers at made tech to quickly spin up and tear down sandbox workspaces with minimal overhead.

### It provisions:
1. A databricks workspace in AWS
2. Secure networking: VPC, subnets, NAT gateway, route tables
3. IAM roles and cross-account trust policies
4. KMS encryption for managed and workspace data
5. S3 buckets for root and Unity Catalog storage (with versioning)
6. Optional Unity Catalog metastore (toggleable)
7. A shared compute cluster for testing
8. Unity Catalog metastore, external location, storage credential, and catalog setup

## 3. Prerequisites

- [ ] AWS SSO access to the Made Tech sandbox account
- [ ] A Databricks **account ID** and a **service principal**
- [ ] Terraform CLI (v1.3+)
- [ ] AWS CLI with SSO support (`aws sso login`)
- [ ] Databricks Terraform provider (auto-installed)
## 4. Project Structure
```bash
.
├── environments/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── terraform.tfvars         # Local only, do NOT commit
├── .env                         # a secrets file (gitignored)
├── .env.example                 # Template for others to copy
├── .github/workflows/deploy.yml
└── README.md
```
<<<<<<< Updated upstream
---
## 6. Deploy You Databricks Sandbox
This project uses GitHub Actions to automate provisioning of Databricks sandboxes in AWS using Terraform. All secrets are inserted securely via GitHub Secrets, and deployments are triggered through Pull Requests
1. Create a new branch:
```bash
git checkout -b feat/initials_sandbox e.g. feat/za_sandbox
```
2. Copy the base environment folder
```
cp -r environments/dev environments/<yourname>
```
3. Edit part of your terraform.tfvars:
```bash
resource_prefix       = "sandbox-<yourname>"
metastore_exists      = false #first time false, change to true after UC is created once
```
4. To set up personal secrets (locally), copy the example file
```bash
cp .env.example .env
```
5. Fill in your actual Databricks credentials:
```bash
TF_VAR_client_id=your-databricks-client-id
TF_VAR_client_secret=your-databricks-client-secret
TF_VAR_databricks_account_id=your-databricks-account-id
TF_VAR_admin_user=your.email@madetech.com
```
6.Load them into your terminal:
```bash
source .env
```
7. Commit and push. Make sure the .env file is in .gitignore.
```bash
git add environments/<yourname>
git commit -m "Add sandbox for <yourname>"
git push --set-upstream origin feature/<initials>_sandbox
```
# What happens automatically:
1. Engineer opens a pull request to main
2. GitHub Actions detects changes in environments/**
3. The deploy.yml workflow runs:
* Injects shared AWS + Databricks secrets
* Runs terraform init, plan, and apply
4. The sandbox is provisioned using:
* Terraform module (sra)
* Correct network, cluster, and UC setup
5. You can see logs live in the PR → Actions tab

## 7. Getting started

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
=======
----------
## 5. Deploying your Databricks Sandbox
This project uses GitHub Actions to automate provisioning of Databricks sandboxes in AWS using Terraform. All secrets are inserted securely via GitHub Secrets, and deployments are triggered through Pull Requests
### Step 1 Getting Started:
1. Set up your .env file
To set up personal secrets (locally), copy the example file
```bash
cp .env.example .env
```
2. Fill in your databricks-client-id, databricks-client-secret and your email:
```bash
TF_VAR_admin_user=your.email@madetech.com
TF_VAR_client_id=your-databricks-client-id
TF_VAR_client_secret=your-databricks-client-secret
```
3. Configure terraform.tfvars
Edit environments/terraform.tfvars with your sandbox-specific values:
```bash
resource_prefix       = "sandbox-<yourname>" # Provisioned resources will be based on your resource_prefix (e.g. sandbox-alex-cluster)
metastore_exists      = false # First time false, change to true after UC is created once
```
Notes:
  * resource_prefix must be unique across the AWS account to avoid naming collisions.
  * If you're the first person creating Unity Catalog for the week, set metastore_exists = false.
  * Terraform will then:
      * Create the Unity Catalog metastore
      * Configure the root storage bucket and KMS key
      * Set up external locations, storage credentials, and default catalog
------
### Step 2 Deploy via github actions:
4. Create a new feature branch:
```bash
git checkout -b feat/initials_sandbox e.g. feat/za_sandbox
```
5. Commit and push your changes:
```bash
git add environments/terraform.tfvars
git commit -m "Add sandbox for <yourname>"
git push --set-upstream origin feat/<initials>_sandbox
```
7. Commit and push. Make sure the .env file is in .gitignore.
```bash
git add environments/terraform.tfvars
git commit -m "Add sandbox for <yourname>"
git push --set-upstream origin feature/<initials>_sandbox
```
8. Open a pull request to main - do not merge!
This will :
* Trigger the deploy workflow
* Use your .tfvars + GitHub Secrets
* Run terraform init, plan, and apply
* Provision your sandbox automatically
----------
### Step 3 Final — Verify Your Environment:
9. Go to the Pull Request → Actions tab
    * Confirm that terraform plan and terraform apply both ran without errors.
10. Log in to Databricks- select your workspace that should be named using your:
    * workspace_name (from terraform.tfvars)
    * and resource_prefix
11. Inside the workspace:
    * Go to Compute to check your shared cluster
    * Go to Data → Unity Catalog to verify the catalog and schemas

## If everything looks good, your sandbox is now live.
>>>>>>> Stashed changes

## Notes for Contributors
* Do not commit your .env or terraform.tfvars files.
* Validate all Terraform changes using terraform validate.
* Format changes using terraform fmt.
* Follow the standard GitHub PR workflow and use feature branches.
* Errors may start cropping up at terraform plamn, in which case troubleshooting will be required, read the errors carefully

## Known Limitations
* CloudTrail is not enabled automatically.
* Public subnet routing is not included by default.
* Not all workspace-level permissions (e.g. SQL access) are fully automat

## Support
If you encounter issues with Terraform state, network setup, or authentication, reach out in the #cop-cloud or #data-practice Slack channel or tag/message me @ZeerakAziz for infrastructure-related questions.
