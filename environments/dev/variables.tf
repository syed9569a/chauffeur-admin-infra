variable "project_name" {
  type        = string
  description = "The name of the project."
  default     = "chauffeur-admin"
}

variable "region" {
  type        = string
  description = "AWS region for deployment."
  default     = "eu-west-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default = {
    Project     = "chauffeur-admin"
    Environment = "dev"
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for ECS services."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for frontend ALB."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for ECS tasks and internal backend ALB."
}

variable "frontend_image" {
  type        = string
  description = "Frontend container image URI:tag."
}

variable "backend_image" {
  type        = string
  description = "Backend container image URI:tag."
}

variable "secret_kv" {
  type        = map(string)
  description = "Optional full map of secret data for Secrets Manager JSON."
  default     = {}
  sensitive   = true
}