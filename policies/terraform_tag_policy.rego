package terraform.tag_policy

required_tags := {"environment", "owner"}

deny[msg] if {
  input.resource_type == "aws_s3_bucket"

  # Collect tags
  tags := object.get(input, "tags", {})

  # Determine missing tags
  missing := required_tags - {key | key := tags[_]}

  count(missing) > 0

  msg := sprintf("S3 bucket %s is missing required tags: %v", [input.name, missing])
}