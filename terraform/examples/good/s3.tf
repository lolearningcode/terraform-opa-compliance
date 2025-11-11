resource "aws_s3_bucket" "secure_bucket" {
  bucket = "secure-bucket-example"
  tags = {
    environment = "prod"
    owner       = "DevOpsTeam"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
