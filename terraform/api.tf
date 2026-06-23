###################################################
# SUMMARY: Backend resources for Cloud Resume API #
###################################################

# COSMOS DB DATA LAYER

resource "azurerm_cosmosdb_account" "crc_cosmos_prod" {
  name                = "${var.unique_prefix}-cosmos-${var.environment}"
  location            = azurerm_resource_group.crc_rg_prod.location
  resource_group_name = azurerm_resource_group.crc_rg_prod.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  tags                = local.common_tags

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.crc_rg_prod.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "crc_db_prod" {
  name                = "CloudResume" # Matches your target production database name
  resource_group_name = azurerm_resource_group.crc_rg_prod.name
  account_name        = azurerm_cosmosdb_account.crc_cosmos_prod.name
}

resource "azurerm_cosmosdb_sql_container" "crc_container_prod" {
  name                = "Counter" # Matches your target container name
  resource_group_name = azurerm_resource_group.crc_rg_prod.name
  account_name        = azurerm_cosmosdb_account.crc_cosmos_prod.name
  database_name       = azurerm_cosmosdb_sql_database.crc_db_prod.name
  partition_key_paths = ["/id"]
}

# TELEMETRY & LOGGING LAYER

# Create a Log Analytics Workspace (Required for modern App Insights)
resource "azurerm_log_analytics_workspace" "crc_law_prod" {
  name                = "law-${var.unique_prefix}-${var.environment}"
  location            = azurerm_resource_group.crc_rg_prod.location
  resource_group_name = azurerm_resource_group.crc_rg_prod.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

# Create the Application Insights instance
resource "azurerm_application_insights" "crc_appinsights_prod" {
  name                = "appi-${var.unique_prefix}-${var.environment}"
  location            = azurerm_resource_group.crc_rg_prod.location
  resource_group_name = azurerm_resource_group.crc_rg_prod.name
  workspace_id        = azurerm_log_analytics_workspace.crc_law_prod.id
  application_type    = "web"
  tags                = local.common_tags
}

# 2. SERVERLESS COMPUTE LAYER (FUNCTION APP)

# Create the serverless Consumption plan (Y1 SKU)
resource "azurerm_service_plan" "crc_asp_prod" {
  name                = "${var.unique_prefix}-asp-${var.environment}"
  location            = azurerm_resource_group.crc_rg_prod.location
  resource_group_name = azurerm_resource_group.crc_rg_prod.name
  os_type             = "Windows"
  sku_name            = "Y1"
  tags                = local.common_tags
}

# Create the Windows Function App for PowerShell
resource "azurerm_windows_function_app" "crc_function_prod" {
  name                = "func-${var.unique_prefix}-${var.environment}"
  location            = azurerm_resource_group.crc_rg_prod.location
  resource_group_name = azurerm_resource_group.crc_rg_prod.name

  storage_account_name       = azurerm_storage_account.crc_storage_prod.name
  storage_account_access_key = azurerm_storage_account.crc_storage_prod.primary_access_key
  service_plan_id            = azurerm_service_plan.crc_asp_prod.id

  https_only = true # Force secure traffic
  tags       = local.common_tags

  site_config {
    application_stack {
      powershell_core_version = "7.4"
    }

    # Enable Application Insights
    application_insights_connection_string = azurerm_application_insights.crc_appinsights_prod.connection_string
    application_insights_key               = azurerm_application_insights.crc_appinsights_prod.instrumentation_key

    # Configure security whitelists for site orgins (to fix CORS errors)
    cors {
      allowed_origins = [
        trimsuffix(azurerm_storage_account.crc_storage_prod.primary_web_endpoint, "/"),
        "https://bradtoulson.com",
        "https://portal.azure.com"
      ]
    }
  }

  # Inject the connection string directly into application settings
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "powershell"
    "CosmosDBConnectionString" = azurerm_cosmosdb_account.crc_cosmos_prod.primary_sql_connection_string
  }
}