terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.56.0"  # or whichever version you're using
    }
  }
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = var.databricks_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "trial"

  lifecycle {
    ignore_changes = [tags, managed_resource_group_name]
  }
}

resource "time_sleep" "wait_for_databricks" {
  create_duration = "180s"
  depends_on      = [azurerm_databricks_workspace.databricks]
}

# resource "databricks_cluster" "sales_processing" {
#   cluster_name            = var.databricks_cluster_name
#   spark_version           = "14.3.x-scala2.12"
#   node_type_id            = "Standard_DS3_v2"
#   num_workers             = 1
#   autotermination_minutes = 15
#   spark_conf = {
#     "spark.databricks.cluster.profile" = "singleNode"
#   }
#   custom_tags = {
#     "ResourceClass" = "SingleNode"
#   }
#   single_user_name = var.current_user_principal_name

#   depends_on = [azurerm_databricks_workspace.databricks, time_sleep.wait_for_databricks, databricks_token.pat]
# }

# Uncomment and configure the following block if you need to assign a role to a user
resource "azurerm_role_assignment" "databricks_contributor" {
  scope                = azurerm_databricks_workspace.databricks.id
  role_definition_name = "Contributor"
  principal_id         = var.data_engineer_user_object_id
}

resource "databricks_token" "pat" {
  comment          = "Terraform-generated PAT for Azure Pipeline"
  lifetime_seconds = 7776000
  depends_on       = [azurerm_databricks_workspace.databricks, time_sleep.wait_for_databricks]
}
