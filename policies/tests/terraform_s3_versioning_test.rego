package terraform.s3_versioning

# Test: Deny bucket without versioning
test_deny_bucket_without_versioning if {
    count(deny) > 0 with input as {
        "resource_changes": [{
            "address": "aws_s3_bucket.example",
            "type": "aws_s3_bucket",
            "change": {
                "after": {
                    "bucket": "my-bucket"
                }
            }
        }]
    }
}

# Test: Allow bucket with versioning enabled
test_allow_bucket_with_versioning if {
    count(deny) == 0 with input as {
        "resource_changes": [
            {
                "address": "aws_s3_bucket.example",
                "type": "aws_s3_bucket",
                "change": {
                    "after": {
                        "bucket": "my-bucket"
                    }
                }
            },
            {
                "address": "aws_s3_bucket_versioning.example",
                "type": "aws_s3_bucket_versioning",
                "change": {
                    "after": {
                        "versioning_configuration": [{
                            "status": "Enabled"
                        }]
                    }
                }
            }
        ]
    }
}
