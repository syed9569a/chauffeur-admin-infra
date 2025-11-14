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

variable "frontend_image" {
  type        = string
  description = "Optional: Frontend container image URI:tag. Leave empty to use the created ECR repo with :latest."
  default     = ""
}

variable "backend_image" {
  type        = string
  description = "Optional: Backend container image URI:tag. Leave empty to use the created ECR repo with :latest."
  default     = ""
}

variable "secret_kv" {
  type        = map(any)
  description = "Optional full map of secret data for Secrets Manager JSON. If null, module will fall back to legacy keys."
  default     = null
  sensitive   = true
}