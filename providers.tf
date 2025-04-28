terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.56.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.1"
    }
  }
}

provider "azurerm" {
  features {}
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# provider "databricks" {
#   host     = azurerm_databricks_workspace.databricks.workspace_url
#   token    = var.databricks_auth_token
# Alternatively, for service principal authentication:
# azure_client_id     = var.azure_client_id
# azure_client_secret = var.azure_client_secret
# azure_tenant_id     = var.tenant_id
# }