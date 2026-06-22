# ###################################################
# # SUMMARY: Backend resources for Cloud Resume API #
# ###################################################

# # COSMOS DB DATA LAYER

# resource "azurerm_cosmosdb_account" "crc_cosmos_prod" {
#   name                = "${var.unique_prefix}-cosmos-${var.environment}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   offer_type          = "Standard"
#   kind                = "GlobalDocumentDB"

#   consistency_policy {
#     consistency_level = "Session"
#   }

#   geo_location {
#     location          = azurerm_resource_group.rg.location
#     failover_priority = 0
#   }
# }

# resource "azurerm_cosmosdb_sql_database" "crc_db_prod" {
#   name                = "CloudResume" # Matches your target production database name
#   resource_group_name = azurerm_resource_group.rg.name
#   account_name        = azurerm_cosmosdb_account.crc_cosmos_prod.name
# }

# resource "azurerm_cosmosdb_sql_container" "crc_container_prod" {
#   name                = "Counter" # Matches your target container name
#   resource_group_name = azurerm_resource_group.rg.name
#   account_name        = azurerm_cosmosdb_account.crc_cosmos_prod.name
#   database_name       = azurerm_cosmosdb_sql_database.crc_db_prod.name
#   partition_key_paths = ["/id"]
# }


# # 2. SERVERLESS COMPUTE LAYER (FUNCTION APP)

# # Create the serverless Consumption plan (Y1 SKU)
# resource "azurerm_service_plan" "crc_asp_prod" {
#   name                = "${var.unique_prefix}-asp-${var.environment}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   os_type             = "Windows"
#   sku_name            = "Y1"
# }

# # Create the Windows Function App for PowerShell
# resource "azurerm_windows_function_app" "crc_function_prod" {
#   name                = "func-${var.unique_prefix}-${var.environment}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   storage_account_name       = azurerm_storage_account.storage.name
#   storage_account_access_key = azurerm_storage_account.storage.primary_access_key
#   service_plan_id            = azurerm_service_plan.crc_asp_prod.id

#   site_config {
#     application_stack {
#       powershell_core_version = "7.4"
#     }

#     # Configure security whitelists for site orgins (to fix CORS errors)
#     cors {
#       allowed_origins = [
#         "https://bradtoulson.com",
#         "https://${azurerm_storage_account.storage.name}.z13.web.core.windows.net"
#       ]
#     }
#   }

#   # Inject the connection string directly into application settings
#   app_settings = {
#     "FUNCTIONS_WORKER_RUNTIME" = "powershell"
#     "CosmosDBConnectionString" = azurerm_cosmosdb_account.crc_cosmos_prod.primary_connection_string
#   }
# }