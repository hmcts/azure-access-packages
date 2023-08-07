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
}