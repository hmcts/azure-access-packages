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
  default   = ""
}

variable "client_id" {
  sensitive = true
  default   = ""
}

variable "client_secret" {
  sensitive = true
  default   = ""
}

# this are not used anywhere but its needed by CNP devops library
variable "env" {
  type = string
}

variable "builtFrom" {
  type = string
}

variable "product" {
  type = string
}

variable "subscription_id" {
  description = "subscription id"
  type        = string
}

variable "expiresAfter" {
  description = "Date when resources can be deleted. Format: YYYY-MM-DD"
  default     = "3000-01-01"
}