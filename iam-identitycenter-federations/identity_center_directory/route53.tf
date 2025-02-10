###############################################################################
### aws.clarivate.net Route53 public zone and DNS record for SSO login page ###
###############################################################################
data "aws_route53_zone" "public_zone" {
  provider     = aws.clarivate-tools-prod
  name         = "clarivate.io."
  private_zone = false
}
resource "aws_route53_record" "aws_sso_dns" {
  provider = aws.clarivate-tools-prod
  zone_id  = data.aws_route53_zone.public_zone.zone_id
  name     = "aws.clarivate.io"
  type     = "CNAME"
  ttl      = 60
  records  = [aws_s3_bucket_website_configuration.redirection_bucket.website_endpoint]
}