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
  extension_enabled = try(each.value.extension_enabled, null)

  dynamic "approval_settings" {
    for_each = try(each.value.policy.approval_settings, null) != null ? var.placeholder : {}
    content {
      approval_required_for_extension  = try(each.value.policy.approval_required_for_extension, null)
      approval_required                = try(each.value.policy.approval_required, null)
      requestor_justification_required = try(each.value.policy.requestor_justification_required, null)

      dynamic "approval_stage" {
        for_each = try(each.value.policy.approval_settings.approval_stage, null) != null ? var.placeholder : {}
        content {
          approval_timeout_in_days            = try(each.value.policy.approval_settings.approval_stage.approval_timeout_in_days, null)
          alternative_approval_enabled        = try(each.value.policy.approval_settings.approval_stage.alternative_approval_enabled, null)
          approver_justification_required     = try(each.value.policy.approval_settings.approval_stage.approver_justification_required, null)
          enable_alternative_approval_in_days = try(each.value.policy.approval_settings.approval_stage.enable_alternative_approval_in_days, null)

          dynamic "primary_approver" {
            for_each = try(each.value.policy.approval_settings.approval_stage.primary_approver, null) != null ? var.placeholder : {}
            content {
              backup       = try(each.value.policy.approval_settings.approval_stage.primary_approver.backup, null)
              object_id    = try(each.value.policy.approval_settings.approval_stage.primary_approver.object_id, data.azuread_group.this.id)
              subject_type = each.value.policy.approval_settings.approval_stage.primary_approver.subject_type
            }
          }

          dynamic "alternative_approver" {
            for_each = try(each.value.policy.approval_settings.approval_stage.alternative_approver, null) != null ? var.placeholder : {}
            content {
              backup       = try(each.value.policy.approval_settings.approval_stage.alternative_approver.backup, null)
              object_id    = try(each.value.policy.approval_settings.approval_stage.alternative_approver.object_id, data.azuread_group.this.id)
              subject_type = each.value.policy.approval_settings.approval_stage.alternative_approver.subject_type
            }
          }
        }
      }
    }
  }

  dynamic "assignment_review_settings" {
    for_each = try(each.value.policy.assignment_review_settings, null) != null ? var.placeholder : {}
    content {
      access_recommendation_enabled   = try(each.value.policy.assignment_review_settings.access_recommendation_enabled, null)
      access_review_timeout_behavior  = try(each.value.policy.assignment_review_settings.access_review_timeout_behavior, null)
      approver_justification_required = try(each.value.policy.assignment_review_settings.approver_justification_required, null)
      duration_in_days                = try(each.value.policy.assignment_review_settings.duration_in_days, null)
      enabled                         = try(each.value.policy.assignment_review_settings.enabled, null)
      review_frequency                = try(each.value.policy.assignment_review_settings.review_frequency, null)
      review_type                     = try(each.value.policy.assignment_review_settings.review_type, null)
      starting_on                     = try(each.value.policy.assignment_review_settings.starting_on, null)
      dynamic "reviewer" {
        for_each = try(each.value.policy.assignment_review_settings.reviewer, null) != null ? var.placeholder : {}
        content {
          backup       = try(each.value.policy.assignment_review_settings.reviewer.backup, null)
          object_id    = try(each.value.policy.assignment_review_settings.reviewer.object_id, data.azuread_group.this.id)
          subject_type = each.value.policy.assignment_review_settings.reviewer.subject_type
        }
      }
    }
  }

  dynamic "question" {
    for_each = try(each.value.policy.question, null) != null ? var.placeholder : {}
    content {
      required = try(each.value.policy.question.required, null)
      sequence = try(each.value.policy.question.sequence, null)

      dynamic "choice" {
        for_each = try(each.value.policy.question.choice, null) != null ? var.placeholder : {}
        content {
          actual_value = each.value.policy.question.choice.actual_value
          display_value {
            default_text = each.value.policy.question.choice.display_value.default_text

            dynamic "localized_text" {
              for_each = try(each.value.policy.question.choice.display_value.default_text.localized_text, null) != null ? var.placeholder : {}
              content {
                content       = each.value.policy.question.choice.display_value.default_text.localized_text.content
                language_code = each.value.policy.question.choice.display_value.default_text.localized_text.language_code
              }
            }
          }
        }
      }

      text {
        default_text = each.value.policy.question.text.default_text

        dynamic "localized_text" {
          for_each = try(each.value.policy.question.text.default_text.localized_text, null) != null ? var.placeholder : {}
          content {
            content       = try(each.value.policy.question.text.default_text.localized_text.content, null)
            language_code = try(each.value.policy.question.text.default_text.localized_text.language_code, null)
          }
        }
      }
    }
  }

  dynamic "requestor_settings" {
    for_each = try(each.value.policy.requestor_settings, null) != null ? var.placeholder : {}
    content {
      requests_accepted = try(each.value.policy.requestor_settings.requests_accepted, null)
      scope_type        = try(each.value.policy.requestor_settings.scope_type, null)

      dynamic "requestor" {
        for_each = try(each.value.policy.requestor_settings.requestor, null) != null ? var.placeholder : {}
        content {
          object_id    = try(each.value.policy.requestor_settings.requestor.object_id, data.azuread_group.this.id)
          subject_type = each.value.policy.requestor_settings.requestor.subject_type
        }
      }
    }
  }
}
