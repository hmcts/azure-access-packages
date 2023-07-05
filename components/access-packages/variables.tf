variable "resource_group_name" {
  description = "name of the resource group"
  default     = "access-packages-rg"
}

variable "location" {
  description = "location of the resource"
  default     = "uksouth"
}

variable "tenant_id" {
  sensitive = true
}

variable "client_id" {
  sensitive = true
}

variable "client_secret" {
  sensitive = true
}