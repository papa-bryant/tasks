#################################################
### clarivate_admin customer managed policies ###
#################################################
### clarivate-admin-role-policy-iam-allow-passrole
resource "aws_iam_policy" "clarivate-admin-role-policy-iam-allow-passrole" {
  name        = "clarivate-admin-role-policy-iam-allow-passrole"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-iam-allow-passrole.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### clarivate-admin-role-policy-iam-allow
resource "aws_iam_policy" "clarivate-admin-role-policy-iam-allow" {
  name        = "clarivate-admin-role-policy-iam-allow"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-iam-allow.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### clarivate-admin-role-policy-iam-deny
resource "aws_iam_policy" "clarivate-admin-role-policy-iam-deny" {
  name        = "clarivate-admin-role-policy-iam-deny"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-iam-deny.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### clarivate-admin-role-policy-not-iam
resource "aws_iam_policy" "clarivate-admin-role-policy-not-iam" {
  name        = "clarivate-admin-role-policy-not-iam"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-not-iam.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}

### clarivate-admin-role-policy-exclude
resource "aws_iam_policy" "clarivate-admin-role-boundary-permission" {
  name        = "clarivate-admin-role-policy-boundary-permission"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-boundary-permission.json", { account_id = local.account_id })
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "policy"
    "Environment" = "prod"
  }
}
