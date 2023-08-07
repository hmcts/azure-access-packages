# Azure Access Packages
This repository contains code and configuration files for managing Microsoft access packages in Azure.


# Overview
Access packages are a way to group Azure resources and assign permissions to users and groups. Access packages can be used to simplify access management and ensure that users have the appropriate permissions to access the resources they need.


# Getting Started
To get started with this repository, you will need to have an Azure subscription and the appropriate permissions to manage access packages.


# Creating access packages

- To create an access package for catalogs if not an existing one, add an entry to [01-catalogs.tf](entitlement/01-catalogs.tf)
- Also add an entry for packages to [02-packages.tf](entitlement/02-pakcages.tf)


# Notes
- The code does not contain any client details. Instead, all credentials are securely passed through environment variables, and any configurable options are stored within the parameters file
- A Service Principal is used for authentication.