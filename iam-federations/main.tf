terraform {
  # backend "s3" {

  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

module "get-component" {
  source = "git::ssh://git@git-int.clarivate.io/cloudops-tf/cloudops-pipeline-tf-base-modules.git?ref=main"
}

provider "aws" {
  default_tags {
    tags = {
      "tr:appName"          = "cloudops-fleet-iam"
      "tr:appFamily"        = "shared-services"
      "tr:role"             = "infrastructure"
      "tr:environment-type" = "prod"
      "ca:gitrepo"          = "git.clarivate.io/cloudops-tf/cloudops-fleet-iam.git"
    }
  }
}

locals {
  account_id     = data.aws_caller_identity.current.account_id
  component      = module.get-component.main-module-output
  org_account_id = local.component["component"]["organization_id"]
}

############
# SUPERADMIN
############
resource "aws_iam_policy" "clarivate-superadmin-policy-ri-deny" {
  name        = "clarivate-superadmin-policy-ri-deny"
  description = "Policy for super users to deny RI purchases"
  path        = "/cl/sso/superadmin/"
  policy      = templatefile("${path.module}/policies/clarivate_superadmin/clarivate-superadmin-policy-ri-deny.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-superadmin-role-policy" {
  name        = "clarivate-superadmin-role-policy"
  description = "Policy for super users"
  path        = "/cl/sso/superadmin/"
  policy      = templatefile("${path.module}/policies/clarivate_superadmin/clarivate-superadmin-role-policy.json", { account_id = local.account_id })
}


resource "aws_iam_role" "clarivate_superadmin" {
  name                 = "clarivate_superadmin"
  path                 = "/cl/sso/"
  description          = "cloudops-fleet-iam"
  assume_role_policy   = templatefile("${path.module}/policies/clarivate_superadmin/trust_relationship.json", { account_id = local.account_id, orgs_account_id = local.org_account_id })
  max_session_duration = "28800"
}

resource "aws_iam_role_policy_attachment" "superadmin-attach1" {
  role       = "clarivate_superadmin"
  policy_arn = aws_iam_policy.clarivate-superadmin-role-policy.arn
  depends_on = [aws_iam_role.clarivate_superadmin, aws_iam_policy.clarivate-superadmin-role-policy]
}

resource "aws_iam_role_policy_attachment" "superadmin-attach2" {
  role       = "clarivate_superadmin"
  policy_arn = aws_iam_policy.clarivate-superadmin-policy-ri-deny.arn
  depends_on = [aws_iam_role.clarivate_superadmin, aws_iam_policy.clarivate-superadmin-policy-ri-deny]
}

resource "aws_iam_role_policy_attachment" "superadmin-attach3" {
  role       = "clarivate_superadmin"
  policy_arn = data.aws_iam_policy.AdministratorAccess.arn
  depends_on = [aws_iam_role.clarivate_superadmin]
}

##########
#POWERUSER
##########
resource "aws_iam_policy" "cloudcustodian-remote-policy" {
  count       = var.account-tools-prod == data.aws_caller_identity.current.account_id ? 1 : 0
  name        = "cloudcustodian-remote-policy"
  description = "Policy for powerusers to allow ro assumpion from tools-prod"
  path        = "/cl/sso/poweruser/"
  policy      = templatefile("${path.module}/policies/clarivate_poweruser/clarivate-poweruser-role-cloudcustodian-remote-policy.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-poweruser-role-policy-boundary-permission" {
  name        = "clarivate-poweruser-role-policy-boundary-permission"
  description = "Boundary Permission Policy for powerusers"
  path        = "/cl/sso/poweruser/"
  policy      = templatefile("${path.module}/policies/clarivate_poweruser/clarivate-poweruser-role-policy-boundary-permission.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-poweruser-role-policy-deny-sg" {
  name        = "clarivate-poweruser-role-policy-deny-sg"
  description = "PowerUser Deny Policy for SGs and SecretsManager"
  path        = "/cl/sso/poweruser/"
  policy      = templatefile("${path.module}/policies/clarivate_poweruser/clarivate-poweruser-role-policy-deny-sg.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-poweruser-role-policy-sts_deny" {
  name        = "clarivate-poweruser-role-policy-sts_deny"
  description = "Policy for powerusers"
  path        = "/cl/sso/poweruser/"
  policy      = templatefile("${path.module}/policies/clarivate_poweruser/clarivate-poweruser-role-policy-sts_deny.json", { account_id = local.account_id })
}

resource "aws_iam_role" "clarivate_poweruser" {
  name                 = "clarivate_poweruser"
  path                 = "/cl/sso/"
  description          = "cloudops-fleet-iam"
  assume_role_policy   = templatefile("${path.module}/policies/clarivate_poweruser/trust_relationship.json", { account_id = local.account_id, orgs_account_id = local.org_account_id })
  max_session_duration = "28800"
  permissions_boundary = aws_iam_policy.clarivate-poweruser-role-policy-boundary-permission.arn
  managed_policy_arns = var.account-tools-prod == data.aws_caller_identity.current.account_id ? ([
    aws_iam_policy.clarivate-poweruser-role-policy-deny-sg.arn,
    data.aws_iam_policy.AmazonRedshiftDataFullAccess.arn,
    data.aws_iam_policy.AmazonRedshiftQueryEditor.arn,
    data.aws_iam_policy.AWSDataExchangeProviderFullAccess.arn,
    data.aws_iam_policy.AmazonRedshiftQueryEditorV2ReadWriteSharing.arn,
    data.aws_iam_policy.AwsGlueDataBrewFullAccessPolicy.arn,
    aws_iam_policy.cloudcustodian-remote-policy[0].arn
    ]) : ([
    aws_iam_policy.clarivate-poweruser-role-policy-deny-sg.arn,
    aws_iam_policy.clarivate-poweruser-role-policy-sts_deny.arn,
    data.aws_iam_policy.AmazonRedshiftDataFullAccess.arn,
    data.aws_iam_policy.AmazonRedshiftQueryEditor.arn,
    data.aws_iam_policy.AWSDataExchangeProviderFullAccess.arn,
    data.aws_iam_policy.AmazonRedshiftQueryEditorV2ReadWriteSharing.arn,
    data.aws_iam_policy.AwsGlueDataBrewFullAccessPolicy.arn
  ])
}

resource "aws_iam_role_policy_attachment" "poweruser-tools-attach1" {
  count      = var.account-tools-prod == data.aws_caller_identity.current.account_id ? 1 : 0
  role       = "clarivate_poweruser"
  policy_arn = aws_iam_policy.cloudcustodian-remote-policy[count.index].arn
  depends_on = [aws_iam_role.clarivate_poweruser, aws_iam_policy.cloudcustodian-remote-policy]
}

resource "aws_iam_role_policy_attachment" "poweruser-attach5" {
  count      = var.account-tools-prod == data.aws_caller_identity.current.account_id ? 0 : 1
  role       = "clarivate_poweruser"
  policy_arn = aws_iam_policy.clarivate-poweruser-role-policy-sts_deny.arn
  depends_on = [aws_iam_role.clarivate_poweruser, aws_iam_policy.clarivate-poweruser-role-policy-sts_deny]
}

resource "aws_iam_role_policy_attachment" "poweruser-attach6" {
  role       = "clarivate_poweruser"
  policy_arn = aws_iam_policy.clarivate-poweruser-role-policy-deny-sg.arn
  depends_on = [aws_iam_role.clarivate_poweruser, aws_iam_policy.clarivate-poweruser-role-policy-deny-sg]
}

# Managed Policy Additions
resource "aws_iam_role_policy_attachment" "poweruser-managed-attach1" {
  role       = "clarivate_poweruser"
  policy_arn = data.aws_iam_policy.AmazonRedshiftDataFullAccess.arn
  depends_on = [aws_iam_role.clarivate_poweruser]
}

resource "aws_iam_role_policy_attachment" "poweruser-managed-attach2" {
  role       = "clarivate_poweruser"
  policy_arn = data.aws_iam_policy.AmazonRedshiftQueryEditor.arn
  depends_on = [aws_iam_role.clarivate_poweruser]
}

resource "aws_iam_role_policy_attachment" "poweruser-managed-attach3" {
  role       = "clarivate_poweruser"
  policy_arn = data.aws_iam_policy.AWSDataExchangeProviderFullAccess.arn
  depends_on = [aws_iam_role.clarivate_poweruser]
}

resource "aws_iam_role_policy_attachment" "poweruser-managed-attach4" {
  role       = "clarivate_poweruser"
  policy_arn = data.aws_iam_policy.AmazonRedshiftQueryEditorV2ReadWriteSharing.arn
  depends_on = [aws_iam_role.clarivate_poweruser]
}

resource "aws_iam_role_policy_attachment" "poweruser-managed-attach5" {
  role       = "clarivate_poweruser"
  policy_arn = data.aws_iam_policy.AwsGlueDataBrewFullAccessPolicy.arn
  depends_on = [aws_iam_role.clarivate_poweruser]
}

resource "aws_iam_role_policy_attachment" "poweruser-managed-attach6" {
  role       = "clarivate_poweruser"
  policy_arn = data.aws_iam_policy.PowerUserAccess.arn
  depends_on = [aws_iam_role.clarivate_poweruser]
}


#######
# ADMIN
#######
resource "aws_iam_policy" "clarivate-admin-role-policy-iam-allow-passrole" {
  name        = "clarivate-admin-role-policy-iam-allow-passrole"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-iam-allow-passrole.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-admin-role-policy-iam-allow" {
  name        = "clarivate-admin-role-policy-iam-allow"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-iam-allow.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-admin-role-policy-iam-deny" {
  name        = "clarivate-admin-role-policy-iam-deny"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-iam-deny.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-admin-role-policy-not-iam" {
  name        = "clarivate-admin-role-policy-not-iam"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-not-iam.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-admin-role-policy-exclude" {
  name        = "clarivate-admin-role-policy-exclude"
  description = "Policy for admins"
  path        = "/cl/sso/admin/"
  policy      = templatefile("${path.module}/policies/clarivate_admin/clarivate-admin-role-policy-exclude.json", { account_id = local.account_id })
}

resource "aws_iam_role" "clarivate_admin" {
  name               = "clarivate_admin"
  path               = "/cl/sso/"
  description        = "cloudops-fleet-iam"
  assume_role_policy = templatefile("${path.module}/policies/clarivate_admin/trust_relationship.json", { account_id = local.account_id, orgs_account_id = local.org_account_id })
  managed_policy_arns = [
    aws_iam_policy.clarivate-admin-role-policy-not-iam.arn,
    aws_iam_policy.clarivate-admin-role-policy-iam-deny.arn,
    aws_iam_policy.clarivate-admin-role-policy-iam-allow-passrole.arn,
    aws_iam_policy.clarivate-admin-role-policy-iam-allow.arn,
    data.aws_iam_policy.AmazonRedshiftDataFullAccess.arn,
    data.aws_iam_policy.AmazonRedshiftQueryEditor.arn,
    data.aws_iam_policy.AWSTransferFullAccess.arn,
    data.aws_iam_policy.AmazonRedshiftQueryEditorV2ReadWriteSharing.arn,
    data.aws_iam_policy.AwsGlueDataBrewFullAccessPolicy.arn,
    data.aws_iam_policy.BedrockFullAccess.arn
  ]
  max_session_duration = "28800"
}

resource "aws_iam_role_policy_attachment" "admin-attach1" {
  role       = "clarivate_admin"
  policy_arn = aws_iam_policy.clarivate-admin-role-policy-not-iam.arn
  depends_on = [aws_iam_role.clarivate_admin, aws_iam_policy.clarivate-admin-role-policy-not-iam]
}

resource "aws_iam_role_policy_attachment" "admin-attach2" {
  role       = "clarivate_admin"
  policy_arn = aws_iam_policy.clarivate-admin-role-policy-iam-deny.arn
  depends_on = [aws_iam_role.clarivate_admin, aws_iam_policy.clarivate-admin-role-policy-iam-deny]
}

resource "aws_iam_role_policy_attachment" "admin-attach3" {
  role       = "clarivate_admin"
  policy_arn = aws_iam_policy.clarivate-admin-role-policy-iam-allow-passrole.arn
  depends_on = [aws_iam_role.clarivate_admin, aws_iam_policy.clarivate-admin-role-policy-iam-allow-passrole]
}

resource "aws_iam_role_policy_attachment" "admin-attach4" {
  role       = "clarivate_admin"
  policy_arn = aws_iam_policy.clarivate-admin-role-policy-iam-allow.arn
  depends_on = [aws_iam_role.clarivate_admin, aws_iam_policy.clarivate-admin-role-policy-iam-allow]
}

resource "aws_iam_role_policy_attachment" "admin-attach5" {
  role       = "clarivate_admin"
  policy_arn = aws_iam_policy.clarivate-admin-role-policy-exclude.arn
  depends_on = [aws_iam_role.clarivate_admin, aws_iam_policy.clarivate-admin-role-policy-exclude]
}


# Managed Policy Additions 
resource "aws_iam_role_policy_attachment" "admin-managed-attach1" {
  role       = "clarivate_admin"
  policy_arn = data.aws_iam_policy.AmazonRedshiftDataFullAccess.arn
  depends_on = [aws_iam_role.clarivate_admin]
}

resource "aws_iam_role_policy_attachment" "admin-managed-attach2" {
  role       = "clarivate_admin"
  policy_arn = data.aws_iam_policy.AmazonRedshiftQueryEditor.arn
  depends_on = [aws_iam_role.clarivate_admin]
}

resource "aws_iam_role_policy_attachment" "admin-managed-attach3" {
  role       = "clarivate_admin"
  policy_arn = data.aws_iam_policy.AWSTransferFullAccess.arn
  depends_on = [aws_iam_role.clarivate_admin]
}

resource "aws_iam_role_policy_attachment" "admin-managed-attach4" {
  role       = "clarivate_admin"
  policy_arn = data.aws_iam_policy.AmazonRedshiftQueryEditorV2ReadWriteSharing.arn
  depends_on = [aws_iam_role.clarivate_admin]
}

resource "aws_iam_role_policy_attachment" "admin-managed-attach5" {
  role       = "clarivate_admin"
  policy_arn = data.aws_iam_policy.AwsGlueDataBrewFullAccessPolicy.arn
  depends_on = [aws_iam_role.clarivate_admin]
}

resource "aws_iam_role_policy_attachment" "admin-managed-attach6" {
  role       = "clarivate_admin"
  policy_arn = data.aws_iam_policy.BedrockFullAccess.arn
  depends_on = [aws_iam_role.clarivate_admin]
}

##########
# READONLY
##########
resource "aws_iam_policy" "clarivate-readonly-role-policy-iam_allow_n-z" {
  name        = "clarivate-readonly-role-policy-iam_allow_n-z"
  description = "Policy for readonly users"
  path        = "/cl/sso/readonly/"
  policy      = templatefile("${path.module}/policies/clarivate_readonly/clarivate-readonly-role-policy-iam_allow_n-z.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-readonly-role-policy-iam_allow_a-m" {
  name        = "clarivate-readonly-role-policy-iam_allow_a-m"
  description = "Policy for readonly users"
  path        = "/cl/sso/readonly/"
  policy      = templatefile("${path.module}/policies/clarivate_readonly/clarivate-readonly-role-policy-iam_allow_a-m.json", { account_id = local.account_id })
}

resource "aws_iam_policy" "clarivate-readonly-role-policy-iam_deny" {
  name        = "clarivate-readonly-role-policy-iam_deny"
  description = "Policy for readonly users"
  path        = "/cl/sso/readonly/"
  policy      = templatefile("${path.module}/policies/clarivate_readonly/clarivate-readonly-role-policy-iam_deny.json", { account_id = local.account_id })
}

resource "aws_iam_role" "clarivate_readonly" {
  name                 = "clarivate_readonly"
  path                 = "/cl/sso/"
  description          = "cloudops-fleet-iam"
  assume_role_policy   = templatefile("${path.module}/policies/clarivate_readonly/trust_relationship.json", { account_id = local.account_id, orgs_account_id = local.org_account_id })
  max_session_duration = "28800"
  managed_policy_arns = var.account-sing-dev == data.aws_caller_identity.current.account_id ? ([
    aws_iam_policy.clarivate-readonly-role-policy-iam_deny.arn,
    aws_iam_policy.clarivate-readonly-role-policy-iam_allow_n-z.arn,
    aws_iam_policy.clarivate-readonly-role-policy-iam_allow_a-m.arn,
    data.aws_iam_policy.ReadOnlyAccess.arn, data.aws_iam_policy.singularity-developer-remote-policy[0].arn
    ]) : ([
    aws_iam_policy.clarivate-readonly-role-policy-iam_deny.arn,
    aws_iam_policy.clarivate-readonly-role-policy-iam_allow_n-z.arn,
    aws_iam_policy.clarivate-readonly-role-policy-iam_allow_a-m.arn,
    data.aws_iam_policy.ReadOnlyAccess.arn,
    data.aws_iam_policy.BedrockReadOnlyAccess.arn
  ])
}

resource "aws_iam_role_policy_attachment" "readonly-attach1" {
  role       = "clarivate_readonly"
  policy_arn = aws_iam_policy.clarivate-readonly-role-policy-iam_deny.arn
  depends_on = [aws_iam_role.clarivate_readonly, aws_iam_policy.clarivate-readonly-role-policy-iam_deny]
}

resource "aws_iam_role_policy_attachment" "readonly-attach2" {
  role       = "clarivate_readonly"
  policy_arn = aws_iam_policy.clarivate-readonly-role-policy-iam_allow_n-z.arn
  depends_on = [aws_iam_role.clarivate_readonly, aws_iam_policy.clarivate-readonly-role-policy-iam_allow_n-z]
}

# Managed Policy Additions
resource "aws_iam_role_policy_attachment" "readonly-managed-attach1" {
  role       = "clarivate_readonly"
  policy_arn = data.aws_iam_policy.ReadOnlyAccess.arn
  depends_on = [aws_iam_role.clarivate_readonly]
}

resource "aws_iam_role_policy_attachment" "readonly-managed-attach2" {
  role       = "clarivate_readonly"
  policy_arn = data.aws_iam_policy.BedrockReadOnlyAccess.arn
  depends_on = [aws_iam_role.clarivate_readonly]
}

# Exceptions
resource "aws_iam_role_policy_attachment" "singularity-developer-remote-policy-attach" {
  count      = var.account-sing-dev == data.aws_caller_identity.current.account_id ? 1 : 0
  role       = "clarivate_readonly"
  policy_arn = data.aws_iam_policy.singularity-developer-remote-policy[count.index].arn
}
