# Optional: Add outputs if you want to confirm completion or expose paths
output "debug_token" {
  value = var.databricks_token
  sensitive = true
}
