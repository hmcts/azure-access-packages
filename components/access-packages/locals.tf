locals {
  catalogs = [
    {
      name               = "Test Data Platform"
      description        = "Test Data Platform"
      published          = true
      externally_visible = false
    },
    {
      name               = "Test Storage Blob Data Reader"
      description        = "Test Storage Blob Data Reader Production Access"
      published          = true
      externally_visible = false
    },
    # Add more catalogs as needed
  ]
  common_tags = module.ctags.common_tags

  packages = [
    {
      name          = "Test MI Data Platform"
      description   = "Test MI Data Platform"
      catalog_name  = "Test Data Platform"
    },
    {
      name          = "Test SharedServices Storage Blob Data Reader"
      description   = "Test SharedServices  Blob Data Reader Production Access"
      catalog_name  = "Test Storage Blob Data Reader"
    },
    # Add more packages as needed
  ]
}


# Common tags
module "ctags" {
  source       = "github.com/hmcts/terraform-module-common-tags"
  builtFrom    = var.builtFrom
  environment  = var.env
  product      = var.product
  expiresAfter = var.expiresAfter
}
