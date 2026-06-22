# Production resource group
resource "azurerm_resource_group" "crc_rg_prod" {
  name     = var.resource_group_name
  location = var.location
}

# # Production storage account
# resource "azurerm_storage_account" "crc_storage_prod" {
#   name                     = "${var.unique_prefix}st${var.environment}"
#   resource_group_name      = azurerm_resource_group.crc_rg_prod.name
#   location                 = azurerm_resource_group.crc_rg_prod.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind             = "StorageV2"

#   tags = {
#     environment = var.environment
#     project     = "cloud_resume_challenge"
#   }
# }

# # Enable the static website engine
# resource "azurerm_storage_account_static_website" "crc_static_site_prod" {
#   storage_account_id = azurerm_storage_account.crc_storage_prod.id
#   index_document     = "index.html"
#   error_404_document = "404.html"
# }