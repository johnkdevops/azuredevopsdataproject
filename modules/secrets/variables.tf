variable "secrets_file_path" {
  description = "Path to store secrets file"
  type        = string
  default     = ""
}

variable "write_secrets_file" {
  description = "Flag to determine whether to write the secrets file"
  type        = bool
  default     = true
}

variable "storage_account_name" {
  description = "Azure Storage account name"
  type        = string
}


variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

# variable "databricks_cluster_id" {
#   description = "Databricks cluster ID"
#   type        = string
# }

variable "databricks_token" {
  type      = string
  sensitive = true
}

variable "databricks_workspace_url" {
  description = "Databricks workspace URL"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "storage_account_dfs_endpoint" {
  description = "DFS endpoint for the storage account"
  type        = string
}

variable "synapse_password" {
  description = "Synapse workspace password"
  type        = string
}

variable "synapse_username" {
  description = "Synapse workspace username"
  type        = string
}

variable "synapse_workspace_name" {
  description = "Synapse workspace name"
  type        = string
}










