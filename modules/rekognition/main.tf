terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }
}

data "aws_caller_identity" "current" {}

resource "random_pet" "role_name_suffix" {
  length    = 2
  separator = ""
}

resource "aws_iam_role" "liveness_session" {
  name = "LivenessSessionRole-${random_pet.role_name_suffix.id}"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "rekognition_policy" {
  name        = "RekognitionPolicy-${random_pet.role_name_suffix.id}"
  description = "Policy to allow rekognition StartFaceLivenessSession action"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "rekognition:StartFaceLivenessSession"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rekognition_attach" {
  role       = aws_iam_role.liveness_session.name
  policy_arn = aws_iam_policy.rekognition_policy.arn
}

data "aws_iam_policy_document" "permissions" {
  statement {
    effect  = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      aws_iam_role.liveness_session.arn
    ]
  }
  statement {
    effect  = "Allow"
    actions = [
      "rekognition:CreateFaceLivenessSession",
      "rekognition:GetFaceLivenessSessionResults",
      "rekognition:CompareFaces"
    ]
    resources = [
      "*"
    ]
  }
}
