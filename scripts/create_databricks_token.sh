#!/bin/bash

set -e

# Prompt user for Databricks host and token
read -p "Enter your Databricks workspace URL (e.g., https://<workspace>.azuredatabricks.net): " DATABRICKS_HOST
read -s -p "Enter your Databricks PAT token: " DATABRICKS_TOKEN
echo

# Confirm saving
echo "Configuring Databricks CLI with the provided host and token..."

# Create ~/.databrickscfg if not exists
CONFIG_FILE="$HOME/.databrickscfg"

# Backup existing config
if [[ -f "$CONFIG_FILE" ]]; then
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
fi

# Write new default profile
cat > "$CONFIG_FILE" <<EOL
[DEFAULT]
host = $DATABRICKS_HOST
token = $DATABRICKS_TOKEN
EOL

echo "✅ Databricks CLI configured successfully."
echo "You can now use the Databricks CLI with the configured host and token."