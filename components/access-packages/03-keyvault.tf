resource "azurerm_key_vault" "access_packages_key_vault" {
  name                            = "access-packages-kv"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.this.name
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  sku_name                        = "standard"
  tags                            = local.common_tags
}