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

resource "random_pet" "user_name" {
  length    = 2
  separator = "-"
}

resource "aws_iam_user" "client" {
  count = var.export_credentials ? 1 : 0
  name  = random_pet.user_name.id
}

resource "aws_iam_access_key" "client" {
  count = var.export_credentials ? 1 : 0
  user  = aws_iam_user.client.0.name
}

resource "aws_ssm_parameter" "secret_key" {
  count = var.export_credentials ? 1 : 0
  name  = "/cognito_admin_client/${aws_iam_user.client.0.name}/secret_key"
  type  = "SecureString"
  value = aws_iam_access_key.client.0.secret
}

module "cognito_admin" {
  source               = "./modules/cognito_admin"
  count                = contains(var.permissions, "cognito_admin") ? 1 : 0
  cognito_user_pool_id = var.cognito_user_pool_id
  cognito_users        = var.cognito_users
}

resource "aws_iam_user_policy" "cognito_admin" {
  count  = contains(var.permissions, "cognito_admin") && var.export_credentials ? 1 : 0
  user   = aws_iam_user.client.0.name
  policy = module.cognito_admin.0.policy
}

module "location_api" {
  source               = "./modules/location_api"
  count                = contains(var.permissions, "location_api") ? 1 : 0
  place_location_index = var.place_location_index
}

resource "aws_iam_user_policy" "location_api" {
  count  = contains(var.permissions, "location_api") && var.export_credentials ? 1 : 0
  user   = aws_iam_user.client.0.name
  policy = module.location_api.0.policy
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
  count  = contains(var.permissions, "s3_bucket") ? 1 : 0
  name_prefix = var.s3_bucket_name_prefix
}

resource "aws_iam_user_policy" "s3_bucket" {
  count  = contains(var.permissions, "s3_bucket") && var.export_credentials ? 1 : 0
  user   = aws_iam_user.client.0.name
  policy = module.s3_bucket.0.policy
}
