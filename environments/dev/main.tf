module "networking" {
  source       = "../../modules/networking"
  project_name = var.project_name
  region       = var.region
  environment  = var.environment
  tags         = var.tags
}

module "backend" {
  source       = "../../modules/backend"
  project_name = var.project_name
  region       = var.region
  environment  = var.environment
  tags         = var.tags

  vpc_id            = module.networking.vpc_id
  vpc_cidr          = module.networking.vpc_cidr
  public_subnet_ids = module.networking.public_subnet_ids
  desired_count      = 0
  
  # S3 bucket now provided by separate s3 module
  bucket_arn = module.s3.bucket_arn
}

module "frontend" {
  source       = "../../modules/frontend"
  project_name = var.project_name
  region       = var.region
  environment  = var.environment
  tags         = var.tags

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids

  desired_count = 0

  # S3 bucket now provided by separate s3 module
  bucket_arn = module.s3.bucket_arn

  # Pass backend API URL to frontend for browser-side API calls
  environment_variables = {
    NEXT_PUBLIC_API_BASE_URL = "http://${module.backend.alb_dns_name}"
  }
}

module "s3" {
  source       = "../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  # S3 module needs both task role ARNs to grant permissions
  backend_task_role_arn  = module.backend.task_role_arn
  frontend_task_role_arn = module.frontend.task_role_arn
}
