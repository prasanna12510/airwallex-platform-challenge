output "vpc" {
  value = module.vpc
}

output "eks" {
  value = module.eks
}

output "k8s_cluster_admin_sa_secret" {
  sensitive   = true
  description = "K8S secret of created service account, map with keys: ca.crt, namespace, token"
  value       = data.kubernetes_secret.cluster_admin_sa.data
}
