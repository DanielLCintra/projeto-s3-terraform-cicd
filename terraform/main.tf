provider "aws" {
  region = var.aws_region
}

# Bucket S3 para hospedagem de site estático
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  
  tags = {
    Name        = "Website Bucket"
    Environment = var.environment
  }
}

# Configuração para hospedagem de site
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id
  
  index_document {
    suffix = "index.html"
  }
  
  error_document {
    key = "error.html"
  }
}

# Torna o bucket público
resource "aws_s3_bucket_public_access_block" "website_public_access" {
  bucket = aws_s3_bucket.website.id
  
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política de permissão para acesso público aos arquivos do bucket
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id
  
  depends_on = [aws_s3_bucket_public_access_block.website_public_access]
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.website.arn}/*"
        ]
      }
    ]
  })
}

# Output para mostrar o endpoint do site
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
  description = "Endpoint do site no S3"
}
