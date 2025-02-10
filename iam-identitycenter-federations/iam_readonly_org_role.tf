#########################
### Readonly ORG Role ###
#########################
### Allow readonly ORG role to be assumed from OrganizationAccountAccessRole and from clarivate_org_readonly
locals {
  assume_role_policy_readonly_org = {
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
          "AWS" : "arn:aws:iam::789681003108:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_clarivate_org_readonly_58b36666698de722"
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

### AWS Managed readonly access policy
data "aws_iam_policy" "readonly_access_policy" {
  name = "ReadOnlyAccess"
}
resource "aws_iam_role" "org_readonly" {
  name                 = "clarivate_org_readonly"
  max_session_duration = 28800
  path                 = "/cl/sso/"
  assume_role_policy   = jsonencode(local.assume_role_policy_readonly_org)
}

resource "aws_iam_role_policy_attachment" "readonly_access_policy" {
  depends_on = [aws_iam_role.org_readonly]
  role       = "clarivate_org_readonly"
  policy_arn = data.aws_iam_policy.readonly_access_policy.arn
}