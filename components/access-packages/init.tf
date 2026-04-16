terraform {
  required_version = ">= 1.14.8"
  backend "azurerm" {}


  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.8.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}
