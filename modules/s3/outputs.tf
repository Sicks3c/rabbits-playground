output "static_content_bucket_id" {
  description = "Static content bucket ID"
  value       = aws_s3_bucket.static_content.id
}

output "static_content_bucket_arn" {
  description = "Static content bucket ARN"
  value       = aws_s3_bucket.static_content.arn
}

output "static_content_bucket_regional_domain_name" {
  description = "Static content bucket regional domain name"
  value       = aws_s3_bucket.static_content.bucket_regional_domain_name
}

output "user_content_bucket_id" {
  description = "User content bucket ID"
  value       = aws_s3_bucket.user_content.id
}

output "user_content_bucket_arn" {
  description = "User content bucket ARN"
  value       = aws_s3_bucket.user_content.arn
}

output "user_content_bucket_regional_domain_name" {
  description = "User content bucket regional domain name"
  value       = aws_s3_bucket.user_content.bucket_regional_domain_name
}

output "cloudfront_oai_id" {
  description = "CloudFront Origin Access Identity ID"
  value       = aws_cloudfront_origin_access_identity.static_content.id
}

output "cloudfront_oai_path" {
  description = "CloudFront Origin Access Identity path"
  value       = aws_cloudfront_origin_access_identity.static_content.cloudfront_access_identity_path
}
