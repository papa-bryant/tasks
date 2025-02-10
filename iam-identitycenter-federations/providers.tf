terraform {
  # backend "s3" {
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

### clarivate-identity-prod provider
provider "aws" {
  alias  = "clarivate-identity-prod"
  region = "us-west-2"

  assume_role {
    role_arn     = "arn:aws:iam::481665088530:role/cl/app/crossaccount/cloudopspipeline/cloudops-pipeline-identity-center-svc-role"
    session_name = "clarivate-identity-prod-session-pipeline"
  }
}

### clarivate-tools-prod provider
provider "aws" {
  alias  = "clarivate-tools-prod"
  region = "us-west-2"

  assume_role {
    role_arn     = "arn:aws:iam::773321882549:role/cl/app/crossaccount/cloudopspipeline/cloudops-pipeline-identity-center-svc-role"
    session_name = "clarivate-tools-prod-session-pipeline"
  }
}