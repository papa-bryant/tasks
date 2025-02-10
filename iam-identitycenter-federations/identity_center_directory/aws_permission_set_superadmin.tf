########################################################################
### AWS Identity Center permission set for clarivate_superadmin role ###
########################################################################
resource "aws_ssoadmin_permission_set" "superadmin" {
  provider         = aws.clarivate-identity-prod
  name             = "clarivate_superadmin"
  instance_arn     = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  session_duration = "PT8H"
  relay_state      = "https://us-west-2.console.aws.amazon.com"
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "permission-set"
    "Environment" = "prod"
  }
}

##################################
### Clarivate managed policies ###
##################################
### clarivate-superadmin-policy-ri-deny
data "aws_iam_policy" "clarivate-superadmin-policy-ri-deny" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-superadmin-policy-ri-deny"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-superadmin-policy-ri-deny" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-superadmin-policy-ri-deny.name
    path = "/cl/sso/superadmin/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.superadmin.arn
}

### clarivate-superadmin-role-policy
data "aws_iam_policy" "clarivate-superadmin-role-policy" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-superadmin-role-policy"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-superadmin-role-policy" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-superadmin-role-policy.name
    path = "/cl/sso/superadmin/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.superadmin.arn
}