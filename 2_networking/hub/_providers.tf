terraform {
  required_version = ">= 1.9.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.66.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.13.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "stcwpmigakbpdevweu001"
    resource_group_name  = "rg-cwp-migration-akbp-dev-weu-001"
    container_name       = "networking"
    key                  = "terraform.tfstate-NETWORKING-HUB."
    use_azuread_auth     = true
  }
}


provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
  subscription_id = local.subscription_id
}
