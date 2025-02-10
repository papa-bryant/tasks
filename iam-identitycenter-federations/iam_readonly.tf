####################################################
### clarivate_readonly customer managed policies ###
####################################################
### clarivate-readonly-role-policy-iam_allow_n-z
resource "aws_iam_policy" "clarivate-readonly-role-policy-iam_allow_n-z" {
  name        = "clarivate-readonly-role-policy-iam_allow_n-z"
  description = "Policy for readonly users"
  path        = "/cl/sso/readonly/"
  policy      = templatefile("${path.module}/policies/clarivate_readonly/clarivate-readonly-role-policy-iam_allow_n-z.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### clarivate-readonly-role-policy-iam_allow_a-m
resource "aws_iam_policy" "clarivate-readonly-role-policy-iam_allow_a-m" {
  name        = "clarivate-readonly-role-policy-iam_allow_a-m"
  description = "Policy for readonly users"
  path        = "/cl/sso/readonly/"
  policy      = templatefile("${path.module}/policies/clarivate_readonly/clarivate-readonly-role-policy-iam_allow_a-m.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### clarivate-readonly-role-policy-iam_deny
resource "aws_iam_policy" "clarivate-readonly-role-policy-iam_deny" {
  name        = "clarivate-readonly-role-policy-iam_deny"
  description = "Policy for readonly users"
  path        = "/cl/sso/readonly/"
  policy      = templatefile("${path.module}/policies/clarivate_readonly/clarivate-readonly-role-policy-iam_deny.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}