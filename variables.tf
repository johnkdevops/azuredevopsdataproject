variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "databricks_workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

# variable "databricks_cluster_name" {
#   description = "Name of the Databricks cluster"
#   type        = string
# }

variable "databricks_token" {
  description = "Databricks personal access token for secrets module"
  type        = string
  default     = ""
}

variable "synapse_workspace_name" {
  description = "Base name of the Synapse workspace"
  type        = string
}

variable "sql_admin_username" {
  description = "Synapse SQL admin username"
  type        = string
}

variable "sql_admin_password" {
  description = "Synapse SQL admin password"
  type        = string
  sensitive   = true
}

variable "data_engineer_user_object_id" {
  description = "Object ID of the data engineer user for role assignments"
  type        = string
}

variable "data_engineer_user_principal_name" {
  description = "Principal name of the data engineer user for role assignments"
  type        = string
}

variable "current_user_object_id" {
  description = "Object ID of the current user for role assignments"
  type        = string
}

variable "current_user_principal_name" {
  description = "Principal name of the current user for role assignments"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "allowed_ip_addresses" {
  description = "List of allowed IP addresses for Synapse firewall"
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
}


variable "secrets_file_path" {
  description = "Path to the folder where bigdataintegrationsecrets.txt will be saved"
  type        = string
}