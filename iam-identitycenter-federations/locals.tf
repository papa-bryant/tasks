locals {
  raw_manifest      = yamldecode(file("component_manifest.yaml"))
  full_account_name = local.raw_manifest["account-name"]
  account_id        = data.aws_caller_identity.current.account_id
}