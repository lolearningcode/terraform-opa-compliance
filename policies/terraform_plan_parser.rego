package terraform

# Helper to extract S3 buckets from resource_changes
s3_buckets contains resource if {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket"
}

# Helper to extract S3 bucket encryption configurations
s3_encryption_configs contains resource if {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket_server_side_encryption_configuration"
}

# Extract bucket name from encryption config address
get_bucket_address_from_encryption(encryption_resource) := bucket_address if {
    # Extract bucket name from address like "aws_s3_bucket_server_side_encryption_configuration.example"
    bucket_address := replace(encryption_resource.address, "_server_side_encryption_configuration", "")
}

# Check if encryption is configured inline (old style)
has_encryption(resource) if {
    resource.change.after.server_side_encryption_configuration
    count(resource.change.after.server_side_encryption_configuration) > 0
}

# Check if encryption is configured as separate resource (new style)
has_encryption(bucket) if {
    encryption := s3_encryption_configs[_]
    bucket_address := get_bucket_address_from_encryption(encryption)
    bucket.address == bucket_address
}

# Get tags from resource
get_tags(resource) := tags if {
    tags := object.get(resource.change.after, "tags", {})
}

# Main deny rule for S3 encryption
deny contains msg if {
    bucket := s3_buckets[_]
    not has_encryption(bucket)
    msg := sprintf("S3 bucket '%s' does not have encryption enabled", [bucket.address])
}

# Deny rule for missing required tags
required_tags := {"environment", "owner"}

deny contains msg if {
    bucket := s3_buckets[_]
    tags := get_tags(bucket)
    missing := required_tags - {tag | tags[tag]}
    count(missing) > 0
    msg := sprintf("S3 bucket '%s' is missing required tags: %v", [bucket.address, missing])
}
