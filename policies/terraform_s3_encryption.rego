package terraform.s3_encryption

deny[msg] if {
  input.resource_type == "aws_s3_bucket"
  not input.encryption_enabled
  msg := sprintf("S3 bucket %s is not encrypted", [input.name])
}
