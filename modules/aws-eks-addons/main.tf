data "aws_region" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

locals {
  aws_region               = data.aws_region.current.name
  eks_identity_oidc_issuer = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
