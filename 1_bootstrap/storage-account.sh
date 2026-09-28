#!/usr/bin/env bash

set -euo pipefail

echo "Creating storage account: ${STORAGE_ACCOUNT_NAME}"

az storage account create \
  --name "${STORAGE_ACCOUNT_NAME}" \
  --resource-group "${RESOURCE_GROUP_NAME}" \
  --subscription "${AZURE_SUBSCRIPTION_ID}" \
  --location "${LOCATION}" \
  --sku Standard_ZRS \
  --kind StorageV2 \
  --https-only true \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  --allow-shared-key-access false \
  --default-action Allow \
  --tags \
    Environment="${ENVIRONMENT}" \
    ManagedBy="AzureCLI" \
    ProjectName="CWP-Migration"

echo "Configuring storage account"

az storage account update \
  --name "${STORAGE_ACCOUNT_NAME}" \
  --resource-group "${RESOURCE_GROUP_NAME}" \
  --subscription "${AZURE_SUBSCRIPTION_ID}" \
  --set defaultToOAuthAuthentication=true \
  --allow-cross-tenant-replication false

echo "Configuring blob service"

az storage account blob-service-properties update \
  --account-name "${STORAGE_ACCOUNT_NAME}" \
  --resource-group "${RESOURCE_GROUP_NAME}" \
  --subscription "${AZURE_SUBSCRIPTION_ID}" \
  --enable-versioning true \
  --enable-delete-retention true \
  --delete-retention-days 7 \
  --enable-container-delete-retention true \
  --container-delete-retention-days 7

echo "Storage account ${STORAGE_ACCOUNT_NAME} is ready"