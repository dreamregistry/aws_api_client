output "policy" {
  description = "The IAM policy for location service"
  value       = data.aws_iam_policy_document.permissions.json
}

output "place_location_index" {
  description = "The place location index"
  value       = var.place_location_index
}
