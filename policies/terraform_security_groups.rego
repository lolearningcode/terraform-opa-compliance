package terraform.security_groups

# Deny security group rules that allow traffic from anywhere
deny contains msg if {
    resource := input.resource_changes[_]
    resource.type == "aws_security_group_rule"
    cidr_blocks := resource.change.after.cidr_blocks
    "0.0.0.0/0" in cidr_blocks
    msg := sprintf("Security group rule '%s' allows unrestricted access (0.0.0.0/0)", [resource.address])
}
