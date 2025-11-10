locals {
  default_secret_name = "${var.project_name}/${var.region}/${var.environment}/app-secrets"

  legacy_secret_map = {
    STRIPE_SECRET_KEY      = var.stripe_secret_key
    STRIPE_PUBLISHABLE_KEY = var.stripe_publishable_key
    CLERK_SECRET_KEY       = var.clerk_secret_key
    CLERK_PUBLISHABLE_KEY  = var.clerk_publishable_key
  }

  final_secret_map = var.secret_kv != null && length(var.secret_kv) > 0 ? var.secret_kv : local.legacy_secret_map
}

resource "aws_secretsmanager_secret" "app_secrets" {
  name = coalesce(var.secret_name, local.default_secret_name)
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "app_secrets_version" {
  secret_id     = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode(local.final_secret_map)
}
