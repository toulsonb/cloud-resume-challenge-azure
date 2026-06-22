# output "static_website_url" {
#   value       = azurerm_storage_account.crc_storage_prod.primary_web_endpoint
#   description = "The public endpoint URL for your production static frontend website."
# }

# output "function_app_backend_url" {
#   value       = "https://${azurerm_windows_function_app.crc_function_prod.default_hostname}/api"
#   description = "The base URL for your serverless PowerShell API endpoints."
# }

# output "cosmosdb_endpoint" {
#   value       = azurerm_cosmosdb_account.crc_cosmos_prod.endpoint
#   description = "The connection endpoint for your Cosmos DB instance."
# }