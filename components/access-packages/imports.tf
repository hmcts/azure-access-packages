moved {
    from = azuread_access_package_assignment_policy.this["SC-No-Question:SecOps Production Bastion Server Access"]
    to = azuread_access_package_assignment_policy.this["self-approval:SecOps Production Bastion Server Access"]
}

moved {
    from = azuread_access_package_assignment_policy.this["SC-No-Question:Strategic Data Platform - Production (PlatOps and PET)"]
    to = azuread_access_package_assignment_policy.this["self-approval:Strategic Data Platform - Production (PlatOps and PET)"]
}

moved {
    from = azuread_access_package_assignment_policy.this["SC-No-Question:Strategic Data Platform - Production (Engineers)"]
    to = azuread_access_package_assignment_policy.this["self-approval:Strategic Data Platform - Production (Engineers)"]
}

moved {
    from = azuread_access_package_assignment_policy.this["SC-Question-25:SharedServices Storage Blob Data Reader (Production)"]
    to = azuread_access_package_assignment_policy.this["self-approval-with-justification:SharedServices Storage Blob Data Reader (Production)"]
}

moved {
    from = azuread_access_package_assignment_policy.this["SC-Question:Non-Production Bastion Server Access"]
    to = azuread_access_package_assignment_policy.this["self-approval:Non-Production Bastion Server Access"]
}

moved {
    from = azuread_access_package_assignment_policy.this["SC-Question-25:SharedServices Subscriptions Non-Production Access (Write)"]
    to = azuread_access_package_assignment_policy.this["self-approval-with-justification:SharedServices Subscriptions Non-Production Access (Write)"]
}

moved {
    from = azuread_access_package_assignment_policy.this["SC:SC Access"]
    to = azuread_access_package_assignment_policy.this["security-clearance-form:SC Access"]
}

moved {
    from = azuread_access_package_assignment_policy.this["SC-Question:Administrative Access - Production Bastion Server"]
    to = azuread_access_package_assignment_policy.this["self-approval-with-justification:Administrative Access - Production Bastion Server"]
}

moved {
    from = azuread_access_package_assignment_policy.this["SC-Question:Administrative Access - Non-Production Bastion Server"]
    to = azuread_access_package_assignment_policy.this["self-approval-with-justification:Administrative Access - Non-Production Bastion Server"]
}
