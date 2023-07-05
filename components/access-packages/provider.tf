terraform {
  required_version = ">= 1.5.0"
  backend "azurerm" {}


  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.39.0"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}
