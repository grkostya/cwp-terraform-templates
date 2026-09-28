#!/usr/bin/env bash

set -euo pipefail

CONTAINERS=(
  "core"
  "networking"
  "monitoring"
  "akbp-cwp"
)

echo "Creating Terraform state containers"

for container in "${CONTAINERS[@]}"; do
  echo "Creating container: ${container}"

  az storage container create \
    --name "${container}" \
    --account-name "${STORAGE_ACCOUNT_NAME}" \
    --auth-mode login
done

echo "Terraform state containers are ready"