# Access Policy 
Access policies are defined and reused within the `azuread_access_package_assignment_policy` resource
to assign policies to packages.

## Adding a new access package

Update the [`entitlement-packages.yml`](entitlement-packages.yml) file with your new package by copying another similar one.
If you are adding a new group that wasn't previously used before you will need to add it to the catalog in [`entitlement-catalogs.yml`](entitlement-catalogs.yml).

## Policies

Existing policies that cover most use cases are:

- `self-approval`
  - One day access, no approval required.
- `self-approval-with-justification`
  - One day access, no approval required, must provide justification on the request.
- `Database-self-approval-with-justification`
  - Standard database policy, 1 day access, can extend once for an additional 24 hours, requires justification and jira / ticket reference.  Approval not required.

Additional access policy can be added by creating a new file in the `package-policies` folder and
defining the properties for you specific policy.

## Setting a Policy
To associate a policy with an access package it's easy.

- Define the policy if it doesn't already exist. The policy definition looks like:
  
```yaml
name: "General"
policies:
 ...
```

- Specify the name of the policy to be used by the access package definition in the [entitlement-packages](entitlement-packages.yml) definition file

```yaml
    ...
    policies: 
      - "General"
```

When terraform processes the access packages it will associate your access package with the policy.

### NOTE
No `users` or `groups` are created in this repo. It assumes they already exist and would error out on `apply` not found.
To create users and groups please have a look at the `azure-access` repo in GitHub

## Skeleton Template
A full list of all possible attributes, the police does not need to have all of it. Full detail
can be found in the [provider](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/access_package_assignment_policy) documentation

`azuread_access_package_assignment_policy`:

```yaml
access_package: 
policies:
  - display_name: 
    description: 
    duration_in_days: 
    expiration_date: 
    approval_settings:
      approval_required_for_extension:
      approval_required:
      approval_stage:
        alternative_approval_enabled:
        alternative_approver:
          backup:
          object_id:
          subject_type:
        approval_timeout_in_days:
        approver_justification_required:
        enable_alternative_approval_in_days:
        primary_approver:
          backup:
          object_id:
          subject_type:
      requestor_justification_required:
    assignment_review_settings:
      access_recommendation_enabled:
      access_review_timeout_behavior:
      approver_justification_required:
      duration_in_days:
      enabled:
      review_frequency:
      review_type:
      reviewer:
        backup:
        object_id:
        subject_type:
      starting_on:
    extension_enabled:
    questions: 
    - choice:
        actual_value:
        display_value:
          default_text:
          localized_text:
            content:
            language_code:
      required:
      sequence:
      text:
        default_text:
        localized_text:
          content:
          language_code:
    requestor_settings:
      requestor:
        object_id:
        subject_type:
      requests_accepted:
      scope_type:
```
