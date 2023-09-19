output "AWS_REGION" {
  value = data.aws_region.current.name
}

output "AWS_ACCESS_KEY_ID" {
  value = var.export_credentials ? aws_iam_access_key.client.0.id : null
}

output "AWS_SECRET_ACCESS_KEY" {
  value = var.export_credentials ? {
    type   = "ssm"
    key    = aws_ssm_parameter.secret_key.0.name
    region = data.aws_region.current.name
    arn    = aws_ssm_parameter.secret_key.0.arn
  } : null
}

output "IAM_POLICY_COGNITO_ADMIN_CLIENT" {
  value = contains(var.permissions, "cognito_admin") ? module.cognito_admin.0.policy : null
}
output "COGNITO_USER_IDS" {
  value = contains(var.permissions, "cognito_admin") ? module.cognito_admin.0.cognito_user_ids : null
}

output "USER_POOL_ID" {
  description = "The ID of the user pool"
  value       = contains(var.permissions, "cognito_admin") ? var.cognito_user_pool_id : null
}