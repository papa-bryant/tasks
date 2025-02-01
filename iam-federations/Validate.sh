#!/bin/bash

# FEDERATION IAM
TFSTATEDIR=CloudOpsState
ACCOUNT=`aws sts get-caller-identity |jq -r .Account`
TFFILE=$TFSTATEDIR/$ACCOUNT-terraform.tfstate
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export TF_DATA_DIR=/tmp/terraform.$ACCOUNT
export AWS_DEFAULT_REGION=us-west-2

echo "$TFFILE"

terraformNEW init -upgrade -var="orgs_account_id=789681003108"
terraformNEW validate
if [[ $? -ne 0 ]]; then
    echo "Apply Exited Non-zero"
    exit 2
fi
