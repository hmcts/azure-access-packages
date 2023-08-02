locals {
  catalogs    = module.entitlements.catalogs
  packages    = module.entitlements.packages
  common_tags = module.ctags.common_tags
}

module "entitlements" {
  source = "../entitlement"
}

# Common tags
module "ctags" {
  source       = "github.com/hmcts/terraform-module-common-tags"
  builtFrom    = var.builtFrom
  environment  = var.env
  product      = var.product
  expiresAfter = var.expiresAfter
}
