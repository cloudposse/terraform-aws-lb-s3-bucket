output "bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = module.s3_bucket.bucket_domain_name
}

output "bucket_id" {
  description = "S3 bucket ID"
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3_bucket.bucket_arn
}

output "bucket_prefix" {
  description = "S3 bucket prefix"
  value       = module.s3_bucket.prefix
}
