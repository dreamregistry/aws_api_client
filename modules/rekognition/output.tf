output "liveness_session_role_arn" {
  value = aws_iam_role.liveness_session.arn
}

output "policy" {
  value = data.aws_iam_policy_document.permissions.json
}
