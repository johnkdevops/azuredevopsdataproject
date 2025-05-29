# Configure providers
provider "azuread" {}

provider "databricks" {
  host = module.databricks.workspace_url
  # token = module.databricks.pat_token
}

# Random string for unique names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Current user and client config
data "azurerm_client_config" "current" {}

data "azuread_user" "current" {
  object_id = data.azurerm_client_config.current.object_id
}

# Resource Group module
module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Storage module
module "storage" {
  source                 = "./modules/storage"
  resource_group_name    = module.resource_group.name
  location               = var.location
  storage_account_name   = "datastorage${random_string.suffix.result}"
  filesystem_name        = "filestorage${random_string.suffix.result}"
  current_user_object_id = data.azurerm_client_config.current.object_id
}

# Databricks module
module "databricks" {
  source                       = "./modules/databricks"
  resource_group_name          = module.resource_group.name
  location                     = var.location
  databricks_workspace_name    = var.databricks_workspace_name
  data_engineer_user_object_id = var.data_engineer_user_object_id
  current_user_principal_name  = data.azuread_user.current.user_principal_name
}

# Synapse module
module "synapse" {
  source                       = "./modules/synapse"
  resource_group_name          = module.resource_group.name
  location                     = var.location
  synapse_workspace_name       = var.synapse_workspace_name
  storage_filesystem_id        = module.storage.filesystem_id
  sql_admin_username           = var.sql_admin_username
  sql_admin_password           = var.sql_admin_password
  allowed_ip_addresses         = var.allowed_ip_addresses
  data_engineer_user_object_id = var.data_engineer_user_object_id
  random_suffix                = random_string.suffix.result
}

# Secrets module
module "secrets" {
  source                       = "./modules/secrets"
  secrets_file_path            = var.secrets_file_path
  subscription_id              = var.subscription_id
  databricks_token             = module.databricks.pat_token
  databricks_workspace_url     = module.databricks.workspace_url
  resource_group_name          = var.resource_group_name
  synapse_workspace_name       = module.synapse.workspace_name
  synapse_username             = var.sql_admin_username
  synapse_password             = var.sql_admin_password
  storage_account_name         = module.storage.storage_account_name
  storage_account_dfs_endpoint = module.storage.storage_account_dfs_endpoint
  depends_on = [
    module.resource_group,
    module.storage,
    module.databricks,
    module.synapse
  ]
}