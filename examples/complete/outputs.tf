output "bucket_domain_name" {
  value       = module.lb_s3_bucket.bucket_domain_name
  description = "FQDN of bucket"
}

output "bucket_id" {
  value       = module.lb_s3_bucket.bucket_id
  description = "Bucket Name (aka ID)"
}

output "bucket_arn" {
  value       = module.lb_s3_bucket.bucket_arn
  description = "Bucket ARN"
}
