provider "aws" {
  region = var.region
}

module "lb_s3_bucket" {
  source = "../../"

  enabled       = true
  region        = var.region
  namespace     = var.namespace
  stage         = var.stage
  name          = var.name
  acl           = var.acl
  force_destroy = var.force_destroy
}
