# Terraform module that manages the resources related to Identity Center in the clarivate-identity-prod account
module "identity_center_directory" {
  count  = data.aws_caller_identity.current.account_id == "481665088530" ? 1 : 0
  source = "./identity_center_directory"

  providers = {
    aws                         = aws
    aws.clarivate-tools-prod    = aws.clarivate-tools-prod
    aws.clarivate-identity-prod = aws.clarivate-identity-prod
  }
}