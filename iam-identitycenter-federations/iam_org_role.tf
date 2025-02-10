##########################################
### OrganizationAccountAccessRole Role ###
##########################################
### Allow role to be assumed from OrganizationAccountAccessRole
locals {
  assume_role_policy = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::789681003108:role/OrganizationAccountAccessRole"
        },
        "Action" : "sts:AssumeRole"
      },
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::789681003108:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_OrganizationAccountAccessRole_0a82e7a49c65a87f"
        },
        "Action" : "sts:AssumeRole"
      },
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::789681003108:saml-provider/cl-sso"
        },
        "Action" : "sts:AssumeRoleWithSAML",
        "Condition" : {
          "StringEquals" : {
            "SAML:aud" : "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  }
}

### OrganizationAccountAccessRole
resource "aws_iam_role" "OrganizationAccountAccessRole" {
  name                 = "OrganizationAccountAccessRole"
  description          = "OrganizationAccountAccessRole"
  max_session_duration = 28800
  assume_role_policy   = jsonencode(local.assume_role_policy)
}

### AWS Managed administrator access policy
data "aws_iam_policy" "administrator_access" {
  name = "AdministratorAccess"
}
resource "aws_iam_role_policy_attachment" "administrator_access" {
  role       = "OrganizationAccountAccessRole"
  policy_arn = data.aws_iam_policy.administrator_access.arn
}