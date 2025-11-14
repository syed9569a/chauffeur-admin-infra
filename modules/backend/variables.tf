variable "region" {
  type        = string
  description = "AWS region to deploy resources."
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where ECS and ALB will be deployed."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the internal ALB and ECS tasks."
}

variable "allowed_source_sg_ids" {
  type        = list(string)
  description = "Security group IDs allowed to access the backend ALB (e.g., frontend service SG)."
  default     = []
}

variable "container_image" {
  type        = string
  description = "Container image for the NestJS app (e.g., ECR repo URI:tag). If empty and create_ecr is true, the module uses the created ECR repo with :latest."
  default     = ""
}

variable "container_port" {
  type        = number
  description = "Container port exposed by the NestJS app."
  default     = 3000
}

variable "cpu" {
  type        = number
  description = "Task CPU units (e.g., 256, 512, 1024)."
  default     = 512
}

variable "memory" {
  type        = number
  description = "Task memory (MiB)."
  default     = 1024
}

variable "desired_count" {
  type        = number
  description = "Initial desired task count."
  default     = 0
}

variable "autoscaling_min_capacity" {
  type        = number
  description = "Minimum number of tasks for autoscaling."
  default     = 0
}

variable "autoscaling_max_capacity" {
  type        = number
  description = "Maximum number of tasks for autoscaling."
  default     = 10
}

variable "autoscaling_target_cpu" {
  type        = number
  description = "Target average CPU utilization percentage for scaling."
  default     = 60
}
variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs where the public ALB will be deployed."
}
variable "certificate_arn" {
  type        = string
  description = "Optional ACM certificate ARN for HTTPS listener. When null, falls back to HTTP only."
  default     = null
}
variable "enable_http_redirect" {
  type        = bool
  description = "If true and certificate_arn provided, create HTTP 80 listener redirecting to HTTPS 443."
  default     = true
}

// No secret_arn, secret_env_map or environment_vars are supported in this module.

variable "health_check_path" {
  type        = string
  description = "Health check path for the internal ALB target group."
  default     = "/health"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name for uploads. If not set, a name will be derived."
  default     = null
}

variable "allow_frontend_task_role_arns" {
  type        = list(string)
  description = "Optional list of frontend task role ARNs that should have direct S3 access (if you don't use presigned URLs)."
  default     = []
}

variable "create_ecr" {
  type        = bool
  description = "Whether to create an ECR repository for this backend service."
  default     = true
}

variable "ecr_repository_name" {
  type        = string
  description = "Optional explicit name for the backend ECR repository."
  default     = null
}

variable "wait_for_steady_state" {
  type        = bool
  description = "Whether Terraform should wait for the ECS service to reach a steady state during apply. Set false to avoid apply hanging if image is not yet available."
  default     = false
}

variable "enable_deployment_circuit_breaker" {
  type        = bool
  description = "Enable ECS deployment circuit breaker with automatic rollback to fail fast if tasks can't start (e.g., missing image)."
  default     = true
}
