#######################################################################
### AWS Identity Center permission set for clarivate_poweruser role ###
#######################################################################
resource "aws_ssoadmin_permission_set" "poweruser" {
  provider         = aws.clarivate-identity-prod
  name             = "clarivate_poweruser"
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
### PowerUserAccess AWS Managed
data "aws_iam_policy" "poweruser_managed_access" {
  arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "poweruser_managed_access" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.poweruser_managed_access.arn
  permission_set_arn = aws_ssoadmin_permission_set.poweruser.arn
}

### Redshift Data Full access
data "aws_iam_policy" "redshift_data_full_access_poweruser" {
  provider = aws.clarivate-identity-prod
  name     = "AmazonRedshiftDataFullAccess"
}
resource "aws_ssoadmin_managed_policy_attachment" "redshift_data_full_access_poweruser" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.redshift_data_full_access_poweruser.arn
  permission_set_arn = aws_ssoadmin_permission_set.poweruser.arn
}

### Redshift Query Editor
data "aws_iam_policy" "redshift_query_editor_poweruser" {
  provider = aws.clarivate-identity-prod
  name     = "AmazonRedshiftQueryEditor"
}
resource "aws_ssoadmin_managed_policy_attachment" "redshift_query_editor_poweruser" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.redshift_query_editor_poweruser.arn
  permission_set_arn = aws_ssoadmin_permission_set.poweruser.arn
}

### Redshift Query Editor V2 Read Write Sharing
data "aws_iam_policy" "redshift_query_editor_v2_read_write_sharing_poweruser" {
  provider = aws.clarivate-identity-prod
  name     = "AmazonRedshiftQueryEditorV2ReadWriteSharing"
}
resource "aws_ssoadmin_managed_policy_attachment" "redshift_query_editor_v2_read_write_sharing_poweruser" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.redshift_query_editor_v2_read_write_sharing_poweruser.arn
  permission_set_arn = aws_ssoadmin_permission_set.poweruser.arn
}

### AWS Data Exchange Provider Full Access
data "aws_iam_policy" "data_exchange_provider_full_access_poweruser" {
  provider = aws.clarivate-identity-prod
  name     = "AWSDataExchangeProviderFullAccess"
}
resource "aws_ssoadmin_managed_policy_attachment" "data_exchange_provider_full_access_poweruser" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.data_exchange_provider_full_access_poweruser.arn
  permission_set_arn = aws_ssoadmin_permission_set.poweruser.arn
}

### Glue Data Brew Full Access
data "aws_iam_policy" "glue_data_brew_full_access_poweruser" {
  provider = aws.clarivate-identity-prod
  name     = "AwsGlueDataBrewFullAccessPolicy"
}
resource "aws_ssoadmin_managed_policy_attachment" "glue_data_brew_full_access_poweruser" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  managed_policy_arn = data.aws_iam_policy.glue_data_brew_full_access_poweruser.arn
  permission_set_arn = aws_ssoadmin_permission_set.poweruser.arn
}

##################################
### Clarivate managed policies ###
##################################
### clarivate-poweruser-role-policy-deny-sg
data "aws_iam_policy" "clarivate-poweruser-role-policy-deny-sg" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-poweruser-role-policy-deny-sg"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-poweruser-role-policy-deny-sg" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-poweruser-role-policy-deny-sg.name
    path = "/cl/sso/poweruser/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.poweruser.arn
}

### clarivate-poweruser-role-policy-sts_deny
data "aws_iam_policy" "clarivate-poweruser-role-policy-sts_deny" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-poweruser-role-policy-sts_deny"
}
resource "aws_ssoadmin_customer_managed_policy_attachment" "clarivate-poweruser-role-policy-sts_deny" {
  provider     = aws.clarivate-identity-prod
  instance_arn = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  customer_managed_policy_reference {
    name = data.aws_iam_policy.clarivate-poweruser-role-policy-sts_deny.name
    path = "/cl/sso/poweruser/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.poweruser.arn
}

### clarivate-poweruser-role-policy-boundary-permission
data "aws_iam_policy" "clarivate-poweruser-role-policy-boundary-permission" {
  provider = aws.clarivate-identity-prod
  name     = "clarivate-poweruser-role-policy-boundary-permission"
}
resource "aws_ssoadmin_permissions_boundary_attachment" "poweruser_permission_boundary" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.poweruser.arn
  permissions_boundary {
    customer_managed_policy_reference {
      name = data.aws_iam_policy.clarivate-poweruser-role-policy-boundary-permission.name
      path = "/cl/sso/poweruser/"
    }
  }
}