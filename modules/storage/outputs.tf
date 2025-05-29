output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.storage.name
}

output "storage_account_dfs_endpoint" {
  description = "Primary DFS endpoint of the storage account"
  value       = azurerm_storage_account.storage.primary_dfs_endpoint
}

output "filesystem_id" {
  description = "ID of the Data Lake Gen2 filesystem"
  value       = azurerm_storage_data_lake_gen2_filesystem.filesystem.id
}