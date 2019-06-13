variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = "string"
  description = "Name  (e.g. `app` or `cluster`)"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `logs`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "acl" {
  type        = "string"
  description = "Canned ACL to apply to the S3 bucket"
  default     = "log-delivery-write"
}

variable "region" {
  type        = "string"
  default     = "us-east-1"
  description = "AWS Region for S3 bucket"
}

variable "force_destroy" {
  type        = "string"
  description = "A boolean that indicates the bucket can be destroyed even if it contains objects. These objects are not recoverable"
  default     = "false"
}

variable "prefix" {
  type        = "string"
  description = "The S3 bucket prefix for the AWSLogs"
  default     = ""
}

variable "enabled" {
  description = "Set to `false` to prevent the module from creating any resources"
  default     = true
}
