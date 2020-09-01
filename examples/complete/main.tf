provider "aws" {
  region = var.region
}

module "lb_s3_bucket" {
  source = "../../"

  enabled       = true
  namespace     = var.namespace
  stage         = var.stage
  name          = var.name
  acl           = var.acl
  attributes    = var.attributes
  force_destroy = var.force_destroy
}
