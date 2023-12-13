moved {
  from = azuread_access_package.package["Databases - Fact Read Access"]
  to = azuread_access_package.package["Database - Fact Read Access"]
}

moved {
  from = azuread_access_package_assignment_policy.this["Database:Databases - Fact Read Access"]
  to = azuread_access_package_assignment_policy.this["Database:Database - Fact Read Access"]
}

moved {
  from = azuread_access_package_resource_package_association.this["Databases - Fact Read Access:Databases:DTS JIT Access fact DB Reader SC"]
  to = azuread_access_package_resource_package_association.this["Database - Fact Read Access:Databases:DTS JIT Access fact DB Reader SC"]
}
