output "bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.bucket
}

output "policy" {
  value = data.aws_iam_policy_document.permissions.json
}
