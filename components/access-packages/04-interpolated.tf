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
    for package in local.packages : [
      for package_policy in local.package_policies : {
        access_package   = package.name
        policy_name      = package_policy.name
        policy           = package_policy.policy
        requestor_groups = try(package.requestor_groups, null)
        approver_groups  = try(package.approver_groups, null)
      } if contains(package.policies, package_policy.name)
    ] if try(package.policies, null) != null
  ])

  policy_requestor_groups = [
    for group in flatten([for item in local.package_assignment_policy : item.requestor_groups]) : group
    if group != null
  ]

  policy_approver_groups = [
    for group in flatten([for item in local.package_assignment_policy : item.approver_groups]) : group
    if group != null
  ]

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
