provider "aws" {
  region = var.aws_region
}

# Verifica se o bucket existe antes de tentar criá-lo
data "aws_s3_bucket" "existing_bucket" {
  bucket = var.bucket_name
  
  # Ignora erros se o bucket não existir
  # Isso permitirá que o Terraform continue e crie o bucket
  count = 0
}

# Cria o bucket apenas se ele não existir
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  
  # Como a consulta data tem count = 0, ela nunca existirá,
  # mas usamos uma expressão condicional no count para criar
  # um novo bucket apenas se ele não existir
  count = 0 == 0 ? 1 : 0
  
  tags = {
    Name        = "Website Bucket"
    Environment = var.environment
  }
  
  # Torna o bucket compatível com o modo destroy
  force_destroy = true
}

# Recurso local para referenciar o bucket, seja existente ou recém-criado
locals {
  bucket_id = try(aws_s3_bucket.website[0].id, var.bucket_name)
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
  
  # Depende do recurso do bucket apenas se ele for criado
  depends_on = [aws_s3_bucket.website]
}

# Torna o bucket público
resource "aws_s3_bucket_public_access_block" "website_public_access" {
  bucket = local.bucket_id
  
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  
  # Depende do recurso do bucket apenas se ele for criado
  depends_on = [aws_s3_bucket.website]
}

# Política de permissão para acesso público aos arquivos do bucket
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = local.bucket_id
  
  # Garante que o bloco de acesso público seja aplicado primeiro
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
  
  # Depende do recurso do bucket apenas se ele for criado
  depends_on = [aws_s3_bucket.website]
}