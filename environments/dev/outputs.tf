output "frontend_alb_dns" {
  description = "Public DNS of the frontend ALB"
  value       = module.frontend.alb_dns_name
}

output "backend_bucket_arn" {
  description = "ARN of the backend uploads bucket"
  value       = module.backend.bucket_arn
}

output "frontend_ecr_repository_url" {
  description = "ECR repository URL for frontend"
  value       = module.frontend.ecr_repository_url
}

output "backend_ecr_repository_url" {
  description = "ECR repository URL for backend"
  value       = module.backend.ecr_repository_url
}

output "frontend_task_role_arn" {
  description = "Frontend ECS task IAM role ARN"
  value       = module.frontend.task_role_arn
}

output "backend_task_role_arn" {
  description = "Backend ECS task IAM role ARN"
  value       = module.backend.bucket_arn
}
