output "workspace_url" {
  description = "URL of the Databricks workspace"
  value       = azurerm_databricks_workspace.databricks.workspace_url
}

# output "cluster_id" {
#   description = "ID of the Databrick cluster"
#   value       = databricks_cluster.sales_processing.cluster_id
# }

output "pat_token" {
  description = "Databricks PAT token"
  value       = databricks_token.pat.token_value
  sensitive   = true
}
