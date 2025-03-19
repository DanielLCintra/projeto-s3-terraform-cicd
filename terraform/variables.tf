variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3 para hospedar o site"
  type        = string
  default     = "site-estatico-s3-daniel"
}

variable "environment" {
  description = "Ambiente (ex: development, production)"
  type        = string
  default     = "production"
}