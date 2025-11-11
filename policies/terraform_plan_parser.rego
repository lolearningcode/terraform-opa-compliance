package terraform

# Helper to extract S3 buckets from resource_changes
s3_buckets contains resource if {
    resource := input.resource_changes[_]
    resource.type == "aws_s3_bucket"
}

# Check if encryption is configured in resource_changes
has_encryption(resource) if {
    resource.change.after.server_side_encryption_configuration
    count(resource.change.after.server_side_encryption_configuration) > 0
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
