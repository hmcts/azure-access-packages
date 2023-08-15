# Azure Access Packages
This repository contains code and configuration files for managing Microsoft access packages in Azure.

# Overview
Access packages are a way to group Azure resources and assign permissions to users and groups. Access packages can be used to simplify access management and ensure that users have the appropriate permissions to access the resources they need.

# Entitlement management

Entitlements are either in the form of `catalogs` or `packages`. A catalog needs to exist if its to be used 
in the definition of an access package.

## Catalogs
The `Catalog` definitions are used to manage an access package catalog within Identity Governance in Azure Active Directory. Catalogs
are like buckets of resources consist of have 2 main sections
- Resources
- Roles and administrators

### New Catalog
To create a new catalog entry, add the item definition to the [Catalogs](entitlement-catalogs.yml) definition file found in the root folder.
Below is an example of a `catalog` definition

```yml
{
  "name"               : "<catalog name>"
  "description"        :  "<catalog description>"
  "published"          : <true|false>
  "externally_visible" : <true|false>
  "resources"          : []
}
```
You can add your new definition to the bottom of the list and this would be created after the PR is merged

### Resources
A `catalog` may have some resources associated with them that form part of what can be made available to users.
Resources are added to a catalog by adding an entry in the `resources` section of the yml definiation
```yaml
    resources:
      - "DTS Admin Data Platform (sub:DTS-SHAREDSERVICES-PROD)"
      - ...
```
Generally these are resource groups that have been created in Azure AD.

### Roles and administrators
We have only one role administrator which is the `DTS Platform Operations` that would be used by resources
created via this repository. The `DTS Platform Operations` is defined as a `Catalog owner` on all catalogs created

### Existing entries
To update an existing entry, simple update the  current entry the definition file and terraform would update the relevant
resources after PR is merged.

## Packages
To create a  package entry, add the item definition to the [Packages](entitlement-packages.yml) definition file found in the root folder
Below is an example of a `package` definition
```yaml
{
  "name"         : "<package name>"
  "description"  : "<package name>"
  "catalog_name" : "<package name>" # Defined in the catalog file 
}
```
You can add your new definition to the bottom of the list and this would be created after the PR is merged
