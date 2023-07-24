# resource "azurerm_resource_group" "this" {
#   name     = var.resource_group_name
#   location = var.location
# }
resource "azuread_access_package_catalog" "catalog" {
  for_each           = { for catalog in local.catalogs : catalog.name => catalog }
  display_name       = each.value.name
  description        = each.value.description
  published          = each.value.published
  externally_visible = each.value.externally_visible
}

