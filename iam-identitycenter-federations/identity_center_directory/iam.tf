############################################################################################
### Crossaccount role in clarivate-identity-prod to manage the Identity Center Directory ###
############################################################################################
### Crossaccount role can only be assumed by the cloudops-pipeline roles
locals {
  assume_role_policy = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "aws:PrincipalOrgID" : "$${aws:PrincipalOrgID}"
          },
          "StringLike" : {
            "aws:PrincipalArn" : "arn:aws:iam::*:role/cl/app/crossaccount/cloudopspipeline/cloudops-pipeline-*"
          },
          "ForAnyValue:StringLike" : {
            "aws:ResourceOrgPaths" : "o-av9xxxtyb3/*"
          }
        }
      }
    ]
  }
}

### Crossaccount role in clarivate-identity-prod
resource "aws_iam_role" "pipeline_ic_svc_role" {
  provider              = aws.clarivate-identity-prod
  name                  = "cloudops-pipeline-identity-center-svc-role"
  path                  = "/cl/app/crossaccount/cloudopspipeline/"
  description           = "CloudOps pipeline identity center service role"
  assume_role_policy    = jsonencode(local.assume_role_policy)
  max_session_duration  = "28800"
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "cross-account-role"
    "Environment" = "prod"
  }
}

### Policy to allow IAM, SSO and Identity Store actions
data "aws_iam_policy_document" "iam_permissions" {
  statement {
    effect = "Allow"
    resources = [
      "*"
    ]
    actions = [
      "iam:*",
      "sso:*",
      "identitystore:*"
    ]
  }
}
resource "aws_iam_policy" "identity_center_policy" {
  provider    = aws.clarivate-identity-prod
  name        = "cloudops-pipeline-identity-center-svc-policy"
  description = "Managed by CloudOps."
  path        = "/cl/app/ssm/"
  policy      = data.aws_iam_policy_document.iam_permissions.json
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "cross-account-role-policy"
    "Environment" = "prod"
  }
}
resource "aws_iam_role_policy_attachment" "identity_center_policy" {
  provider   = aws.clarivate-identity-prod
  role       = aws_iam_role.pipeline_ic_svc_role.name
  policy_arn = aws_iam_policy.identity_center_policy.arn
}

### Crossaccount role in clarivate-tools-prod
resource "aws_iam_role" "pipeline_ic_svc_role_tools" {
  provider              = aws.clarivate-tools-prod
  name                  = "cloudops-pipeline-identity-center-svc-role"
  path                  = "/cl/app/crossaccount/cloudopspipeline/"
  description           = "CloudOps pipeline identity center service role"
  assume_role_policy    = jsonencode(local.assume_role_policy)
  max_session_duration  = "28800"
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "cross-account-role"
    "Environment" = "prod"
  }
}

### Policy to allow IAM, SSO and Identity Store actions
data "aws_iam_policy_document" "s3_permissions" {
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::aws.clarivate.io"
    ]
    actions = [
      "s3:*"
    ]
  }
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:route53:::hostedzone/Z0631372GWLTQTURCDSQ"
    ]
    actions = [
      "route53:ChangeResourceRecordSets",
    ]
  }
  statement {
    effect = "Allow"
    resources = [
      "*"
    ]
    actions = [
      "route53:List*",
      "route53:Get*"
    ]
  }
  statement {
    effect = "Allow"
    resources = [
      "*"
    ]
    actions = [
      "iam:get*",
      "iam:list*"
    ]
  }
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:iam::773321882549:policy/cl/app/ssm/cloudops-pipeline-identity-center-svc-policy",
      "arn:aws:iam::773321882549:role/cl/app/crossaccount/cloudopspipeline/cloudops-pipeline-identity-center-svc-role"
    ]
    actions = [
      "iam:*"
    ]
  }
}
resource "aws_iam_policy" "identity_center_policy_tools" {
  provider    = aws.clarivate-tools-prod
  name        = "cloudops-pipeline-identity-center-svc-policy"
  description = "Managed by CloudOps."
  path        = "/cl/app/ssm/"
  policy      = data.aws_iam_policy_document.s3_permissions.json
  tags = {
    "Product"     = "Shared Services"
    "Component"   = "iam"
    "Layer"       = "cross-account-role-policy"
    "Environment" = "prod"
  }
}
resource "aws_iam_role_policy_attachment" "identity_center_policy_tools" {
  provider   = aws.clarivate-tools-prod
  role       = aws_iam_role.pipeline_ic_svc_role_tools.name
  policy_arn = aws_iam_policy.identity_center_policy_tools.arn
}