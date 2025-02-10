### AWS IAM Identity Center Instance
data "aws_ssoadmin_instances" "instance" {
  provider = aws.clarivate-identity-prod
}