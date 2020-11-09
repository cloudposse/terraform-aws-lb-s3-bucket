provider "aws" {
  region = var.region
}

module "lb_s3_bucket" {
  source = "../../"

  acl           = var.acl
  force_destroy = var.force_destroy

  context = module.this.context
}
