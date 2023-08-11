/*
 * Package entries are defined in the entitlement-packages.yml file
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
