package terraform.s3_versioning

# Require S3 buckets to have versioning enabled
deny contains msg if {
    bucket := input.resource_changes[_]
    bucket.type == "aws_s3_bucket"
    not has_versioning_enabled(bucket.address)
    msg := sprintf("S3 bucket '%s' does not have versioning enabled", [bucket.address])
}

# Check if versioning is enabled via separate resource
has_versioning_enabled(bucket_address) if {
    versioning := input.resource_changes[_]
    versioning.type == "aws_s3_bucket_versioning"
    contains(versioning.address, bucket_name_from_address(bucket_address))
    versioning.change.after.versioning_configuration[_].status == "Enabled"
}

# Extract bucket name from address (e.g., "aws_s3_bucket.example" -> "example")
bucket_name_from_address(address) := name if {
    parts := split(address, ".")
    name := parts[1]
}
