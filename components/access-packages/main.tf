resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}
resource "azuread_access_package_catalog" "catalog" {
  for_each           = { for catalog in local.catalogs : catalog.name => catalog }
  display_name       = each.value.name
  description        = each.value.description
  published          = each.value.published
  externally_visible = each.value.externally_visible
}

resource "azuread_access_package" "package" {
  for_each     = { for package in local.packages : package.name => package }
  display_name = each.value.name
  description  = each.value.description
  catalog_id   = azuread_access_package_catalog.catalog[each.value.catalog_name].id
}

resource "azurerm_key_vault" "access_packages_key_vault" {
  name                            = "access-packages-kv"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  sku_name                        = "standard"
  tags                            = local.common_tags
}