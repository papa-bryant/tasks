######################################################################
### AWS Identity Center permission set for clarivate_readonly role ###
######################################################################
resource "aws_ssoadmin_permission_set" "readonly" {
  provider         = aws.clarivate-identity-prod
  name             = "clarivate_readonly"
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

############################
### AWS Managed Policies ###
############################
### Amazon Bedrock readonly
data "aws_iam_policy" "bedrock_readonly" {
  provider = aws.clarivate-identity-prod
  name     = "AmazonBedrockReadOnly"
}
resource "aws_ssoadmin_managed_policy_attachment" "bedrock_readonly" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.bedrock_readonly.arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}

### Readonly access
data "aws_iam_policy" "readonly_access" {
  provider = aws.clarivate-identity-prod
  name     = "ReadOnlyAccess"
}
resource "aws_ssoadmin_managed_policy_attachment" "readonly_access" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.readonly_access.arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}

##################################
### Clarivate managed policies ###
##################################
### clarivate-readonly-role-policy-iam_allow_a-m
data "aws_iam_policy" "clarivate-readonly-role-policy-iam_allow_a-m" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-readonly-role-policy-iam_allow_a-m"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-readonly-role-policy-iam_allow_a-m" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-readonly-role-policy-iam_allow_a-m.name
    path = "/cl/sso/readonly/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}

### clarivate-readonly-role-policy-iam_allow_n-z
data "aws_iam_policy" "clarivate-readonly-role-policy-iam_allow_n-z" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-readonly-role-policy-iam_allow_n-z"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-readonly-role-policy-iam_allow_n-z" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-readonly-role-policy-iam_allow_n-z.name
    path = "/cl/sso/readonly/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}

### clarivate-readonly-role-policy-iam_deny
data "aws_iam_policy" "clarivate-readonly-role-policy-iam_deny" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-readonly-role-policy-iam_deny"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-readonly-role-policy-iam_deny" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-readonly-role-policy-iam_deny.name
    path = "/cl/sso/readonly/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}