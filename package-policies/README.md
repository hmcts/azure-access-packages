# Access Policy 
Access policies are defined and reused within the `azuread_access_package_assignment_policy` resource
to assign policies to packages.

## Defining a policy
Additional access policy can be added by creating a new file in this folder and
defining the properties for you specific policy.

Existing policies that cover most use cases are
- General <br>
  This is a default policy to be used if no specific requirements in setting
- Database<br>
  Used for packages that grant access to DB related resources

## Setting a Policy
To associate a policy with an access package simple
- Define the policy if no already existing. The policy definition looks like
  
```yaml
name: "General"
policies:
 ...
```

- Specify the name of the policies to be used by the access package definition in the [entitlement-packages](../entitlement-packages.yml) definition file

```yaml
    ...
    policies: 
      - "General"
```
  There could none, 1 or more policies per access package definition

When terraform processes the access packages if would associate your access package with the policy.

## Skeleton Template
A full list of all possible attributes, the police does not need to have all of it. Full detail
can be found in the [provider](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_assignment_policy) documentation.

