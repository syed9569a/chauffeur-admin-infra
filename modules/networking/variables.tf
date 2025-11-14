variable "region" {
  type        = string
  description = "AWS region"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging and naming"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/staging/prod)"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "az_count" {
  type        = number
  description = "Number of AZs to use (2-3 recommended)"
  default     = 2
}
