resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "filesystem" {
  name               = var.filesystem_name
  storage_account_id = azurerm_storage_account.storage.id
}

# resource "azurerm_role_assignment" "storage_blob_contributor" {
#   scope                = azurerm_storage_account.storage.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = var.current_user_object_id
# }

resource "azurerm_role_assignment" "databricks_storage_access" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.current_user_object_id
}
