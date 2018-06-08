data "aws_elb_service_account" "default" {}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.default.arn}"]
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
  source                 = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git?ref=tags/0.2.0"
  namespace              = "${var.namespace}"
  stage                  = "${var.stage}"
  name                   = "${var.name}"
  region                 = "${var.region}"
  acl                    = "${var.acl}"
  policy                 = "${data.aws_iam_policy_document.default.json}"
  force_destroy          = "${var.force_destroy}"
  versioning_enabled     = "true"
  lifecycle_rule_enabled = "false"
  delimiter              = "${var.delimiter}"
  attributes             = "${var.attributes}"
  tags                   = "${var.tags}"
  prefix                 = "${var.prefix}"
}
