variable "location" {
  description = "Azure region for resources"
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "DataPipelineRG"
}

variable "databricks_workspace_name" {
  description = "Name of the Databricks workspace"
  default     = "data-pipeline-db"
}

variable "synapse_workspace_name" {
  description = "Base name for Synapse workspace"
  default     = "data-pipeline-synapse"
}

variable "current_user_object_id" {
  description = "Object ID of the Current User"
  type        = string
}

variable "data_engineer_user_object_id" {
  description = "Object ID of the Data Engineer User"
  type        = string
}

variable "sql_admin_username" {
  description = "SQL Admin username for Synapse"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Admin password for Synapse"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

# variable "databricks_auth_token" {
#   description = "Databricks PAT for authentication for Azure Pipelines"
#   type        = string
#   sensitive   = true
# }