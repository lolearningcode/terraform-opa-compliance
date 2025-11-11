package terraform.s3_encryption

test_deny_when_unencrypted if {
  test_input := {"resource_type": "aws_s3_bucket", "name": "bad-bucket", "encryption_enabled": false}
  results := deny with input as test_input
  count(results) == 1
}

test_allow_when_encrypted if {
  test_input := {"resource_type": "aws_s3_bucket", "name": "good-bucket", "encryption_enabled": true}
  results := deny with input as test_input
  count(results) == 0
}
