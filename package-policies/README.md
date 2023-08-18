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
- Define the policy if no already exisiting. The policy definition looks like
  
```yaml
name: "General"
policy:
 ...
```

- Specify the name of the policy to be used by the access package definition in the [entitlement-packages](../entitlement-packages.yml) definition file

```yaml
    ...
    policy: "General"
```

When terraform processes the access packages if would associate your access package with the policy.

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
    question:
      choice:
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
