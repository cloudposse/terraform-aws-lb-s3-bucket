locals {
  enabled              = module.this.enabled
  generate_bucket_name = local.enabled && try(length(var.bucket_name) == 0, true) # Use `try` to handle `null` value
  bucket_name          = local.generate_bucket_name ? module.bucket_name.id : var.bucket_name

  # The `aws_elb_service_account` data source only knows the Regions that have a legacy
  # Elastic Load Balancing account, and fails with "unsupported ELB Service Account Region"
  # everywhere else. Regions opened since August 2022 (e.g. il-central-1, me-central-1,
  # ap-southeast-4) only support the `logdelivery.elasticloadbalancing.amazonaws.com`
  # service principal.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy
  elb_legacy_account_regions = [
    "af-south-1", "ap-east-1", "ap-northeast-1", "ap-northeast-2", "ap-northeast-3",
    "ap-south-1", "ap-southeast-1", "ap-southeast-2", "ap-southeast-3", "ca-central-1",
    "cn-north-1", "cn-northwest-1", "eu-central-1", "eu-north-1", "eu-south-1",
    "eu-west-1", "eu-west-2", "eu-west-3", "me-south-1", "sa-east-1",
    "us-east-1", "us-east-2", "us-gov-east-1", "us-gov-west-1", "us-west-1", "us-west-2",
  ]
  # Read the Region from the EC2 endpoint (`ec2.<region>.amazonaws.com[.cn]`), which is not
  # deprecated in any supported AWS provider version (`name` and `id` are deprecated in v6).
  region                      = local.enabled ? split(".", one(data.aws_region.current[*].endpoint))[1] : null
  elb_legacy_account_enabled  = local.enabled && contains(local.elb_legacy_account_regions, coalesce(local.region, "none"))
  elb_service_principal_names = local.elb_legacy_account_enabled ? [] : ["logdelivery.elasticloadbalancing.amazonaws.com"]
}

data "aws_region" "current" {
  count = local.enabled ? 1 : 0
}

module "bucket_name" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.generate_bucket_name

  id_length_limit = 63 # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html

  context = module.this.context
}

data "aws_elb_service_account" "default" {
  count = local.elb_legacy_account_enabled ? 1 : 0
}

data "aws_iam_policy_document" "default" {
  count = module.this.enabled ? 1 : 0

  dynamic "statement" {
    for_each = local.elb_legacy_account_enabled ? [1] : []

    content {
      sid = ""
      principals {
        type        = "AWS"
        identifiers = [join("", data.aws_elb_service_account.default[*].arn)]
      }
      effect = "Allow"
      actions = [
        "s3:PutObject"
      ]
      resources = [
        "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/*",
      ]
    }
  }

  dynamic "statement" {
    for_each = local.elb_service_principal_names

    content {
      sid = ""
      principals {
        type        = "Service"
        identifiers = [statement.value]
      }
      effect = "Allow"
      actions = [
        "s3:PutObject"
      ]
      resources = [
        "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/*",
      ]
    }
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
  version = "1.4.3"

  acl                           = var.acl
  bucket_name                   = var.bucket_name
  source_policy_documents       = [join("", data.aws_iam_policy_document.default[*].json)]
  force_destroy                 = var.force_destroy
  versioning_enabled            = var.versioning_enabled
  allow_ssl_requests_only       = var.allow_ssl_requests_only
  access_log_bucket_name        = var.access_log_bucket_name
  access_log_bucket_prefix      = var.access_log_bucket_prefix
  lifecycle_configuration_rules = var.lifecycle_configuration_rules
  s3_object_ownership           = var.s3_object_ownership

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
