#-----------------------------------------------------------
# Package entries
#-----------------------------------------------------------

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

    {
      name         = "DB Sandbox Demo"
      description  = "Grants access to all sandbox databases"
      catalog_name = "CFT DB Sandbox - Test"
    },

    {
      name         = "Database - lau read access"
      description  = "Grants read access to lau databases"
      catalog_name = "Databases"
    },

    {
      name         = "Database - PCQ read access"
      description  = "Grants read access to PCQ database"
      catalog_name = "Databases"
    },

    {
      name         = "Database - hmc-cft-hearing read access"
      description  = "Grants read access to hmc databases"
      catalog_name = "Databases"
    },

    {
      name         = "Database - libragob read access"
      description  = "Grants read access to libragob production databases"
      catalog_name = "Databases"
    },

    {
      name         = "Database - PIP read access"
      description  = "Grants read access to PIP databases"
      catalog_name = "Databases"
    },

    {
      name         = "Strategic Data Platform - Production (Engineers)"
      description  = "Access to SDP Production"
      catalog_name = "SC"
    },

    {
      name         = "Databases - Translation Service Read Access"
      description  = "Grants read access to Translation Service (ts) database"
      catalog_name = "Databases"
    },

    {
      name         = "Databases - Work Allocation Read Access"
      description  = "Grants read access to Work Allocation (wa) databases [wa_workflow, wa_case_event & cft_task_db]"
      catalog_name = "Databases"
    },

    {
      name         = "Database - ethos read access"
      description  = "Grants read access to Ethos database"
      catalog_name = "Databases"
    },

    {
      name         = "Strategic Data Platform - Production (PlatOps and PET)"
      description  = "Access to SDP Production"
      catalog_name = "SC"
    },

    {
      name         = "SecOps Sandbox Bastion Server Access)"
      description  = "This will provide access to Bastion Servers for SevOps in Sandbox (SBOX) environments."
      catalog_name = "Bastion Servers"
    },

    {
      name         = "SecOps Production Bastion Server Access"
      description  = "This will provide access to Bastion Servers for SecOps in Production environments."
      catalog_name = "Bastion Servers"
    },

    {
      name         = "Databases - Fact Read Access"
      description  = "Grants read access to fact database"
      catalog_name = "Databases"
    },

    {
      name         = "Database - DM read access"
      description  = "Grants read access to Evidence (DM) Database"
      catalog_name = "Databases"
    },

    {
      name         = "Database - em read access"
      description  = "Grants read access to em databases (emhrs, annotation, stitching & npa)"
      catalog_name = "Databases"
    },

    {
      name         = "Administrative Access - Production Bastion Server"
      description  = "This role should only be used to complete data migrations This will provide administrative access to Bastion Servers in Production environments."
      catalog_name = "Bastion Servers"
    },

    {
      name         = "Administrative Access - Non-Production Bastion Server"
      description  = "This role should only be used to complete data migrations This will provide administrative access to Bastion Servers in Non-Production environments."
      catalog_name = "Bastion Servers"
    },

    {
      name         = "Database - ccpay read access"
      description  = "Grants read access to ccpay databases"
      catalog_name = "Databases"
    },

    {
      name         = "Database - AM read access"
      description  = "Grants read access to AM databases"
      catalog_name = "Databases"
    },

    {
      name         = "SharedServices Subscriptions Non-Production Access (Write)"
      description  = "This will provide write access to the SharedServices subscriptions classified as non-production."
      catalog_name = "SharedServices Subscriptions"
    },

    {
      name         = "SharedServices Subscriptions Production Access (Write)"
      description  = "Contributor access to shared services prod"
      catalog_name = "SharedServices Subscriptions"
    },

    {
      name         = "SharedServices Storage Blob Data Reader (Production)"
      description  = "This will provide Storage Blob Data Reader access to SharedServices subscriptions classified as production."
      catalog_name = "Storage Blob Data Reader (Production)"
    },

    {
      name         = "Non-Production Bastion Server Access"
      description  = "This will provide access to Bastion Servers in Non-Production environments."
      catalog_name = "Bastion Servers"
    },

    {
      name         = "Production Bastion Server Access"
      description  = "This will provide access to Bastion Servers in Production environments."
      catalog_name = "Bastion Servers"
    },

    {
      name         = "Database - draft-store read access"
      description  = "Grants read access to draft store databases"
      catalog_name = "Databases"
    },

    {
      name         = "Database - RD read access"
      description  = "Grants read access to RD databases"
      catalog_name = "Databases"
    },

    {
      name         = "Database - CCD read access"
      description  = "Grants read access to CCD databases"
      catalog_name = "Databases"
    },

    {
      name         = "Database - send-letter read access"
      description  = "Grants read access to send-letter databases"
      catalog_name = "Databases"
    },

    {
      name         = "Database - reform-scan read access"
      description  = "Grants read access to reform-scan databases"
      catalog_name = "Databases"
    },

    {
      name         = "Database - bulk-scan read access"
      description  = "Grants read access to bulk-scan databases"
      catalog_name = "Databases"
    },

    {
      name         = "SC Access"
      description  = "Grants access to SC restricted resources and additional access packages"
      catalog_name = "SC"
    },

    {
      name         = "DB Access - API test"
      description  = "Provides access to sandbox DBs"
      catalog_name = "CFT DB Sandbox - Test"
    },

    {
      name         = "CFT DB Sandbox Demo"
      description  = "Grants read access to CFT DBs in sandbox"
      catalog_name = "CFT DB Sandbox - Test"
    },

    {
      name         = "CFT sandbox DB read - test"
      description  = "Testing access package for CFT db sandbox"
      catalog_name = "CFT DB Sandbox - Test"
    },

    {
      name         = "SharedServices Subscriptions Non-Production Access (Reader)"
      description  = "This will provide Read Only access to the SharedServices subscriptions classified as non-production."
      catalog_name = "SharedServices Subscriptions"
    },

    {
      name         = "Hub Subscriptions Access (Reader)"
      description  = "Initial Policy"
      catalog_name = "Hub"
    },

    {
      name         = "Management Subscription Non-Production Access (Write)"
      description  = "This will provide write access to the management subscriptions classified as non-production"
      catalog_name = "General"
    },

    {
      name         = "Management Subscription Non-Production Access (Reader)"
      description  = "This will provide read-only access to the management subscriptions classified as non-production"
      catalog_name = "General"
    },

    {
      name         = "Management Subscription Production Access (Write)"
      description  = "This will provide write access to the management subscriptions classified as production."
      catalog_name = "General"
    },

    {
      name         = "Management Subscription Production Access (Reader)"
      description  = "This will provide read-only access to the management subscriptions classified as production."
      catalog_name = "General"
    },


    # Add more packages as needed
  ]
}