output "frontend_alb_dns" {
  description = "Public DNS of the frontend ALB"
  value       = module.frontend.alb_dns_name
}

output "backend_alb_dns" {
  description = "Public DNS of the backend ALB"
  value       = module.backend.alb_dns_name
}

output "backend_bucket_arn" {
  description = "ARN of the uploads bucket"
  value       = module.s3.bucket_arn
}

output "backend_bucket_name" {
  description = "Name of the uploads bucket"
  value       = module.s3.bucket_name
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
  value       = module.backend.task_role_arn
}
