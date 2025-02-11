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
  name = "require-resource-tags"
  description = "Requires specific tags on resources"
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "RequireTagsOnResources"
        Effect    = "Deny"
        Action    = [
          "ec2:RunInstances",
          "ec2:CreateVolume",
          "s3:CreateBucket",
          "rds:CreateDBInstance",
          "dynamodb:CreateTable"
        ]
        Resource  = "*"
        Condition = {
          "StringLike": {
            "aws:RequestTag/Environment": "",
            "aws:RequestTag/Owner": "",
            "aws:RequestTag/Project": ""
          }
        }
      },
      {
        Sid       = "DenyTagModification"
        Effect    = "Deny"
        Action    = [
          "ec2:DeleteTags",
          "ec2:CreateTags",
          "s3:DeleteBucketTagging",
          "s3:PutBucketTagging",
          "rds:RemoveTagsFromResource",
          "rds:AddTagsToResource"
        ]
        Resource  = "*"
        Condition = {
          "StringLike": {
            "aws:ResourceTag/Environment": "*",
            "aws:ResourceTag/Owner": "*",
            "aws:ResourceTag/Project": "*"
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
