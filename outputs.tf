output "databricks_workspace_url" {
  description = "URL of the Databricks workspace"
  value       = azurerm_databricks_workspace.databricks.workspace_url
}

output "synapse_workspace_name" {
  description = "Name of the Synapse workspace"
  value       = azurerm_synapse_workspace.synapse.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.storage.name
}

output "filesystem_name" {
  description = "Name of the file system"
  value       = azurerm_storage_data_lake_gen2_filesystem.filesystem.name
}

output "databricks_pipeline_token" {
  description = "Databricks PAT for Azure Pipelines"
  value       = databricks_token.pat.token_value
  sensitive   = true
}