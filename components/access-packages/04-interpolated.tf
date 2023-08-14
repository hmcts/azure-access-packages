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
