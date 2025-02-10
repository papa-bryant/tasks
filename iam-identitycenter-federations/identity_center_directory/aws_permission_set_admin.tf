###################################################################
### AWS Identity Center permission set for clarivate_admin role ###
###################################################################
resource "aws_ssoadmin_permission_set" "admin" {
  provider         = aws.clarivate-identity-prod
  name             = "clarivate_admin"
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
### Bedrock Full Access
data "aws_iam_policy" "bedrock_full_access_admin" {
  provider = aws.clarivate-identity-prod
  name     = "AmazonBedrockFullAccess"
}
resource "aws_ssoadmin_managed_policy_attachment" "bedrock_full_access_admin" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.bedrock_full_access_admin.arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

### Redshift Data Full access
data "aws_iam_policy" "redshift_data_full_access_admin" {
  provider = aws.clarivate-identity-prod
  name     = "AmazonRedshiftDataFullAccess"
}
resource "aws_ssoadmin_managed_policy_attachment" "redshift_data_full_access_admin" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.redshift_data_full_access_admin.arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

### Redshift Query Editor
data "aws_iam_policy" "redshift_query_editor_admin" {
  provider = aws.clarivate-identity-prod
  name     = "AmazonRedshiftQueryEditor"
}
resource "aws_ssoadmin_managed_policy_attachment" "redshift_query_editor_admin" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.redshift_query_editor_admin.arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

### Redshift Query Editor V2 Read Write Sharing
data "aws_iam_policy" "redshift_query_editor_v2_read_write_sharing_admin" {
  provider = aws.clarivate-identity-prod
  name     = "AmazonRedshiftQueryEditorV2ReadWriteSharing"
}
resource "aws_ssoadmin_managed_policy_attachment" "redshift_query_editor_v2_read_write_sharing_admin" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.redshift_query_editor_v2_read_write_sharing_admin.arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

### Glue Data Brew Full Access
data "aws_iam_policy" "glue_data_brew_full_access_admin" {
  provider = aws.clarivate-identity-prod
  name     = "AwsGlueDataBrewFullAccessPolicy"
}
resource "aws_ssoadmin_managed_policy_attachment" "glue_data_brew_full_access_admin" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.glue_data_brew_full_access_admin.arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

### AWS Transfer Full Access
data "aws_iam_policy" "aws_transfer_full_access_admin" {
  provider = aws.clarivate-identity-prod
  name     = "AWSTransferFullAccess"
}
resource "aws_ssoadmin_managed_policy_attachment" "aws_transfer_full_access_admin" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.aws_transfer_full_access_admin.arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

##################################
### Clarivate managed policies ###
##################################
### clarivate-admin-role-policy-iam-allow
data "aws_iam_policy" "clarivate-admin-role-policy-iam-allow" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-admin-role-policy-iam-allow"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-admin-role-policy-iam-allow" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-admin-role-policy-iam-allow.name
    path = "/cl/sso/admin/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

### clarivate-admin-role-policy-iam-allow-passrole
data "aws_iam_policy" "clarivate-admin-role-policy-iam-allow-passrole" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-admin-role-policy-iam-allow-passrole"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-admin-role-policy-iam-allow-passrole" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-admin-role-policy-iam-allow-passrole.name
    path = "/cl/sso/admin/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

### clarivate-admin-role-policy-iam-deny
data "aws_iam_policy" "clarivate-admin-role-policy-iam-deny" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-admin-role-policy-iam-deny"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-admin-role-policy-iam-deny" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-admin-role-policy-iam-deny.name
    path = "/cl/sso/admin/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

### clarivate-admin-role-policy-not-iam
data "aws_iam_policy" "clarivate-admin-role-policy-not-iam" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-admin-role-policy-not-iam"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-admin-role-policy-not-iam" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-admin-role-policy-not-iam.name
    path = "/cl/sso/admin/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}