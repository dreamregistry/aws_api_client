terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "permissions" {
  statement {
    effect  = "Allow"
    actions = [
      "cognito-idp:List*",
      "cognito-idp:Describe*",
      "cognito-idp:Get*",
      "cognito-idp:Admin*"
    ]
    resources = [
      "arn:aws:cognito-idp:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:userpool/${var.cognito_user_pool_id}"
    ]
  }
}

resource "aws_cognito_user" "default" {
  count        = length(var.cognito_users)
  user_pool_id = var.cognito_user_pool_id
  username     = var.cognito_users[count.index].email
  attributes   = {
    email = var.cognito_users[count.index].email
    name  = var.cognito_users[count.index].name
  }
}
