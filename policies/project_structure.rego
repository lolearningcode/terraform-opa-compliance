package terraform.structure

required_files := {"main.tf", "variables.tf", "outputs.tf"}

deny[msg] if {
  missing := required_files - {f | f := input.files[_]}
  count(missing) > 0
  msg := sprintf("Missing required Terraform files: %v", [missing])
}
