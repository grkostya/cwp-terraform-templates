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
    storage_account_name = "stterraformakbpweu001"
    resource_group_name  = "rg-terraform-akbp-weu-001"
    container_name       = "networking"
    key                  = "terraform.tfstate-NETWORKING-SPOKE."
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
  #tenant_id       = local.tenant_id
  #lient_id       = local.terraform_sp_client_id
}
