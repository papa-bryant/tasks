# IAM Identity Center for AWS SSO access and authentication

This repository contains Terraform code that will be used to manage SSO access and authentication to AWS using IAM Identity Center.

### Repository structure

- The root directory of the repository contains files that are deployed and managed by the CloudOps AWS Account management pipeline.

- `aws_permission_set_assignment.tf`: manages the assignment of the permission sets to the groups that are synced from AD into AWS.

- `iam_*.tf`: Manages the deployment of IAM policies and other IAM resources in the target accounts in the organization.

- The **policies** folder contains all the IAM policies in JSON format for all the standard AWS roles.

- The **identity_center_directory** directory contains the Terraform files that are managing the Identity Center directory.

### Usage with the pipeline

A dependent module that requires to be ran before this module is the [clarivate-aws-aad](https://git.clarivate.io/projects/CLOUDENG/repos/clarivate-aws-aad/browse) pipeline Terraform module. After doing so this pipeline Terraform module can be ran. The only setting that needs to be present in the pipeline settings JSON is the status set to OK, below is a example.

```json
{
  "status": "ok",
}
```

------
### Documentation

[IAM Identity Center SSO for AWS Account Access - Confluence](https://wiki.clarivate.io/display/CLOUDENG/IAM+Identity+Center+SSO+for+AWS+Account+Access)