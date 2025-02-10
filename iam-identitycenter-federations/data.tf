### AWS IAM Identity Center Instance
data "aws_ssoadmin_instances" "instance" {
  provider = aws.clarivate-identity-prod
}

### AWS Caller Identity to obtain target Account ID
data "aws_caller_identity" "current" {}

### readonly permission set
data "aws_ssoadmin_permission_set" "readonly" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  name         = "clarivate_readonly"
}

### readonly permission set singularity
data "aws_ssoadmin_permission_set" "readonly_singularity" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  name         = "clarivate_readonly_singularity"
}

### poweruser permission set
data "aws_ssoadmin_permission_set" "poweruser" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  name         = "clarivate_poweruser"
}

### admin permission set
data "aws_ssoadmin_permission_set" "admin" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  name         = "clarivate_admin"
}

### superadmin permission set
data "aws_ssoadmin_permission_set" "superadmin" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  name         = "clarivate_superadmin"
}