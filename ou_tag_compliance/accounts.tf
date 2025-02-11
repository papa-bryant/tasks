# Create new AWS accounts here
resource "aws_organizations_account" "new_account" {
  name      = "tag-compliance-test-account"  
  email     = "testemail@domain.com"  
  role_name = "clarivate_org_role" 
  
  # Prevent account removal from organization when destroying
  close_on_deletion = false

  # Parent OU ID from previous configuration
  parent_id = aws_organizations_organizational_unit.tag_compliant_ou.id

  tags = {
    Environment = "dev"
    Layer       = "services"
    Component   = "admin"
    Product     = "innovation"
  }
}

# Outputs
output "account_id" {
  value       = aws_organizations_account.new_account.id
  description = "ID of the newly created account"
}

output "account_arn" {
  value       = aws_organizations_account.new_account.arn
  description = "ARN of the newly created account"
}
