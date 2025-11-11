package terraform.naming_convention

# Approved environment prefixes
approved_prefixes := ["dev-", "staging-", "prod-"]

# Enforce naming convention for S3 buckets
deny contains msg if {
    bucket := input.resource_changes[_]
    bucket.type == "aws_s3_bucket"
    bucket_name := bucket.change.after.bucket
    not starts_with_approved_prefix(bucket_name)
    msg := sprintf("S3 bucket '%s' must start with approved prefix: %v", [bucket_name, approved_prefixes])
}

# Check if name starts with any approved prefix
starts_with_approved_prefix(name) if {
    some prefix in approved_prefixes
    startswith(name, prefix)
}