######################################################
### AWS Identity Center permission set assignments ###
######################################################
### readonly Azure AD group
data "aws_identitystore_group" "readonly" {
  provider          = aws.clarivate-identity-prod
  identity_store_id = tolist(data.aws_ssoadmin_instances.instance.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AZ_AWS-${local.full_account_name}-readonly"
    }
  }
}
### readonly permission set assignment
resource "aws_ssoadmin_account_assignment" "readonly" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  permission_set_arn = data.aws_caller_identity.current.account_id == "807485099697" ? data.aws_ssoadmin_permission_set.readonly_singularity.arn : data.aws_ssoadmin_permission_set.readonly.arn

  principal_id   = data.aws_identitystore_group.readonly.group_id
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}

### poweruser Azure AD group
data "aws_identitystore_group" "poweruser" {
  provider          = aws.clarivate-identity-prod
  identity_store_id = tolist(data.aws_ssoadmin_instances.instance.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AZ_AWS-${local.full_account_name}-poweruser"
    }
  }
}
### poweruser permission set assignment
resource "aws_ssoadmin_account_assignment" "poweruser" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.poweruser.arn

  principal_id   = data.aws_identitystore_group.poweruser.group_id
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}

### admin Azure AD group
data "aws_identitystore_group" "admin" {
  provider          = aws.clarivate-identity-prod
  identity_store_id = tolist(data.aws_ssoadmin_instances.instance.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AZ_AWS-${local.full_account_name}-admin"
    }
  }
}
### admin permission set assignment
resource "aws_ssoadmin_account_assignment" "admin" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.admin.arn

  principal_id   = data.aws_identitystore_group.admin.group_id
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}

### superadmin Azure AD group
data "aws_identitystore_group" "superadmin" {
  provider          = aws.clarivate-identity-prod
  identity_store_id = tolist(data.aws_ssoadmin_instances.instance.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AZ_AWS-${local.full_account_name}-superadmin"
    }
  }
}
### superadmin permission set assignment
resource "aws_ssoadmin_account_assignment" "superadmin" {
  provider           = aws.clarivate-identity-prod
  instance_arn       = tolist(data.aws_ssoadmin_instances.instance.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.superadmin.arn

  principal_id   = data.aws_identitystore_group.superadmin.group_id
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}