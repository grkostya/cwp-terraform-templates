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
  backend "azurerm" {} 
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
  subscription_id = var.subscription_id
}