terraform {
  required_version = ">= 1.5.0"
  backend "azurerm" {}
  
}

provider "azurerm" {
  features {}
}
