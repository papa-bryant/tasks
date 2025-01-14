provider "aws" {
  region = "us-east-1" # Adjust to your preferred region
}
# Get the root ID
data "aws_organizations_organization" "existing" {}

output "root_id" {
  value = data.aws_organizations_organization.existing.roots[0].id
}

# Get all OUs under root
data "aws_organizations_organizational_units" "all_ous" {
  parent_id = data.aws_organizations_organization.existing.roots[0].id
}

# Output complete OU information
output "all_ous_raw" {
  value = data.aws_organizations_organizational_units.all_ous
}

# List all OU names and IDs
output "ou_details" {
  value = [
    for ou in data.aws_organizations_organizational_units.all_ous.children : {
      name = ou.name
      id   = ou.id
      arn  = ou.arn
    }
  ]
}

# If you suspect the OU might be nested, add this data source
data "aws_organizations_organizational_units" "nested_ous" {
  for_each = {
    for ou in data.aws_organizations_organizational_units.all_ous.children : ou.id => ou
  }
  parent_id = each.value.id
}

output "nested_ous" {
  value = data.aws_organizations_organizational_units.nested_ous
}