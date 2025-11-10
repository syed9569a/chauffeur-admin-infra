variable "region" {
  type        = string
  description = "Region where resources will be created."
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

variable "project_name" {
  type        = string
  description = "The name of the project."
}

variable "secret_name" {
  type        = string
  description = "Optional explicit name for the Secrets Manager secret."
  default     = null
}

variable "secret_kv" {
  type        = map(string)
  description = "Optional key/value map to store in secret JSON."
  default     = null
}

# Legacy individual variables (optional; allow empty defaults)
variable "stripe_secret_key" {
  type        = string
  description = "Stripe secret key."
  default     = ""
  sensitive   = true
}

variable "stripe_publishable_key" {
  type        = string
  description = "Stripe publishable key."
  default     = ""
  sensitive   = true
}

variable "clerk_secret_key" {
  type        = string
  description = "Clerk secret key."
  default     = ""
  sensitive   = true
}

variable "clerk_publishable_key" {
  type        = string
  description = "Clerk publishable key."
  default     = ""
  sensitive   = true
}

variable "supabase_db_url" {
  type        = string
  description = "Supabase database URL."
  default     = ""
  sensitive   = true
}

variable "supabase_db_password" {
  type        = string
  description = "Supabase database password."
  default     = ""
  sensitive   = true
}
