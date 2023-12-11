# --------------------------------------------------------------------
# Catalog entries are defined in the entitlement-catalogs.yml file
# No need to make any updates here for new entries
# --------------------------------------------------------------------

# ------- Catalogs --------- #
resource "azuread_access_package_catalog" "catalog" {
  for_each = {
    for catalog in local.catalogs : catalog.name => catalog
  }
  display_name       = each.value.name
  description        = each.value.description
  published          = try(each.value.published, null)
  externally_visible = try(each.value.externally_visible, null)
}

import {
  to = azuread_access_package_resource_catalog_association.this["SC:DTS CFT SC"]
  id = "ea033c19-770d-4492-bc58-d49a229df80e/6029ab89-9151-4566-bea0-b89a6249a6f3"
}

# ------------------------- RESOURCES ------------------------------------
# Resources that are part of a catalog
# Either a Group and Teams, Application or Sharepoint site type resource
# ------------------------------------------------------------------------

data "azuread_group" "resources" {
  for_each = {
    for item in local.catalogs_resources : "${item.catalog_name}:${item.resource}" => item
  }
  display_name     = each.value.resource
  security_enabled = true
}

resource "azuread_access_package_resource_catalog_association" "this" {
  for_each = {
    for item in local.catalogs_resources : "${item.catalog_name}:${item.resource}" => item
  }
  catalog_id             = azuread_access_package_catalog.catalog[each.value.catalog_name].id
  resource_origin_id     = data.azuread_group.resources["${each.value.catalog_name}:${each.value.resource}"].object_id
  resource_origin_system = "AadGroup"
}

# --------------------- ROLES AND ADMINISTRATORS -------------------------
# Principals that have administrator roles on catalogs
# Either a User or a Group (Service Principal not baked in for now)
# ------------------------------------------------------------------------

data "azuread_access_package_catalog_role" "this" {
  display_name = "Catalog owner"
}

data "azuread_group" "this" {
  display_name     = "DTS Platform Operations"
  security_enabled = true
}

# TODO: Revisit
# Could not import to state file and could not delete to recreate
# as there was always an active assignment on these catalogs
# Exempting so pipeline can complete
#variable "difficult_list" {
#  type    = list(string)
#  default = ["General", "SharedServices Subscriptions", "SC", "Databases", "Bastion Servers"]
#}

# ------- Resources roles and administrators: Groups ------- #
resource "azuread_access_package_catalog_role_assignment" "groups" {
  for_each = {
    for catalog in local.catalogs : catalog.name => catalog
    #    if !contains(var.difficult_list, catalog.name)
  }
  role_id             = data.azuread_access_package_catalog_role.this.object_id
  principal_object_id = data.azuread_group.this.object_id
  catalog_id          = azuread_access_package_catalog.catalog[each.value.name].id
}
