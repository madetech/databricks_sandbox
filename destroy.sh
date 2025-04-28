#!/bin/bash

# destroy.sh
# Author: Zeerak
# Purpose: Safely destroy Databricks Unity Catalog objects first, then Terraform infra
# Mode: DRY RUN (only lists catalogs)

set -euo pipefail

# Toggle DRY_RUN mode
# Set to "true" for Dry Run (only list catalogs, no deletion)
# Set to "false" to actually delete catalogs
DRY_RUN=true

echo "====================================="
echo "Starting Databricks Sandbox Destroy Script (Dry Run Mode)"
echo "====================================="

# Configuration variables
DATABRICKS_HOST=${DATABRICKS_HOST:-""}
DATABRICKS_TOKEN=${DATABRICKS_TOKEN:-""}
CATALOG_PREFIX=${CATALOG_PREFIX:-"sandbox-"}
ENVIRONMENT_FOLDER=${ENVIRONMENT_FOLDER:-"environments/zeerak"}

# Check required variables
if [[ -z "$DATABRICKS_HOST" || -z "$DATABRICKS_TOKEN" ]]; then
  echo "Error: Missing Databricks host or token."
  exit 1
fi

# Authenticate Databricks CLI
databricks configure --host "$DATABRICKS_HOST" --token "$DATABRICKS_TOKEN"

# List catalogs matching the prefix
echo "Searching for catalogs with prefix: $CATALOG_PREFIX"
catalogs=$(databricks unity-catalog list-catalogs | jq -r ".catalogs[].name" | grep "^${CATALOG_PREFIX}" || true)

if [[ -z "$catalogs" ]]; then
  echo "No catalogs found matching prefix: $CATALOG_PREFIX"
else
  echo "Catalogs found:"
  echo "$catalogs"

  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Dry Run mode active. No catalogs will be deleted."
    for catalog in $catalogs; do
      echo "Would delete catalog: $catalog"
    done
  else
    echo "Proceeding to delete catalogs."

    # Safety confirmation prompt
    echo "Warning: This operation will permanently delete the above catalogs."
    echo "Type YES to confirm:"
    read -r CONFIRMATION
    if [[ "$CONFIRMATION" != "YES" ]]; then
      echo "Operation cancelled by user."
      exit 1
    fi

    for catalog in $catalogs; do
      echo "Deleting catalog: $catalog"
      databricks unity-catalog delete-catalog --name "$catalog" --force
    done
  fi
fi

echo "====================================="
echo " Unity Catalog cleanup complete "
echo "====================================="
