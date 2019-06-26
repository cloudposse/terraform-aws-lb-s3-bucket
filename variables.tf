variable "namespace" {
  type        = string
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = ""
}

variable "name" {
  type        = string
  description = "Name  (e.g. `app` or `cluster`)"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `logs`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to `false` to prevent the module from creating any resources"
}

variable "acl" {
  type        = string
  description = "Canned ACL to apply to the S3 bucket"
  default     = "log-delivery-write"
}

variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

variable "force_destroy" {
  type        = bool
  description = "A boolean that indicates the bucket can be destroyed even if it contains objects. These objects are not recoverable"
  default     = false
}

variable "prefix" {
  type        = string
  description = "The S3 bucket prefix for the AWSLogs"
  default     = ""
}
