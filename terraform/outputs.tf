output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
  description = "Endpoint do site no S3"
}

output "bucket_name" {
  value       = aws_s3_bucket.website.id
  description = "Nome do bucket S3"
}
