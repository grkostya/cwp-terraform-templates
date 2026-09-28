#!/usr/bin/env bash

export LOCATION="westeurope"
export REGION_CODE="weu"

export PROJECT_CODE="akbp"
export APP_CODE="cwp-migration"

export NAME_SUFFIX="${APP_CODE}-${PROJECT_CODE}-${ENVIRONMENT}-${REGION_CODE}"

export RESOURCE_GROUP_NAME="rg-${NAME_SUFFIX}"
export STORAGE_ACCOUNT_NAME="stcwpmig${PROJECT_CODE}${ENVIRONMENT}${REGION_CODE}"