variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

variable "acl" {
  type        = string
  description = "Canned ACL to apply to the S3 bucket"
}

variable "force_destroy" {
  type        = bool
  description = "A boolean that indicates the bucket can be destroyed even if it contains objects. These objects are not recoverable"
}
