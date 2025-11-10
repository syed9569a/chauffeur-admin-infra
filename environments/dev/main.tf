
module "secrets" {
  source       = "../../modules/secrets"
  project_name = var.project_name
  region       = var.region
  environment  = var.environment
  tags         = var.tags
  secret_kv    = var.secret_kv
}

module "backend" {
  source       = "../../modules/backend"
  project_name = var.project_name
  region       = var.region
  environment  = var.environment
  tags         = var.tags

  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids

  container_image = var.backend_image

  # Inject secrets from Secrets Manager into the container
  secret_arn = module.secrets.secrets_arn
  secret_env_map = {
    STRIPE_SECRET_KEY      = "STRIPE_SECRET_KEY"
    STRIPE_PUBLISHABLE_KEY = "STRIPE_PUBLISHABLE_KEY"
    CLERK_SECRET_KEY       = "CLERK_SECRET_KEY"
    CLERK_PUBLISHABLE_KEY  = "CLERK_PUBLISHABLE_KEY"
  }
}

module "frontend" {
  source       = "../../modules/frontend"
  project_name = var.project_name
  region       = var.region
  environment  = var.environment
  tags         = var.tags

  vpc_id             = var.vpc_id
  public_subnet_ids  = var.public_subnet_ids
  private_subnet_ids = var.private_subnet_ids

  container_image = var.frontend_image

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
