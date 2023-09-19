terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "permissions" {
  statement {
    effect  = "Allow"
    actions = [
      "geo:SearchPlaceIndexForSuggestions",
      "geo:SearchPlaceIndexForText",
      "geo:GetPlace"
    ]
    resources = [
      "arn:aws:geo:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:place-index/${var.place_location_index}"
    ]
  }
}