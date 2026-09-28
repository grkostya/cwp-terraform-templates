#!/usr/bin/env bash

export ENVIRONMENT="dev"
export SUBSCRIPTION_ID="4060f1e9-e5b0-4203-8db2-500f0922ccf7"

export LOCATION="westeurope"
export REGION_CODE="weu"

export PROJECT_CODE="akbp"
export APP_CODE="cwp-migration"
export INSTANCE="001"

export NAME_SUFFIX="${APP_CODE}-${PROJECT_CODE}-${ENVIRONMENT}-${REGION_CODE}-${INSTANCE}"

export RESOURCE_GROUP_NAME="rg-${NAME_SUFFIX}"
export STORAGE_ACCOUNT_NAME="stcwpmig${PROJECT_CODE}${ENVIRONMENT}${REGION_CODE}${INSTANCE}"