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

variable "bucket_name" {
  type        = string
  description = "S3 bucket name for uploads. If not set, a name will be derived."
  default     = null
}

variable "backend_task_role_arn" {
  type        = string
  description = "Backend ECS task role ARN that needs S3 access."
}

variable "frontend_task_role_arn" {
  type        = string
  description = "Frontend ECS task role ARN that needs S3 access."
}
