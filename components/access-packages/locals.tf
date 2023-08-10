locals {
  catalogs    = yamldecode(file("../../entitlement/catalogs.yml")).catalogs
  packages    = yamldecode(file("../../entitlement/packages.yml")).packages
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
