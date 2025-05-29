#!/bin/bash

# Wrapper to destroy Terraform resources and clean up secrets file

# === CONFIGURATION ===
SECRETS_FILE_PATH="./secrets"
SECRETS_FILENAME="bigdataintegrationsecrets.txt"
FULL_SECRETS_PATH="${SECRETS_FILE_PATH}/${SECRETS_FILENAME}"

# === DESTROY TERRAFORM INFRASTRUCTURE ===
echo "Running terraform destroy..."
terraform destroy -auto-approve

# === CLEANUP SECRETS FILE ===
if [ -f "$FULL_SECRETS_PATH" ]; then
    echo "Cleaning up secrets file at $FULL_SECRETS_PATH..."
    rm -f "$FULL_SECRETS_PATH"
    echo "Secrets file deleted."
else
    echo "No secrets file found at $FULL_SECRETS_PATH. Nothing to clean."
fi

echo "Destroy and cleanup completed."
