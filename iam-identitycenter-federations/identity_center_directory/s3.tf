############################################################################################
### Redirection bucket to redirect sso.aws.clarivate.net ###
############################################################################################
resource "aws_s3_bucket" "redirection_bucket" {
  provider = aws.clarivate-tools-prod
  bucket   = "aws.clarivate.io"

  tags = {
    Name        = "aws.clarivate.io"
    Product     = "Shared Services"
    Layer       = "s3"
    Component   = "redirect-website"
    Environment = "prod"
    "ca:owner"  = "ssh://git@git.clarivate.io/cloudeng/iam-identitycenter-federation.git"
  }
}

resource "aws_s3_bucket_website_configuration" "redirection_bucket" {
  provider = aws.clarivate-tools-prod
  bucket   = aws_s3_bucket.redirection_bucket.id

  index_document {
    suffix = "index.html"
  }

  routing_rule {
    redirect {
      host_name               = "clarivate-aws-sso.awsapps.com"
      http_redirect_code      = "301"
      protocol                = "https"
      replace_key_prefix_with = "start"
    }
  }
}