output "alb_dns_name" {
  description = "DNS name of the backend Application Load Balancer."
  value       = aws_lb.this.dns_name
}

output "ecr_repository_url" {
  description = "URL of the created ECR repository (if created)."
  value       = length(aws_ecr_repository.this) > 0 ? aws_ecr_repository.this[0].repository_url : null
}

output "task_role_arn" {
  description = "ARN of the backend ECS task IAM role."
  value       = aws_iam_role.task.arn
}
