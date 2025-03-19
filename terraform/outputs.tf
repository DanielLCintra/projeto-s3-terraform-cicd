output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
  description = "Endpoint do site no S3"
}

output "bucket_name" {
  value       = local.bucket_id
  description = "Nome do bucket S3"
}

output "website_url" {
  value       = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
  description = "URL do site"
}