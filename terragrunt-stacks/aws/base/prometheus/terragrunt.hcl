include {
  path = find_in_parent_folders()
}

dependency "aws-base" {
  config_path = "${get_parent_terragrunt_dir()/../base/aws-base}"
}


generate "helm-provider" {
  path = "generated-helm-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOT
  provider "helm" {
    kubernetes {
        config_path = "~/.kube/config"
        config_context = "${local.vars.kubecontext}"
    }
  }
  EOT
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../../../modules/prometheus//."
}
