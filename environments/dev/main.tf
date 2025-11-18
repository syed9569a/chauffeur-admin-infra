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

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids  = module.networking.public_subnet_ids
  desired_count      = 1
  
  # Allow frontend task role to access S3 bucket
  allow_frontend_task_role_arns = [module.frontend.task_role_arn]
}

module "frontend" {
  source       = "../../modules/frontend"
  project_name = var.project_name
  region       = var.region
  environment  = var.environment
  tags         = var.tags

  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids

  desired_count = 0

  # Optionally grant the frontend task role permission to write to backend's S3 bucket
  bucket_arn = module.backend.bucket_arn
}
