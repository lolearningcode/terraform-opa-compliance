variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "example-compliant-bucket"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag value"
  type        = string
  default     = "cleohoward"
}

