package terraform.s3_encryption

# Deny rule for unencrypted S3 buckets
deny[msg] if {
  input.resource_type == "aws_s3_bucket"
  not input.encryption_enabled
  msg := sprintf("S3 bucket %s is not encrypted", [input.name])
}