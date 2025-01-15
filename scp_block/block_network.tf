provider "aws" {
  region = "us-east-1" # Adjust to your preferred region
}

# Fetch AWS Organization
data "aws_organizations_organization" "existing" {}

# Fetch all Organizational Units (OUs) under the root
data "aws_organizations_organizational_units" "all_ous" {
  parent_id = data.aws_organizations_organization.existing.roots[0].id
}

# Filter the OU by name and handle potential errors
locals {
    allowed_roles = [
    "cl/app/crossaccount/cloudopspipeline/cloudops-pipeline-role",
    "cl/app/crossaccount/cloudopspipeline/cloudops-pipeline-svc-role",
    # "cloudops-pipeline-task-role",
    # "network-prod-jenkins-terraform-deployment",
    "cl/app/crossaccount/cloudopspipeline/cloudops-pipeline-role",
    "OrganizationAccountAccessRole"
  ]
  root_id = data.aws_organizations_organization.existing.roots[0].id
}

resource "aws_organizations_policy" "deny_networking_features_with_exceptions" {
  name        = "DenyNetworkingFeatures"
  description = "Prevents creation of networking features like VPCs, subnets, gateways, etc."
  
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyNetworkingResources"
        Effect = "Deny"
        Action = [
          "ec2:CreateVpc",
          "ec2:CreateSubnet",
          "ec2:CreateRouteTable",
          "ec2:CreateInternetGateway",
          "ec2:CreateNatGateway",
          "ec2:CreateTransitGateway",
          "ec2:CreateEgressOnlyInternetGateway",
          "ec2:CreateVpnGateway",
          "ec2:CreateNetworkAcl",
          "ec2:CreateNetworkInterface",
          "ec2:CreateCustomerGateway",
          "ec2:CreateVpcPeeringConnection",
          "ec2:AcceptVpcPeeringConnection",
          "ec2:CreateTransitGatewayVpcAttachment",
          "ec2:CreateTransitGatewayRouteTable",
          "ec2:CreateVpnConnection",
          "ec2:AttachInternetGateway",
          "ec2:AttachVpnGateway"
        ]
        Resource = ["*"]
        Condition = {
          StringNotLike = {
            "aws:PrincipalArn": concat(
              [for role in local.allowed_roles :
                "arn:aws:iam::*:role/${role}"
              ],
              # Optionally allow specific users as well
              # ["arn:aws:iam::*:user/NetworkAdmin"]
            )
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "attach_policy" {
  policy_id = aws_organizations_policy.deny_networking_features_with_exceptions.id
  target_id = local.root_id
}

# Outputs
output "selected_ou_id" {
  value = local.root_id
}

output "policy_id" {
  value = aws_organizations_policy.deny_networking_features_with_exceptions.id
}

output "policy_arn" {
  value = aws_organizations_policy.deny_networking_features_with_exceptions.arn
}

output "target_ou_found" {
  value = local.root_id != null
  description = "Whether the target OU was found"
}

# Debug output to verify OU names
output "debug_all_ous" {
  value = data.aws_organizations_organizational_units.all_ous.children[*].name
  description = "List of all OU names for verification"
}
