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

# ------------------------- RESOURCES ------------------------------------
# Resources that are part of a catalog
# Either a Group and Teams, Application or Sharepoint site type resource
# ------------------------------------------------------------------------

data "azuread_group" "resources" {
  for_each = {
    for item in local.catalogs_resources : "${item.catalog_name}:${item.resource.display_name}" => item
  }
  display_name     = each.value.resource.display_name
  security_enabled = try(each.value.security_enabled, null)
}

resource "azuread_access_package_resource_catalog_association" "this" {
  for_each = {
    for item in local.catalogs_resources : "${item.catalog_name}:${item.resource.display_name}" => item
  }
  catalog_id             = azuread_access_package_catalog.catalog[each.value.catalog_name].id
  resource_origin_id     = data.azuread_group.resources["${each.value.catalog_name}:${each.value.resource.display_name}"].object_id
  resource_origin_system = each.value.resource.resource_origin_system
}

# --------------------- ROLES AND ADMINISTRATORS -------------------------
# Principals that have administrator roles on catalogs
# Either a User or a Group (Service Principal not baked in for now)
# ------------------------------------------------------------------------

# ------- Owner types ------- #
data "azuread_access_package_catalog_role" "this" {
  for_each     = toset(["Catalog owner", "Catalog creator"])
  display_name = each.key
}

# ------- user_principal_name must be specified ------- #
data "azuread_user" "this" {
  for_each = {
    for item in local.catalog_role_assignment_users : "${item.catalog_name}:${item.assignee}" => item
  }

  user_principal_name = each.value.user.user_principal_name
  object_id           = try(each.value.user.object_id, null)
  employee_id         = try(each.value.user.employee_id, null)
  mail                = try(each.value.user.mail, null)
  mail_nickname       = try(each.value.user.mail_nickname, null)
}

# ------- Resources roles and administrators: Users ------- #
resource "azuread_access_package_catalog_role_assignment" "users" {
  for_each = {
    for item in local.catalog_role_assignment_users : "${item.catalog_name}:${item.assignee}" => item
  }
  role_id             = data.azuread_access_package_catalog_role.this[each.value.user.catalog_role].object_id
  principal_object_id = data.azuread_user.this["${each.value.catalog_name}:${each.value.assignee}"].object_id
  catalog_id          = azuread_access_package_catalog.catalog[each.value.catalog_name].id
}

# ------- display_name must be specified ------- #
data "azuread_group" "this" {
  for_each = {
    for group in local.catalog_role_assignment_groups : "${group.catalog_name}:${group.group.display_name}" => group
  }
  display_name     = each.value.group.display_name
  mail_enabled     = try(each.value.group.mail_enabled, null)
  object_id        = try(each.value.group.object_id, null)
  security_enabled = try(each.value.group.security_enabled, null)
}

# ------- Resources roles and administrators: Groups ------- #
resource "azuread_access_package_catalog_role_assignment" "groups" {
  for_each = {
    for item in local.catalog_role_assignment_groups : "${item.catalog_name}:${item.group.display_name}" => item
  }
  role_id             = data.azuread_access_package_catalog_role.this[each.value.group.catalog_role].object_id
  principal_object_id = data.azuread_group.this["${each.value.catalog_name}:${each.value.group.display_name}"].object_id
  catalog_id          = azuread_access_package_catalog.catalog[each.value.catalog_name].id
}
