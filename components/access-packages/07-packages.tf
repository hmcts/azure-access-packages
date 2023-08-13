# --------------------------------------------------------------------
# Package entries are defined in the entitlement-packages.yml file
# No need to make any updates here for new entries
# --------------------------------------------------------------------

# ------- Packages --------- #
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

# ------------------------ RESOURCES ROLES -------------------------------
# Resources from the catalog that are added to the access package
# Either a Group and Teams, Application or Sharepoint site type resource
# ------------------------------------------------------------------------

resource "azuread_access_package_resource_package_association" "this" {
  for_each = {
    for resource in local.packages_resource_roles : "${resource.name}:${resource.resource_association}" => resource
  }
  access_package_id               = azuread_access_package.package[each.value.name].id
  catalog_resource_association_id = azuread_access_package_resource_catalog_association.this[each.value.resource_association].id
}


# ------------------------ PACKAGE POLICIES -------------------------------
# The policy defined as part of the access package
# -------------------------------------------------------------------------

resource "azuread_access_package_assignment_policy" "this" {
  for_each = {
    for idx, policy in local.package_assignment_policy : format("%02s:%s", idx, policy.access_package) => policy
  }
  access_package_id = azuread_access_package.package[each.value.access_package].id
  display_name      = each.value.policy.display_name
  description       = each.value.policy.description
  duration_in_days  = try(each.value.duration_in_days, null)
  expiration_date   = try(each.value.expiration_date, null)

  dynamic "approval_settings" {
    for_each = try(each.value.policy.approval_settings, null) != null ? var.placeholder : {}
    content {
      approval_required_for_extension = try(each.value.policy.approval_required_for_extension, null)
      approval_required               = try(each.value.policy.approval_required, null)

      dynamic "approval_stage" {
        for_each = try(each.value.policy.approval_settings.approval_stage, null) != null ? var.placeholder : {}
        content {
          approval_timeout_in_days     = try(each.value.policy.approval_settings.approval_stage.approval_timeout_in_days, null)
          alternative_approval_enabled = try(each.value.policy.approval_settings.approval_stage.alternative_approval_enabled, null)

          dynamic "alternative_approver" {
            for_each = try(each.value.policy.approval_settings.approval_stage.alternative_approver, null) != null ? var.placeholder : {}
            content {
              backup       = try(each.value.policy.approval_settings.approval_stage.alternative_approver.backup, null)
              object_id    = try(each.value.policy.approval_settings.approval_stage.alternative_approver.object_id, null)
              subject_type = each.value.policy.approval_settings.approval_stage.alternative_approver.subject_type
            }
          }
        }
      }
      requestor_justification_required = try(each.value.policy.requestor_justification_required, null) # (Optional) Whether a requestor is required to provide a justification to request an access package. Justification is visible to approvers and the requestor.
    }
  }
}