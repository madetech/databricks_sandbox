#!/bin/bash

# generate-host.sh
# Purpose: Extract Databricks Workspace Host URL from Terraform Outputs

set -euo pipefail

# Default environment folder if not passed
ENVIRONMENT_FOLDER=${1:-"environments/zeerak"}

echo "Fetching Databricks workspace host from $ENVIRONMENT_FOLDER..."

cd "$ENVIRONMENT_FOLDER"

# Initialize Terraform (if needed)
terraform init

# Output the workspace host URL
DATABRICKS_HOST=$(terraform output -raw databricks_host)

echo "====================================="
echo "Your DATABRICKS_HOST is:"
echo "$DATABRICKS_HOST"
echo "====================================="
