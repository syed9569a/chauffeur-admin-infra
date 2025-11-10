output "bucket_arn" {
  description = "Uploads S3 bucket ARN."
  value       = aws_s3_bucket.uploads.arn
}

output "ecr_repository_url" {
  description = "URL of the created ECR repository (if created)."
  value       = length(aws_ecr_repository.this) > 0 ? aws_ecr_repository.this[0].repository_url : null
}
