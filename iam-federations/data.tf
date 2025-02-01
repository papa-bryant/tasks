data "aws_caller_identity" "current" {}

######################
# AWS Managed Policies
######################

# data resources
data "aws_iam_policy" "AmazonRedshiftDataFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonRedshiftDataFullAccess"
}

data "aws_iam_policy" "AmazonRedshiftQueryEditor" {
  arn = "arn:aws:iam::aws:policy/AmazonRedshiftQueryEditor"
}

data "aws_iam_policy" "AmazonRedshiftQueryEditorV2ReadWriteSharing" {
  arn = "arn:aws:iam::aws:policy/AmazonRedshiftQueryEditorV2ReadWriteSharing"
}

data "aws_iam_policy" "AWSDataExchangeProviderFullAccess" {
  arn = "arn:aws:iam::aws:policy/AWSDataExchangeProviderFullAccess"
}

data "aws_iam_policy" "AWSTransferFullAccess" {
  arn = "arn:aws:iam::aws:policy/AWSTransferFullAccess"
}

data "aws_iam_policy" "AwsGlueDataBrewFullAccessPolicy" {
  arn = "arn:aws:iam::aws:policy/AwsGlueDataBrewFullAccessPolicy"
}

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy" "singularity-developer-remote-policy" {
  count = var.account-sing-dev == data.aws_caller_identity.current.account_id ? 1 : 0
  arn = "arn:aws:iam::807485099697:policy/singularity-developer-remote-policy"
}

data "aws_iam_policy" "BedrockReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonBedrockReadOnly"
}

data "aws_iam_policy" "BedrockFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "PowerUserAccess" {
  arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

