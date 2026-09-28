#!/usr/bin/env bash

set -euo pipefail

echo "Creating resource group: ${RESOURCE_GROUP_NAME}"

az group create \
  --name "${RESOURCE_GROUP_NAME}" \
  --location "${LOCATION}" \
  --subscription "${AZURE_SUBSCRIPTION_ID}" \
  --tags \
    Environment="${ENVIRONMENT}" \
    ManagedBy="AzureCLI" \
    ProjectName="CWP-Migration"

echo "Resource group ${RESOURCE_GROUP_NAME} is ready"