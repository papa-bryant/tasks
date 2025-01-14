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
  target_ou = [
    for ou in data.aws_organizations_organizational_units.all_ous.organizational_units : 
    ou.id if ou.name == "labs-org-dev"
  ]
  
  ou_id = length(local.target_ou) > 0 ? local.target_ou[0] : null
}

resource "aws_organizations_policy" "deny_networking_features" {
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
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "attach_policy" {
  count = local.ou_id != null ? 1 : 0
  
  policy_id = aws_organizations_policy.deny_networking_features.id
  target_id = local.ou_id
}

# Outputs
output "selected_ou_id" {
  value = local.ou_id
}

output "policy_id" {
  value = aws_organizations_policy.deny_networking_features.id
}

output "policy_arn" {
  value = aws_organizations_policy.deny_networking_features.arn
}

output "target_ou_found" {
  value = local.ou_id != null
  description = "Whether the target OU was found"
}

# Debug output to verify OU names
output "debug_all_ous" {
  value = data.aws_organizations_organizational_units.all_ous.organizational_units[*].name
  description = "List of all OU names for verification"
}
