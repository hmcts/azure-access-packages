locals {
  catalogs = yamldecode(file("../../entitlement-catalogs.yml")).catalogs
  packages = yamldecode(file("../../entitlement-packages.yml")).packages

  catalogs_resources = flatten([
    for catalog in local.catalogs : [
      for resource in try(catalog.resources, []) : {
        catalog_name = catalog.name
        resource     = resource
      }
    ]
  ])

  # If catalog has users defined
  catalog_role_assignment_users = flatten([
    for catalog in local.catalogs : [
      for user in try(catalog.roles.users, []) : {
        catalog_name = catalog.name
        user         = user
        assignee = join(".", [
          split(".", split("@", user.user_principal_name)[0])[0],
          substr((split(".", split("@", user.user_principal_name)[0])[1]), 0, 1)
        ])
        # Just dont want emails being logged in statefile
        # "firstname.lastname@justice.gov.uk" becomes firstname.l
      }
    ]
  ])

  # If catalog has groups defined
  catalog_role_assignment_groups = flatten([
    for catalog in local.catalogs : [
      for group in try(catalog.roles.groups, []) : {
        catalog_name = catalog.name
        group        = group
      }
    ]
  ])

  common_tags = module.ctags.common_tags
}

# Common tags
module "ctags" {
  source       = "github.com/hmcts/terraform-module-common-tags"
  builtFrom    = var.builtFrom
  environment  = var.env
  product      = var.product
  expiresAfter = var.expiresAfter
}
