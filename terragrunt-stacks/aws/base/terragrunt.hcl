locals {
  # https://terragrunt.gruntwork.io/docs/features/locals/#including-globally-defined-locals
  vars       = merge(yamldecode(file("${get_parent_terragrunt_dir()}/../common-${get_env("TF_VAR_env_deployment", "local")}.yaml")), yamldecode(file("${get_parent_terragrunt_dir()}/vars-${get_env("TF_VAR_env_deployment", "local")}.yaml")))
  state_file = "aws-demo-${path_relative_to_include()}.tfstate"
}

generate "tf-version-requirement" {
  path      = "versions.tf"
  if_exists = "skip"
  contents  = file("${get_parent_terragrunt_dir()}/tf-version-requirement.hcl")
}

generate "aws-provider" {
  path      = "generated-aws-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOT
  provider "aws" {
    region = "${local.vars.region}"
    assume_role {
      role_arn = "${local.vars.aws_assume_role}"
    }
  }
  EOT
}

inputs = lookup(local.vars, "common", {})

generate "vars" {
  path              = "terragrunt.auto.tfvars.json"
  disable_signature = true
  if_exists         = "overwrite"
  contents          = jsonencode(lookup(local.vars, path_relative_to_include(), {}))
}
