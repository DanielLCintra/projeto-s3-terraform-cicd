output "bucket_name" {
  value       = aws_s3_bucket.website.id
  description = "Nome do bucket S3"
}
