variable "resource_group_name" {
  description = "name of the resource group"
  default     = "access-packages-rg"
}

variable "location" {
  description = "location of the resource"
  default     = "uksouth"
}

# variable "tenant_id" {
#   sensitive = true
# }

# variable "client_id" {
#   sensitive = true
# }

# variable "client_secret" {
#   sensitive = true
# }

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