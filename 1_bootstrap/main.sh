#!/usr/bin/env bash

set -euo pipefail

ENVIRONMENT="${1:?Usage: ./main.sh <environment>}"

source ./variables.sh

./resource-group.sh
./storage-account.sh
./containers.sh