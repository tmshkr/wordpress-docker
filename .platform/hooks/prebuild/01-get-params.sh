#!/bin/bash

set -o xtrace
set -e

echo "STAGE=staging" >>.env
source .env
# Retrieve parameters from AWS SSM
repo="${GITHUB_REPOSITORY#*/}"
aws ssm get-parameters-by-path --path "/$repo/$STAGE/" \
    --recursive --with-decryption --query "Parameters[*].[Name,Value]" \
    --output text | while read -r name value; do
    key=$(echo $name | sed "s/\/$repo\/$STAGE\///")
    echo "$key=$value" >>.env
done

aws ssm get-parameter --name "/$repo/DEPLOY_KEY" \
    --with-decryption --query "Parameter.Value" --output text >~/.ssh/id_ed25519
