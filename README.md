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
- `direct-assignment`
  - No self-service requests accepted (`scope_type: NoSubjects`). Access can only be granted by a business stakeholder directly assigning the package to a user, and lasts indefinitely until that stakeholder revokes it (no `duration_in_days`/`expiration_date` set) - see [Assigning access packages on a user's behalf](#assigning-access-packages-on-a-users-behalf) below.

Additional access policy can be added by creating a new file in the `package-policies` folder and
defining the properties for you specific policy.

## Assigning access packages on a user's behalf

Some applications have many roles (modelled as groups/access packages), and the end user often
doesn't know which one they need. For these, a business stakeholder - typically the person who
would otherwise be the approver - can be delegated the ability to directly assign the correct
access package to a user, instead of the user requesting it themselves.

This is done with Entra's built-in **Access package assignment manager** catalog role, which lets
its holders assign or remove any access package in that catalog for a user, but not create or
edit access packages/policies. To grant it:

```yaml
catalogs:
  - name: "My Application"
    ...
    assignment_managers:
      - "My Application Business Stakeholders"
```

Any AD group listed under `assignment_managers` is granted the role for that catalog. Members can
then use **Entra admin center > ID Governance > Entitlement management > Access packages > (package)
> Assignments > New assignment** to assign a package to a user directly.

Note that assignment managers **cannot bypass a policy's approval requirement** - if the policy
they pick requires approval, a direct assignment still waits on that approval. To get a true
"stakeholder assigns, done" flow, use the `direct-assignment` policy (or one modelled on it) on the
access packages those stakeholders should be able to hand out, which also accepts no self-service
requests so users can't request the package themselves.

The `direct-assignment` policy also has no `duration_in_days`/`expiration_date`, so assignments made
under it never expire automatically - access lasts until an assignment manager or catalog owner
removes it (**Assignments > select user > Remove**). This mirrors "assigned by a stakeholder, revoked
by that stakeholder". If you'd rather access lapse on its own after a period, add `duration_in_days`
back into the policy (with `extension_enabled` if it should be renewable); for indefinite access it's
worth pairing with an `assignment_review_settings` recurring review so it still gets periodically
recertified rather than being purely "set and forget".

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
