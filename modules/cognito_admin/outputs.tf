output "policy" {
  description = "The IAM policy document for cognito admin access."
  value = data.aws_iam_policy_document.permissions.json
}

output "cognito_user_ids" {
  value = join(",", aws_cognito_user.default.*.id)
}
