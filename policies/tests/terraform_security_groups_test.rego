package terraform.security_groups

# Test: Deny open security group rule
test_deny_open_security_group if {
    deny["Security group rule 'aws_security_group_rule.allow_all' allows unrestricted access (0.0.0.0/0)"] with input as {
        "resource_changes": [{
            "address": "aws_security_group_rule.allow_all",
            "type": "aws_security_group_rule",
            "change": {
                "after": {
                    "cidr_blocks": ["0.0.0.0/0"]
                }
            }
        }]
    }
}

# Test: Allow restricted security group rule
test_allow_restricted_security_group if {
    count(deny) == 0 with input as {
        "resource_changes": [{
            "address": "aws_security_group_rule.restricted",
            "type": "aws_security_group_rule",
            "change": {
                "after": {
                    "cidr_blocks": ["10.0.0.0/16"]
                }
            }
        }]
    }
}
