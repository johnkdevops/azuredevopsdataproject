variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "filesystem_name" {
  description = "Name of the Data Lake Gen2 filesystem"
  type        = string
}

variable "current_user_object_id" {
  description = "Object ID of the current user"
  type        = string
}
