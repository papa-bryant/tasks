# Provider configuration
provider "aws" {
  region = "us-east-1"  # Change to your desired region
  # Ensure you're using credentials with Organization admin access
}

# Create new Organizational Unit
resource "aws_organizations_organizational_unit" "tag_compliant_ou" {
  name      = "tag-compliant-accounts"
  parent_id = data.aws_organizations_organization.current.roots[0].id  # Attaches to root
}

# Get existing organization data
data "aws_organizations_organization" "current" {}

# Create SCP for tag enforcement
resource "aws_organizations_policy" "tag_enforcement" {
  name        = "TagEnforcementSCP"
  description = "SCP to enforce mandatory tags on resources"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyCreateWithoutMandatoryTags"
        Effect = "Deny"
        Action = [
          "ec2:RunInstances",
          "s3:CreateBucket",
          "rds:CreateDBInstance",
          "lambda:CreateFunction",
          "cloudformation:CreateStack"
        ]
        Resource = "*"
        Condition = {
          Null = {
            "aws:RequestTag/Product"    = "true"
            "aws:RequestTag/Layer"       = "true"
            "aws:RequestTag/Component"   = "true"
            "aws:RequestTag/Environment" = "true"
          }
        }
      },
      {
        Sid    = "DenyModifyWithoutMandatoryTags"
        Effect = "Deny"
        Action = [
          "ec2:CreateTags",
          "s3:PutBucketTagging",
          "rds:AddTagsToResource",
          "lambda:TagResource",
          "cloudformation:UpdateStack"
        ]
        Resource = "*"
        Condition = {
          Null = {
            "aws:RequestTag/Product"    = "true"
            "aws:RequestTag/Layer"       = "true"
            "aws:RequestTag/Component"   = "true"
            "aws:RequestTag/Environment" = "true"
          }
        }
      }
    ]
  })
}

# Attach the SCP to the OU
resource "aws_organizations_policy_attachment" "attach_tag_policy" {
  policy_id = aws_organizations_policy.tag_enforcement.id
  target_id = aws_organizations_organizational_unit.tag_compliant_ou.id
}

# Outputs
output "ou_id" {
  value       = aws_organizations_organizational_unit.tag_compliant_ou.id
  description = "ID of the created Organizational Unit"
}

output "scp_id" {
  value       = aws_organizations_policy.tag_enforcement.id
  description = "ID of the created Service Control Policy"
}
