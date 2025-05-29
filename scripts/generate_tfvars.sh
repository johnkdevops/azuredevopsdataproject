#!/bin/bash

echo "Generating terraform.tfvars..."

# Helper to prompt required input
prompt_required() {
  local var_name=$1
  local prompt_text=$2
  local input=""
  while [[ -z "$input" ]]; do
    read -p "$prompt_text (required): " input
  done
  eval "$var_name=\"\$input\""
}

# Helper to prompt optional input with default
prompt_with_default() {
  local var_name=$1
  local prompt_text=$2
  local default_value=$3
  read -p "$prompt_text [default: $default_value]: " input
  input="${input:-$default_value}"
  eval "$var_name=\"\$input\""
}

# Detect OS type (Windows, Linux, or macOS)
get_os_type() {
  case "$(uname -s)" in
    Linux*)     echo "linux";;
    Darwin*)    echo "macos";;
    CYGWIN*|MINGW*) echo "windows";;
    *)          echo "unknown";;
  esac
}

# Determine OS type
os_type=$(get_os_type)

# Prompt for all fields
prompt_required current_user_object_id "Enter Current User Object ID"
prompt_required current_user_principal_name "Enter Current User Principal Name"
prompt_with_default resource_group_name "Enter Resource Group Name " "DataPipelineRG"
prompt_with_default location "Enter Azure Region" "East US 2"
prompt_with_default databricks_workspace_name "Enter Databricks Workspace Name" "datapipeline-db"
prompt_with_default synapse_workspace_name "Enter Synapse Workspace Name" "data-pipeline-synapse"
prompt_with_default sql_admin_username "Enter SQL Admin Username" "sqladminuser"
prompt_required sql_admin_password "Enter SQL Admin Password"
prompt_required tenant_id "Enter Tenant ID"
prompt_required subscription_id "Enter Subscription ID"

# Prompt for secrets file path based on OS
if [[ "$os_type" == "windows" ]]; then
  prompt_required secrets_file_path "Enter Secrets File Path (e.g., C:/path/to/secrets)"
elif [[ "$os_type" == "linux" || "$os_type" == "macos" ]]; then
  prompt_required secrets_file_path "Enter Secrets File Path (e.g., /home/user/secrets)"
else
  prompt_required secrets_file_path "Enter Secrets File Path (Unknown OS)"
fi

prompt_optional data_engineer_user_object_id "Enter Data Engineer User Object ID"
prompt_optional data_engineer_user_principal_name "Enter Data Engineer User Principal Name"

# IP address collection
echo "Enter at least one allowed IP address for Synapse Firewall:"
ip_entries=()

while true; do
  read -p "Enter name for IP address (or leave empty to finish): " ip_name
  if [[ -z "$ip_name" && ${#ip_entries[@]} -gt 0 ]]; then
    break
  elif [[ -n "$ip_name" ]]; then
    read -p "Enter start IP address for $ip_name: " start_ip
    read -p "Enter end IP address for $ip_name (leave blank to use start IP): " end_ip

    if [[ -n "$start_ip" ]]; then
      end_ip=${end_ip:-$start_ip}
      ip_entries+=("$ip_name|$start_ip|$end_ip")
    else
      echo "⚠️  Skipping incomplete IP entry for '$ip_name'. Start IP is required."
    fi
  else
    if [[ ${#ip_entries[@]} -eq 0 ]]; then
      echo "❌ You must enter at least one valid IP address block."
    else
      break
    fi
  fi
done

# Write to terraform.tfvars
cat > terraform.tfvars <<EOF
current_user_object_id            = "$current_user_object_id"
current_user_principal_name       = "$current_user_principal_name"
data_engineer_user_object_id      = "$data_engineer_user_object_id"
data_engineer_user_principal_name = "$data_engineer_user_principal_name"
resource_group_name               = "$resource_group_name"
location                          = "$location"
databricks_workspace_name         = "$databricks_workspace_name"
synapse_workspace_name            = "$synapse_workspace_name"
sql_admin_username                = "$sql_admin_username"
sql_admin_password                = "$sql_admin_password"
tenant_id                         = "$tenant_id"
subscription_id                   = "$subscription_id"
secrets_file_path                 = "$secrets_file_path"
allowed_ip_addresses              = [
EOF

for entry in "${ip_entries[@]}"; do
  IFS='|' read -r name start end <<< "$entry"
  echo "  {" >> terraform.tfvars
  echo "    name             = \"$name\"" >> terraform.tfvars
  echo "    start_ip_address = \"$start\"" >> terraform.tfvars
  echo "    end_ip_address   = \"$end\"" >> terraform.tfvars
  echo "  }," >> terraform.tfvars
done

echo "]" >> terraform.tfvars

echo "✅ terraform.tfvars generated successfully."
echo "Remember to check the generated terraform.tfvars file for accuracy."
echo "You can now run 'terraform init' to initialize the Terraform configuration."
echo "You can now run 'terraform plan' to see the resources that will be created."
echo "If everything looks good, run 'terraform apply' to create the resources."
echo "If you need to make any changes, you can edit the terraform.tfvars file directly."
echo "If you want to run the script again, please delete the existing terraform.tfvars file."
echo "If you have any questions, please refer to the documentation or contact support."
echo "Thank you for using the Azure Data Pipeline Terraform script!"
