#!/usr/bin/env bash

# Naming
export SUBSCRIPTION_CODE="akbp"
export REGION_CODE="weu"

# Terraform backend
export BACKEND_RESOURCE_GROUP_NAME="rg-cwp-migration-${SUBSCRIPTION_CODE}-${ENVIRONMENT}-${REGION_CODE}"
export BACKEND_STORAGE_ACCOUNT_NAME="stcwpmig${SUBSCRIPTION_CODE}${ENVIRONMENT}${REGION_CODE}"
export BACKEND_CONTAINER_NAME="networking"

# Terraform variables
export TF_VAR_tenant_id="${AZURE_TENANT_ID}"
export TF_VAR_subscription_id="${AZURE_SUBSCRIPTION_ID}"
export TF_VAR_subscription_code="${SUBSCRIPTION_CODE}"
export TF_VAR_location_short="${REGION_CODE}"
