variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = string
  description = "Name  (e.g. `app` or `cluster`)"
}

variable "attributes" {
  default = []
  type    = list(string)
}

variable "acl" {
  type        = string
  description = "Canned ACL to apply to the S3 bucket"
}

variable "force_destroy" {
  type        = bool
  description = "A boolean that indicates the bucket can be destroyed even if it contains objects. These objects are not recoverable"
}
