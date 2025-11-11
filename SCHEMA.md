# Terraform Plan Input Schema for OPA Policies

This document describes the expected input schema for OPA policies that evaluate Terraform plans.

## Overview

OPA policies receive Terraform plan JSON as input. The policies extract relevant resource information and evaluate compliance rules.

## Input Structure

The Terraform plan JSON contains a complex structure. For our policies, we extract simplified resource information:

### S3 Bucket Resource Schema

```json
{
  "resource_type": "aws_s3_bucket",
  "name": "example-bucket",
  "tags": {
    "environment": "dev",
    "owner": "cleohoward"
  },
  "encryption_enabled": true
}
```

### Field Descriptions

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `resource_type` | string | The Terraform resource type (e.g., "aws_s3_bucket") | Yes |
| `name` | string | The resource name/identifier | Yes |
| `tags` | object | Key-value pairs of resource tags | No |
| `encryption_enabled` | boolean | Whether server-side encryption is enabled | No |

## Policy Expectations

### terraform_s3_encryption.rego

- Expects: `resource_type == "aws_s3_bucket"`
- Checks: `encryption_enabled == true`
- Denies: Resources where encryption is not enabled

### terraform_tag_policy.rego

- Expects: `resource_type == "aws_s3_bucket"`
- Checks: Presence of required tags (`environment`, `owner`)
- Denies: Resources missing required tags

## Terraform Plan JSON Structure

The raw Terraform plan JSON has the following high-level structure:

```json
{
  "format_version": "1.0",
  "terraform_version": "...",
  "planned_values": {
    "root_module": {
      "resources": [...]
    }
  },
  "resource_changes": [...],
  "configuration": {...}
}
```

Policies typically extract information from `resource_changes` or `planned_values.root_module.resources` to build the simplified schema above.

