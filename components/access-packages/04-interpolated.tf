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

  # Get the resource added to the package from the catalog resource list
  packages_resource_roles = flatten([
    for package in local.packages : [
      for catalog in local.catalogs : [
        for resource in try(catalog.resources, []) : {
          name                 = package.name
          resource_association = "${catalog.name}:${resource}"
        } if contains(try(package.resource_roles, []), resource)
      ] if package.catalog_name == catalog.name
    ]
  ])

  package_policies = flatten([
    for policy_file in fileset(path.module, "../../package-policies/*.yml") : [
      yamldecode(file(policy_file))
    ]
  ])

  package_assignment_policy = flatten([
    for package_policy in local.package_policies : [
      for policy in try(package_policy.policies, []) : {
        access_package = package_policy.access_package
        policy         = policy
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
