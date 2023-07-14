terraform {
  required_version = ">= 1.3.6"
  backend "azurerm" {}


  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.39.0"
    }
  }
}

provider "azurerm" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id

  features {}
}

provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}