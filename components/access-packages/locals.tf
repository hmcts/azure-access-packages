locals {
  catalogs = [
    {
      name                = "Test Data Platform"
      description         = "Test Data Platform"
      published           = true
      externally_visible  = false
      resource_group_name = azurerm_resource_group.this.name
    },
    {
     name                = "Test Storage Blob Data Reader"
     description         = "Test Storage Blob Data Reader Production Access"
     published           = true
     externally_visible  = false
     resource_group_name = azurerm_resource_group.this.name
    },
    # Add more catalogs as needed
  ]
}


