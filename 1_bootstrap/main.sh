#!/usr/bin/env bash

set -euo pipefail
source ./variables.sh

./resource-group.sh
./storage-account.sh
./containers.sh