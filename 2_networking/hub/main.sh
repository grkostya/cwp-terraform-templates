#!/usr/bin/env bash

set -euo pipefail

terraform init \
  -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP_NAME}" \
  -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT_NAME}" \
  -backend-config="container_name=${BACKEND_CONTAINER_NAME}" \
  -backend-config="key=terraform.tfstate-NETWORKING-HUB" \
  -backend-config="use_azuread_auth=true"

terraform workspace select hub || \
terraform workspace new hub

terraform plan -var-file="hub.tfvars" 