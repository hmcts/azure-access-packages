terraform {
  required_version = ">= 1.14.8"
  backend "azurerm" {}


  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.48.0"
    }
    msgraph = {
      source  = "microsoft/msgraph"
      version = "0.4.0"
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

provider "msgraph" {
  client_id      = var.client_id
  client_secret  = var.client_secret
  tenant_id      = var.tenant_id
  use_cli        = false
  use_msi        = false
  use_oidc       = false
  use_powershell = false
}
