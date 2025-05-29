variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "synapse_workspace_name" {
  description = "Base name of the Synapse workspace"
  type        = string
}

variable "storage_filesystem_id" {
  description = "ID of the Data Lake Gen2 filesystem"
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

variable "allowed_ip_addresses" {
  description = "List of allowed IP addresses for Synapse firewall"
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
}

# Uncomment and configure the following block if you need to assign a role to a user
variable "data_engineer_user_object_id" {
  description = "Object ID of the data engineer user"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix for resource names"
  type        = string
}
