# Generate random strings for unique names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account for Synapse
resource "azurerm_storage_account" "storage" {
  name                     = "datastorage${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true

  depends_on = [azurerm_resource_group.rg]
}

# Storage Container (File System)
resource "azurerm_storage_data_lake_gen2_filesystem" "filesystem" {
  name               = "filestorage${random_string.suffix.result}"
  storage_account_id = azurerm_storage_account.storage.id

  depends_on = [azurerm_storage_account.storage]
}

# Databricks Workspace
resource "azurerm_databricks_workspace" "databricks" {
  name                = var.databricks_workspace_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "trial"

  depends_on = [azurerm_resource_group.rg]
}

# Delay to ensure Databricks workspace DNS is resolvable
resource "time_sleep" "wait_for_databricks" {
  create_duration = "120s" # Wait 120 seconds after workspace creation

  depends_on = [azurerm_databricks_workspace.databricks]
}

# Synapse Workspace
resource "azurerm_synapse_workspace" "synapse" {
  name                                 = "${var.synapse_workspace_name}-${random_string.suffix.result}"
  resource_group_name                  = azurerm_resource_group.rg.name
  location                             = azurerm_resource_group.rg.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.filesystem.id
  sql_administrator_login              = var.sql_admin_username
  sql_administrator_login_password     = var.sql_admin_password

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_resource_group.rg,
    azurerm_storage_account.storage,
    azurerm_storage_data_lake_gen2_filesystem.filesystem
  ]
}

# Role Assignments: Contributor for Current User
resource "azurerm_role_assignment" "rg_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = var.data_engineer_user_object_id

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_role_assignment" "databricks_contributor" {
  scope                = azurerm_databricks_workspace.databricks.id
  role_definition_name = "Contributor"
  principal_id         = var.data_engineer_user_object_id

  depends_on = [azurerm_databricks_workspace.databricks]
}

resource "azurerm_role_assignment" "synapse_contributor" {
  scope                = azurerm_synapse_workspace.synapse.id
  role_definition_name = "Contributor"
  principal_id         = var.data_engineer_user_object_id

  depends_on = [azurerm_synapse_workspace.synapse]
}

# Add Synapse Administrator role to your user account
resource "azurerm_synapse_role_assignment" "synapse_admin" {
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  role_name           = "Synapse Administrator"
  principal_id        = var.current_user_object_id # Replace with your Azure AD user/group object ID
}

# Storage Blob Data Contributor for Current User
data "azurerm_client_config" "current" {}
resource "azurerm_role_assignment" "storage_blob_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [azurerm_storage_account.storage]
}

# Databricks PAT for Azure Pipelines
resource "databricks_token" "pat" {
  comment          = "Terraform-generated PAT for Azure Pipeline"
  lifetime_seconds = 7776000 # 90 days (adjust as needed)

  depends_on = [
    azurerm_databricks_workspace.databricks,
    time_sleep.wait_for_databricks
  ]
}

# Null resource to write outputs to a text file
resource "null_resource" "write_secrets_file" {
  triggers = {
    always_run = "${timestamp()}" # Ensures it runs on every apply
  }


  provisioner "local-exec" {
    command = "echo 'Variable group: bigdataintegrationsecrets' > bigdataintegrationsecrets.txt && echo '' >> bigdataintegrationsecrets.txt && echo 'azureSubscription: ${var.subscription_id}' >> bigdataintegrationsecrets.txt && echo 'databricksToken: ${databricks_token.pat.token_value}' >> bigdataintegrationsecrets.txt && echo 'databricksWorkspaceUrl: ${azurerm_databricks_workspace.databricks.workspace_url}' >> bigdataintegrationsecrets.txt && echo 'synapseWorkspaceName: ${azurerm_synapse_workspace.synapse.name}' >> bigdataintegrationsecrets.txt && echo 'synapseUsername: ${var.sql_admin_username}' >> bigdataintegrationsecrets.txt && echo 'synapsePassword: ${var.sql_admin_password}' >> bigdataintegrationsecrets.txt"
  }
  
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_databricks_workspace.databricks,
    azurerm_synapse_workspace.synapse,
    databricks_token.pat
  ]
}