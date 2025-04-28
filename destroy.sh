#!/bin/bash

# destroy.sh
# Purpose: Clean up Databricks Unity Catalog objects only
# Author: Made Tech Engineering
# Version: Final Production Version

set -euo pipefail

# Toggle DRY_RUN mode
DRY_RUN=true

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

echo "Unity Catalog cleanup complete."
