output "bucket_arn" {
  description = "ARN of the uploads S3 bucket."
  value       = aws_s3_bucket.uploads.arn
}

output "bucket_name" {
  description = "Name of the uploads S3 bucket."
  value       = aws_s3_bucket.uploads.id
}
