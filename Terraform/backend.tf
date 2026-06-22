terraform {
  required_version = ">= 1.3.0"

  # store state in Azure blob container
  backend "azurerm" {
    resource_group_name  = "rg-cloudresume-state"
    storage_account_name = "cloudresumebtstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" 
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_subscription" "current" {}