#!/usr/bin/env bash

set -euo pipefail

STACK="${1:?Usage: ./main.sh <stack> <environment>}"
ENVIRONMENT="${2:?Usage: ./main.sh <stack> <environment>}"
export STACK
export ENVIRONMENT

source ./variables.sh
./${STACK}/main.sh