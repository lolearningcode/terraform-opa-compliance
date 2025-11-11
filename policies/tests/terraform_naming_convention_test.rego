package terraform.naming_convention

# Test: Deny bucket without approved prefix
test_deny_bucket_without_prefix if {
    deny["S3 bucket 'my-random-bucket' must start with approved prefix: [\"dev-\", \"staging-\", \"prod-\"]"] with input as {
        "resource_changes": [{
            "address": "aws_s3_bucket.example",
            "type": "aws_s3_bucket",
            "change": {
                "after": {
                    "bucket": "my-random-bucket"
                }
            }
        }]
    }
}

# Test: Allow bucket with dev prefix
test_allow_dev_prefix if {
    count(deny) == 0 with input as {
        "resource_changes": [{
            "address": "aws_s3_bucket.example",
            "type": "aws_s3_bucket",
            "change": {
                "after": {
                    "bucket": "dev-my-app-bucket"
                }
            }
        }]
    }
}

# Test: Allow bucket with prod prefix
test_allow_prod_prefix if {
    count(deny) == 0 with input as {
        "resource_changes": [{
            "address": "aws_s3_bucket.example",
            "type": "aws_s3_bucket",
            "change": {
                "after": {
                    "bucket": "prod-application-data"
                }
            }
        }]
    }
}
