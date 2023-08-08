#-----------------------------------------------------------
# Catalog entries
#-----------------------------------------------------------

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

    {
      name               = "Demo"
      description        = "Demonstration Packages (internal use only)"
      published          = true
      externally_visible = false
    },

    {
      name               = "MI Data Platform"
      description        = "MI Data Platform"
      published          = true
      externally_visible = false
    },

    {
      name               = "Storage Blob Data Reader (Production)"
      description        = "Storage Blob Data Reader Production Access"
      published          = true
      externally_visible = false
    },

    {
      name               = "Databases"
      description        = "Grants access to databases"
      published          = true
      externally_visible = true
    },

    {
      name               = "SC"
      description        = "Grants access to the SC groups"
      published          = true
      externally_visible = true
    },

    {
      name               = "CFT DB Sandbox - Test"
      description        = "Testing catalog used for developing db read only access"
      published          = true
      externally_visible = true
    },

    {
      name               = "Hub"
      description        = "Hub Subscriptions"
      published          = true
      externally_visible = true
    },

    {
      name               = "SharedServices Subscriptions"
      description        = "DTS-SharedServices Subscriptions"
      published          = true
      externally_visible = false
    },

    {
      name               = "Bastion Servers"
      description        = "Bastion Server Access Catalog"
      published          = true
      externally_visible = false
    },

    {
      name               = "Management Subscriptions"
      description        = "A catalog for JIT access to management subscriptions"
      published          = true
      externally_visible = false
    },

    {
      name               = "General"
      description        = "Built-in catalog."
      published          = true
      externally_visible = true
    },
    # Add more catalogs as needed
  ]
}