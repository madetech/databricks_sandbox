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
------------
## Destroying the Sandbox (via PR title)
To destroy your sandbox using CI/CD:

* Temporarily comment out terraform plan and apply in .github/workflows/deploy_destroy.yml
(otherwise GitHub Actions might try to run both deploy and destroy)
* Open a new Pull Request with the word destroy in the PR title
(e.g. destroy sandbox for bob)

The GitHub workflow will then:
* Run terraform destroy -auto-approve
* Tear down most associated resources automatically

### Leftovers?
Some things may not cleanly delete — like VPCs with lingering network interfaces, or UC catalogs/schemas with data.

If this happens perform the following 3 steps to remove different aspects:
1. Databricks leftovers (like schemas/catalogs)
* Drop them directly in Databricks SQL:
```sql
DROP SCHEMA <schema_name> CASCADE;
DROP CATALOG <catalog_name> CASCADE;
```

2. AWS leftovers
* Most resources are tagged with Project = sandbox-<yourname>.
* Option A: Manually delete in the AWS Console (NAT gateways, ENIs, subnets, etc.)
* Option B: Untag via CLI:
```bash
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=Project,Values=sandbox-<yourname> \
  --query 'ResourceTagMappingList[].ResourceARN' \
  --output text | xargs -n 1 aws resourcegroupstaggingapi untag-resources --tag-keys Project --resource-arn-list
Then manually delete them, or use aws ec2 delete-* based on type.
```

3. Run the cleanup.sh script locally:
* Make sure to set the correct tag in the script:  export SANDBOX_TAG="sandbox-<yourname>"
```bash
chmod +x cleanup.sh
./cleanup.sh
```
This script will:
* Delete any NAT gateways, subnets, ENIs, EIPs, and security groups tagged with your sandbox name
* Give Terraform a clean slate on the next deploy

That's it. Hopefully this will remove all resources and any dependancies - last resort is to just go through the AWS resources and see what's not being deleted.

## Notes for Contributors
* Do not commit your .env or terraform.tfvars files.
* Validate all Terraform changes using terraform validate.
* Format changes using terraform fmt.
* Follow the standard GitHub PR workflow and use feature branches.
* Errors may start cropping up at terraform plamn, in which case troubleshooting will be required, read the errors carefully

## Errors
* NOTE: External location and catalog can be manually imported via:
```bash
terraform import \
  module.sra.module.uc_catalog.databricks_external_location.workspace_catalog_external_location \
  sandbox-zeerak-catalog-29677xxxxxx-external-location

terraform import \
  module.sra.module.uc_catalog.databricks_catalog.workspace_catalog \
  sandbox_zeerak_catalog_29677xxxxxx

Imported existing catalog: sandbox_zeerak_catalog_29677xxxxxx
Imported external location: sandbox-zeerak-catalog-29677xxxxxx-external-location
```


## Known Limitations
* CloudTrail is not enabled automatically.
* Public subnet routing is not included by default.
* Not all workspace-level permissions (e.g. SQL access) are fully automat

## Support
If you encounter issues with Terraform state, network setup, or authentication, reach out in the #cop-cloud or #data-practice Slack channel or tag/message me @ZeerakAziz for infrastructure-related questions.
