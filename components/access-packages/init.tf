terraform {
  required_version = ">= 1.3.6"
  backend "azurerm" {}


  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.41.0"
    }
  }
}

data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}