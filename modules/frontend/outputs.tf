output "alb_dns_name" {
  description = "DNS name of the public Application Load Balancer."
  value       = aws_lb.this.dns_name
}

output "alb_security_group_id" {
  description = "Security group ID of the ALB."
  value       = aws_security_group.alb.id
}

output "service_security_group_id" {
  description = "Security group ID attached to ECS tasks."
  value       = aws_security_group.service.id
}

output "cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.this.name
}

output "service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.this.name
}

output "task_role_arn" {
  description = "IAM role ARN assumed by the task."
  value       = aws_iam_role.task.arn
}

output "ecr_repository_url" {
  description = "URL of the created ECR repository (if created)."
  value       = length(aws_ecr_repository.this) > 0 ? aws_ecr_repository.this[0].repository_url : null
}
