data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

/*
 * Catalog entries are defined in the entitlement/01-catalogs.tf file
 * No need to make any updates here for new entries
 */
resource "azuread_access_package_catalog" "catalog" {
  for_each = {
    for catalog in local.catalogs : catalog.name => catalog
  }
  display_name       = each.value.name
  description        = each.value.description
  published          = try(each.value.published, null)
  externally_visible = try(each.value.externally_visible, null)
}


/*
 * Package entries are defined in the entitlement/02-packages.tf file
 * No need to make any updates here for new entries
 */
resource "azuread_access_package" "package" {
  for_each = {
    for package in local.packages : package.name => package
  }
  display_name = each.value.name
  description  = each.value.description
  catalog_id   = azuread_access_package_catalog.catalog[each.value.catalog_name].id
  hidden       = try(each.value.hidden, null)
  depends_on = [
    azuread_access_package_catalog.catalog
  ]
}
