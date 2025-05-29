resource "null_resource" "write_secrets_file" {
  count = var.write_secrets_file ? 1 : 0
  triggers = {
    always_run = "${timestamp()}"  # Ensures it runs on every apply
  }

  provisioner "local-exec" {
    command = "cd ${var.secrets_file_path} && echo 'Variable group: bigdataintegrationsecrets' > bigdataintegrationsecrets.txt && echo '' >> bigdataintegrationsecrets.txt && echo 'accountStorageName: ${var.storage_account_name}' >> bigdataintegrationsecrets.txt && echo 'azureSubscription: ${var.subscription_id}' >> bigdataintegrationsecrets.txt && echo 'databricksToken: ${var.databricks_token}' >> bigdataintegrationsecrets.txt && echo 'databricksWorkspaceUrl: ${var.databricks_workspace_url}' >> bigdataintegrationsecrets.txt && echo 'resourceGroupName: ${var.resource_group_name}' >> bigdataintegrationsecrets.txt && echo 'storageAccountDfsEndpoint: ${var.storage_account_dfs_endpoint}' >> bigdataintegrationsecrets.txt && echo 'synapsePassword: ${var.synapse_password}' >> bigdataintegrationsecrets.txt && echo 'synapseUsername: ${var.synapse_username}' >> bigdataintegrationsecrets.txt echo 'synapseWorkspaceName: ${var.synapse_workspace_name}' >> bigdataintegrationsecrets.txt"
  }
}


