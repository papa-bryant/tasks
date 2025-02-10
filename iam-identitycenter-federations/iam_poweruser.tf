#####################################################
### clarivate_poweruser customer managed policies ###
#####################################################
### clarivate-poweruser-role-policy-boundary-permission
resource "aws_iam_policy" "clarivate-poweruser-role-policy-boundary-permission" {
  name        = "clarivate-poweruser-role-policy-boundary-permission"
  description = "Boundary Permission Policy for powerusers"
  path        = "/cl/sso/poweruser/"
  policy      = templatefile("${path.module}/policies/clarivate_poweruser/clarivate-poweruser-role-policy-boundary-permission.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### clarivate-poweruser-role-policy-deny-sg
resource "aws_iam_policy" "clarivate-poweruser-role-policy-deny-sg" {
  name        = "clarivate-poweruser-role-policy-deny-sg"
  description = "PowerUser Deny Policy for SGs and SecretsManager"
  path        = "/cl/sso/poweruser/"
  policy      = templatefile("${path.module}/policies/clarivate_poweruser/clarivate-poweruser-role-policy-deny-sg.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### clarivate-poweruser-role-policy-sts_deny
resource "aws_iam_policy" "clarivate-poweruser-role-policy-sts_deny" {
  name        = "clarivate-poweruser-role-policy-sts_deny"
  description = "Policy for powerusers"
  path        = "/cl/sso/poweruser/"
  policy      = templatefile("${path.module}/policies/clarivate_poweruser/clarivate-poweruser-role-policy-sts_deny.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### AWS Managed poweruseraccess role policy
data "aws_iam_policy" "PowerUserAccess" {
  arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "poweruser_managed_policy" {
  role       = "clarivate_poweruser"
  policy_arn = data.aws_iam_policy.PowerUserAccess.arn
}
