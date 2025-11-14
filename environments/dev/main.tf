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
  desired_count      = 0
  # Backend runs without runtime secrets; no secret ARN or env mapping provided
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

  # Inject secrets from Secrets Manager into the container
  secret_arn = module.secrets.secrets_arn
  secret_env_map = {
    STRIPE_SECRET_KEY      = "STRIPE_SECRET_KEY"
    STRIPE_PUBLISHABLE_KEY = "STRIPE_PUBLISHABLE_KEY"
    CLERK_SECRET_KEY       = "CLERK_SECRET_KEY"
    CLERK_PUBLISHABLE_KEY  = "CLERK_PUBLISHABLE_KEY"
  }

  # Optionally grant the frontend task role permission to write to backend's S3 bucket
  # bucket_arn = module.backend.bucket_arn
}
