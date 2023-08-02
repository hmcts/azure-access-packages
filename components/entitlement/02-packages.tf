locals {
  packages = [
    {
      name         = "Test MI Data Platform"
      description  = "Test MI Data Platform"
      catalog_name = "Test Data Platform"
    },
    {
      name         = "Test SharedServices Storage Blob Data Reader"
      description  = "Test SharedServices  Blob Data Reader Production Access"
      catalog_name = "Test Storage Blob Data Reader"
    },
    # Add more packages as needed
  ]
}