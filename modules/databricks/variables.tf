variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"  # Change this to your preferred region
}

variable "databricks_workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

# variable "databricks_cluster_name" {
#   description = "Name of the Databricks cluster"
#   type        = string
# }

variable "data_engineer_user_object_id" {
  description = "Object ID of the data engineer user"
  type        = string
}

variable "current_user_principal_name" {
  description = "Principal name of the current user for cluster access"
  type        = string
}


