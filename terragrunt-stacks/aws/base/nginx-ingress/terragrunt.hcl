include {
  path = find_in_parent_folders()
}

dependency "aws-base" {
  config_path = "../aws-base"
}

generate "kubeconfig" {
  path      = "${get_terragrunt_dir()}/generated-kubeconfig"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOT
  apiVersion: v1
  preferences: {}
  kind: Config
  clusters:
  - cluster:
      server: ${dependency.aws-base.outputs.eks.cluster_endpoint}
      certificate-authority-data: ${dependency.aws-base.outputs.eks.cluster_certificate_authority_data}
    name: eks
  contexts:
  - context:
      cluster: eks
      user: eks-sa
    name: eks
  current-context: eks
  users:
  - name: eks-sa
    user:
      token: ${dependency.aws-base.outputs.k8s_cluster_admin_sa_secret.token}
  EOT
}

locals {
  common_vars = yamldecode(file("${get_parent_terragrunt_dir()}/../common-${get_env("TF_VAR_env_deployment", "local")}.yaml"))
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../../..//modules/nginx-ingress"
  extra_arguments "tf-k8s-provider-env" {
    commands = ["plan", "apply", "destroy", "import", "output", "refresh"]
    env_vars = {
      KUBE_CONFIG_PATH = "${get_terragrunt_dir()}/generated-kubeconfig"
      # For CLI tools like kubectl, skaffold
      KUBECONFIG = "${get_terragrunt_dir()}/generated-kubeconfig"
    }
  }
}


generate "kubernetes-provider" {
  path      = "generated-kubernetes-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOT
  provider "kubernetes" {
    experiments {
        manifest_resource = true
    }
  }
  EOT
}
