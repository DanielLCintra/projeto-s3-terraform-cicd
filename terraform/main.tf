provider "aws" {
  region = var.aws_region
}

# Usa try/catch para verificar se o bucket existe
locals {
  bucket_exists = can(jsondecode(data.aws_cli_command.check_bucket.result)["exists"])
  bucket_id     = var.bucket_name
}

# Usa AWS CLI para verificar se o bucket existe
data "aws_cli_command" "check_bucket" {
  lifecycle {
    postcondition {
      condition     = true
      error_message = "This will never fail"
    }
  }
  
  command = "s3api"
  
  arguments = {
    "head-bucket" = ""
  }
  
  query = "{ \"exists\": true }"
  
  cli_inputs = {
    "bucket" = var.bucket_name
  }
}

# Cria o bucket apenas se ele não existir
resource "aws_s3_bucket" "website" {
  count = local.bucket_exists ? 0 : 1
  
  bucket        = var.bucket_name
  force_destroy = true
  
  tags = {
    Name        = "Website Bucket"
    Environment = var.environment
  }
}

# Configuração para hospedagem de site
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = local.bucket_id
  
  index_document {
    suffix = "index.html"
  }
  
  error_document {
    key = "error.html"
  }
}

# Torna o bucket público
resource "aws_s3_bucket_public_access_block" "website_public_access" {
  bucket = local.bucket_id
  
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política de permissão para acesso público aos arquivos do bucket
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = local.bucket_id
  
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
          "arn:aws:s3:::${local.bucket_id}/*"
        ]
      }
    ]
  })
}

# Configuração de CORS (opcional)
resource "aws_s3_bucket_cors_configuration" "website_cors" {
  bucket = local.bucket_id
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}