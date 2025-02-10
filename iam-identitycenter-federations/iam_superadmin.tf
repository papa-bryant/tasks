######################################################
### clarivate_superadmin customer managed policies ###
######################################################
### clarivate-superadmin-policy-ri-deny
resource "aws_iam_policy" "clarivate-superadmin-policy-ri-deny" {
  name        = "clarivate-superadmin-policy-ri-deny"
  description = "Policy for super users to deny RI purchases"
  path        = "/cl/sso/superadmin/"
  policy      = templatefile("${path.module}/policies/clarivate_superadmin/clarivate-superadmin-policy-ri-deny.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### clarivate-superadmin-role-policy
resource "aws_iam_policy" "clarivate-superadmin-role-policy" {
  name        = "clarivate-superadmin-role-policy"
  description = "Policy for super users"
  path        = "/cl/sso/superadmin/"
  policy      = templatefile("${path.module}/policies/clarivate_superadmin/clarivate-superadmin-role-policy.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}


### AWS Managed superadmin role policy
data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "superadmin-attach3" {
  role       = "clarivate_superadmin"
  policy_arn = data.aws_iam_policy.AdministratorAccess.arn
}

