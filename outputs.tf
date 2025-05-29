output "storage_account_name" {
  description = "The name of the Azure Data Lake storage account"
  value       = module.storage.storage_account_name
}

output "storage_account_dfs_endpoint" {
  description = "The primary Data Lake endpoint of the storage account"
  value       = module.storage.storage_account_dfs_endpoint
}

# output "databricks_cluster_id" {
#   description = "The ID of the SalesDataProcessing Databricks cluster"
#   value       = module.databricks.cluster_id
# }
