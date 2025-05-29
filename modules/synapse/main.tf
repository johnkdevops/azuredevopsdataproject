resource "azurerm_synapse_workspace" "synapse" {
  name                                 = "${var.synapse_workspace_name}-${var.random_suffix}"
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.storage_filesystem_id
  sql_administrator_login              = var.sql_admin_username
  sql_administrator_login_password     = var.sql_admin_password

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_synapse_firewall_rule" "ip_rules" {
  for_each = { for ip in var.allowed_ip_addresses : ip.name => ip }

  name                 = each.value.name
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  start_ip_address     = each.value.start_ip_address
  end_ip_address       = each.value.end_ip_address
}

# Uncomment and configure the following block if you need to assign a role to a user
resource "azurerm_role_assignment" "synapse_contributor" {
  scope                = azurerm_synapse_workspace.synapse.id
  role_definition_name = "Contributor"
  principal_id         = var.data_engineer_user_object_id
}
