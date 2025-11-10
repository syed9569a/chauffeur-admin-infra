terraform {
  backend "s3" {
    bucket       = "chauffeur-admin-infra-tfstate"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
