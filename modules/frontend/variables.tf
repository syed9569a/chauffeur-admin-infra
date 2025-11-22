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

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for the ALB."
}

 

variable "container_image" {
  type        = string
  description = "Container image for the Next.js app (e.g., ECR repo URI:tag). If empty and create_ecr is true, the module uses the created ECR repo with :latest."
  default     = ""
}

variable "container_port" {
  type        = number
  description = "Container port exposed by the Next.js app."
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

variable "health_check_path" {
  type        = string
  description = "Health check path for the ALB target group."
  default     = "/"
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

variable "create_ecr" {
  type        = bool
  description = "Whether to create an ECR repository for this service."
  default     = true
}

variable "ecr_repository_name" {
  type        = string
  description = "Optional explicit name for the ECR repository. If not set, one is derived from project/environment."
  default     = null
}

variable "bucket_arn" {
  type        = string
  description = "ARN of the S3 uploads bucket for IAM policy configuration."
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables to inject into the container (e.g., NEXT_PUBLIC_API_BASE_URL)."
  default     = {}
}