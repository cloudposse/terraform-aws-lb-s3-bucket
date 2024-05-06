locals {
  enabled              = module.this.enabled
  generate_bucket_name = local.enabled && try(length(var.bucket_name) == 0, true) # Use `try` to handle `null` value
  bucket_name          = local.generate_bucket_name ? module.bucket_name.id : var.bucket_name
}

module "bucket_name" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.generate_bucket_name

  id_length_limit = 63 # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html

  context = module.this.context
}

data "aws_elb_service_account" "default" {
  count = module.this.enabled ? 1 : 0
}

data "aws_iam_policy_document" "default" {
  count = module.this.enabled ? 1 : 0

  statement {
    sid = ""
    principals {
      type        = "AWS"
      identifiers = [join("", data.aws_elb_service_account.default.*.arn)]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/*",
    ]
  }

  statement {
    sid = ""
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}",
    ]
  }
}

data "aws_partition" "current" {}

module "s3_bucket" {
  source  = "cloudposse/s3-log-storage/aws"
  version = "1.4.2"

  acl                           = var.acl
  bucket_name                   = var.bucket_name
  source_policy_documents       = [join("", data.aws_iam_policy_document.default.*.json)]
  force_destroy                 = var.force_destroy
  versioning_enabled            = var.versioning_enabled
  allow_ssl_requests_only       = var.allow_ssl_requests_only
  access_log_bucket_name        = var.access_log_bucket_name
  access_log_bucket_prefix      = var.access_log_bucket_prefix
  lifecycle_configuration_rules = var.lifecycle_configuration_rules

  # TODO: deprecate these inputs in favor of `lifecycle_configuration_rules`
  lifecycle_rule_enabled             = var.lifecycle_rule_enabled
  enable_glacier_transition          = var.enable_glacier_transition
  expiration_days                    = var.expiration_days
  glacier_transition_days            = var.glacier_transition_days
  noncurrent_version_expiration_days = var.noncurrent_version_expiration_days
  noncurrent_version_transition_days = var.noncurrent_version_transition_days
  standard_transition_days           = var.standard_transition_days
  lifecycle_prefix                   = var.lifecycle_prefix

  context = module.this.context
}
