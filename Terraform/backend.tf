# store state in Azure blob container
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cloudresume-state"
    storage_account_name = "cloudresumebtstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}