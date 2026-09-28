#!/usr/bin/env bash

# Azure
export LOCATION="westeurope"

# Naming
export SUBSCRIPTION_CODE="akbp"
export REGION_CODE="weu"

# Terraform backend
export BACKEND_RESOURCE_GROUP_NAME="rg-cwp-migration-${SUBSCRIPTION_CODE}-${ENVIRONMENT}-${REGION_CODE}"
export BACKEND_STORAGE_ACCOUNT_NAME="stcwpmig${SUBSCRIPTION_CODE}${ENVIRONMENT}${REGION_CODE}"
export BACKEND_CONTAINER_NAME="networking"