## IAM Users
Create IAM users with limited access to the AWS console or CLI access. Set a password policy and default password. Add the user to a group to create a hierarchy.

## IAM Groups
IAM groups are collections of policies and users. A specific group will have a set of policies, and these policies will be applicable to the users in the group.

## IAM Roles
A role is a collection of policies.

## Access Keys
Access keys consist of a secret key and an access key, which can be used in CLIs and applications where keys are required, such as Terraform.

## MFA
Enable multi-factor authentication (MFA) for enhanced security.

## Access Analyzer
You can create an analyzer to monitor external and unused access for an organization or an individual account. IAM Access Analyzer will review resources for external access and IAM users and roles for unused access in the specified organization or individual account.
IAM Access Analyzer generates findings for unused access granted to your IAM users and roles and for external access granted to a resource from outside of your zone of trust.

## Credentials report of IAM users
The credentials report lists all your IAM users in this account and the status of their various credentials. After a report is created, it is stored for up to four hours.