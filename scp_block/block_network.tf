
# Fetch the existing AWS Organization
data "aws_organizations_organization" "existing" {}

# Fetch the existing Organizational Unit (OU)
data "aws_organizations_organizational_units" "existing_ou" {
  parent_id = data.aws_organizations_organization.existing.roots[0].id
  name      = "NetworkingRestrictedOU" # Replace with the name of your existing OU
}

resource "aws_organizations_policy" "deny_networking_features" {
  name        = "DenyNetworkingFeatures"
  description = "Prevents creation of networking features like VPCs, subnets, gateways, etc."
  content     = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyNetworkingResources",
      "Effect": "Deny",
      "Action": [
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
        "ec2:CreateCustomerGateway"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_organizations_policy_attachment" "attach_policy" {
  policy_id = aws_organizations_policy.deny_networking_features.id
  target_id = data.aws_organizations_organizational_units.existing_ou.organizational_units[0].id
}
