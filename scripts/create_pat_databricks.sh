#!/bin/bash

set -e

# 1. Prompt for required input
read -p "Enter your Databricks workspace URL (e.g., https://<workspace>.azuredatabricks.net): " DATABRICKS_HOST
read -p "Enter your Azure AD Application (Client) ID: " DATABRICKS_CLIENT_ID
read -s -p "Enter your Azure AD Application Secret: " DATABRICKS_CLIENT_SECRET
echo
read -p "Enter your Azure AD Tenant ID: " DATABRICKS_TENANT_ID

# 2. Get Azure AD token
echo "Getting Azure AD access token..."
ACCESS_TOKEN=$(curl -s -X POST -d "client_id=$DATABRICKS_CLIENT_ID&client_secret=$DATABRICKS_CLIENT_SECRET&grant_type=client_credentials&resource=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d" \
  https://login.microsoftonline.com/$DATABRICKS_TENANT_ID/oauth2/token | jq -r .access_token)

# 3. Create Databricks PAT token using API
echo "Creating Databricks PAT token..."
DATABRICKS_PAT=$(curl -s -X POST "$DATABRICKS_HOST/api/2.0/token/create" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{"lifetime_seconds": 3600, "comment": "Terraform-generated token"}' | jq -r .token_value)

if [[ "$DATABRICKS_PAT" == "null" || -z "$DATABRICKS_PAT" ]]; then
  echo "❌ Failed to create Databricks token. Check credentials and permissions."
  exit 1
fi

echo "✅ Databricks PAT token created."

# 4. Export the token so Terraform can use it
export TF_VAR_databricks_token="$DATABRICKS_PAT"

# 5. Run Terraform
echo "Running Terraform apply..."
terraform apply -auto-approve
