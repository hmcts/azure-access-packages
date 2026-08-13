# --------------------------------------------------------------------
# Package entries are defined in the entitlement-packages.yml file
# No need to make any updates here for new entries
# --------------------------------------------------------------------


# All declared Requestor AD group object ids
data "azuread_group" "requestors" {
  for_each         = toset(local.policy_requestor_groups)
  display_name     = each.value
  security_enabled = true
}

# All declared Approvers AD group  object ids
data "azuread_group" "approvers" {
  for_each         = toset(concat(local.policy_approver_groups, [var.default_approver]))
  display_name     = each.value
  security_enabled = true
}

# All declared Alternative approvers AD group  object ids
data "azuread_group" "alternative_approvers" {
  for_each         = toset(local.policy_alternative_approver_groups)
  display_name     = each.value
  security_enabled = true
}

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
    for idx, policy in local.package_assignment_policy : format("%s:%s", policy.policy_name, policy.access_package) => policy
    if try(policy.policy.expiration.duration, null) == null
  }
  access_package_id = azuread_access_package.package[each.value.access_package].id
  display_name      = each.value.policy.display_name
  description       = each.value.policy.description
  duration_in_days  = try(each.value.policy.duration_in_days, null)
  expiration_date   = try(each.value.policy.expiration_date, null)
  extension_enabled = try(each.value.policy.extension_enabled, null)

  approval_settings {
    approval_required_for_extension  = try(each.value.policy.approval_settings.approval_required_for_extension, null)
    approval_required                = try(each.value.policy.approval_settings.approval_required, null)
    requestor_justification_required = try(each.value.policy.approval_settings.requestor_justification_required, null)

    dynamic "approval_stage" {
      for_each = try(each.value.policy.approval_settings.approval_required, null) == true ? var.placeholder : {}
      content {
        approval_timeout_in_days            = try(each.value.policy.approval_settings.approval_stage.approval_timeout_in_days, 3)
        alternative_approval_enabled        = try(each.value.policy.approval_settings.approval_stage.alternative_approval_enabled, null)
        approver_justification_required     = try(each.value.policy.approval_settings.approval_stage.approver_justification_required, null)
        enable_alternative_approval_in_days = try(each.value.policy.approval_settings.approval_stage.enable_alternative_approval_in_days, null)

        dynamic "primary_approver" {
          # change [] to  [var.default_approver] to make Platform operations group the default approver desired
          for_each = each.value.approver_groups
          content {
            object_id = data.azuread_group.approvers[primary_approver.value].id
            #            backup       = try(each.value.policy.approval_settings.approval_stage.primary_approver.backup, null)
            subject_type = each.value.policy.approval_settings.approval_stage.primary_approver.subject_type
          }
        }

        dynamic "alternative_approver" {
          for_each = try(each.value.alternative_approver_groups, null) != null ? each.value.alternative_approver_groups : []
          content {
            object_id    = try(data.azuread_group.alternative_approvers[alternative_approver.value].id, null)
            backup       = try(each.value.policy.approval_settings.approval_stage.alternative_approver.backup, null)
            subject_type = try(each.value.policy.approval_settings.approval_stage.alternative_approver.subject_type, "groupMembers")
          }
        }
      }
    }
  }

  dynamic "question" {
    for_each = try(each.value.policy.questions, [])
    content {
      required = try(question.value.required, null)
      sequence = try(question.value.sequence, null)

      dynamic "choice" {
        for_each = try(question.value.choice, null) != null ? var.placeholder : {}
        content {
          actual_value = try(choice.value.actual_value, null)
          display_value {
            default_text = try(choice.value.display_value.default_text, null)

            dynamic "localized_text" {
              for_each = try(choice.value.display_value.default_text.localized_text, null) != null ? var.placeholder : {}
              content {
                content       = try(localized_text.value.content, null)
                language_code = try(localized_text.value.language_code, null)
              }
            }
          }
        }
      }

      text {
        default_text = try(question.value.text.default_text, "")

        dynamic "localized_text" {
          for_each = try(question.value.text.default_text.localized_text, null) != null ? var.placeholder : {}
          content {
            content       = try(localized_text.value.content, null)
            language_code = try(localized_text.value.language_code, null)
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
        for_each = try(each.value.requestor_groups, null) != null ? each.value.requestor_groups : []
        content {
          object_id    = data.azuread_group.requestors[requestor.value].id
          subject_type = each.value.policy.requestor_settings.requestor.subject_type
        }
      }
    }
  }
}

resource "msgraph_resource" "access_package_assignment_policy" {
  for_each = {
    for idx, policy in local.package_assignment_policy : format("%s:%s", policy.policy_name, policy.access_package) => policy
    if try(policy.policy.expiration.duration, null) != null
  }

  url           = "identityGovernance/entitlementManagement/accessPackageAssignmentPolicies"
  api_version   = "beta"
  update_method = "PUT"

  body = {
    accessPackageId = azuread_access_package.package[each.value.access_package].id
    displayName     = each.value.policy.display_name
    description     = each.value.policy.description
    canExtend       = try(each.value.policy.extension_enabled, false)
    expiration = {
      duration = each.value.policy.expiration.duration
      type     = each.value.policy.expiration.type
    }
    requestorSettings = {
      scopeType      = "SpecificDirectorySubjects"
      acceptRequests = true
      allowedRequestors = [
        for requestor in try(each.value.requestor_groups, []) : {
          "@odata.type" = "#microsoft.graph.groupMembers"
          id            = data.azuread_group.requestors[requestor].id
          isBackup      = false
        }
      ]
    }
    requestApprovalSettings = {
      isApprovalRequired               = try(each.value.policy.approval_settings.approval_required, false)
      isApprovalRequiredForExtension   = try(each.value.policy.approval_settings.approval_required_for_extension, false)
      isRequestorJustificationRequired = try(each.value.policy.approval_settings.requestor_justification_required, false)
      approvalMode                     = try(each.value.policy.approval_settings.approval_required, false) ? "SingleStage" : "NoApproval"
      approvalStages = try(each.value.policy.approval_settings.approval_required, false) ? [
        {
          approvalStageTimeOutInDays      = try(each.value.policy.approval_settings.approval_stage.approval_timeout_in_days, 1)
          isApproverJustificationRequired = try(each.value.policy.approval_settings.approval_stage.approver_justification_required, false)
          isEscalationEnabled             = try(each.value.policy.approval_settings.approval_stage.alternative_approval_enabled, false)
          primaryApprovers = [
            for approver in try(each.value.approver_groups, []) : {
              "@odata.type" = "#microsoft.graph.groupMembers"
              id            = data.azuread_group.approvers[approver].id
              isBackup      = false
            }
          ]
          fallbackPrimaryApprovers    = []
          escalationApprovers         = []
          fallbackEscalationApprovers = []
        }
      ] : []
    }
    questions = [
      for question in try(each.value.policy.questions, []) : {
        "@odata.type"    = "#microsoft.graph.accessPackageTextInputQuestion"
        isRequired       = try(question.required, false)
        isAnswerEditable = true
        sequence         = try(question.sequence, null)
        text = {
          defaultText = try(question.text.default_text, "")
        }
      }
    ]
  }
}
