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

resource "azurerm_key_vault_secret" "access_packages_client_secret" {
  key_vault_id = azurerm_key_vault.access_packages_key_vault.id
  name         = "client-secret"
  value        = var.client_secret
}