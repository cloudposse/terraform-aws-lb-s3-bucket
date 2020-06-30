data "aws_elb_service_account" "default" {
  count = var.enabled ? 1 : 0
}

module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled     = var.enabled
  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
}

data "aws_iam_policy_document" "default" {
  count = var.enabled ? 1 : 0

  statement {
    sid = ""

    principals {
      type        = "AWS"
      identifiers = [join("", data.aws_elb_service_account.default.*.arn)]
    }

    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${module.label.id}/*",
    ]
  }
}

module "s3_bucket" {
  source                             = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git?ref=tags/0.11.0"
  enabled                            = var.enabled
  namespace                          = var.namespace
  stage                              = var.stage
  environment                        = var.environment
  name                               = var.name
  region                             = var.region
  acl                                = var.acl
  policy                             = join("", data.aws_iam_policy_document.default.*.json)
  force_destroy                      = var.force_destroy
  versioning_enabled                 = true
  lifecycle_rule_enabled             = var.lifecycle_rule_enabled
  enable_glacier_transition          = var.enable_glacier_transition
  expiration_days                    = var.expiration_days
  glacier_transition_days            = var.glacier_transition_days
  noncurrent_version_expiration_days = var.noncurrent_version_expiration_days
  noncurrent_version_transition_days = var.noncurrent_version_transition_days
  standard_transition_days           = var.standard_transition_days
  delimiter                          = var.delimiter
  attributes                         = var.attributes
  tags                               = var.tags
  lifecycle_prefix                   = var.lifecycle_prefix
}
