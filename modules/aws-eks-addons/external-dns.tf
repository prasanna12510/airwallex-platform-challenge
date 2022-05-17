locals {
  oidc_url = replace(local.eks_identity_oidc_issuer, "https://", "")
}

resource "aws_iam_role_policy" "external_dns" {
  name_prefix = "${var.eks_cluster_name}-external-dns"
  role        = aws_iam_role.external_dns.name
  policy      = file("${path.module}/files/external-dns-iam-policy.json")
}


resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn
    }
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
  }

  rule {
    api_groups = [""]
    resources  = ["services", "pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.istio.io"]
    resources  = ["gateways"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns" {
  metadata {
    name = "external-dns"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.external_dns.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.external_dns.metadata.0.name
    namespace = kubernetes_service_account.external_dns.metadata.0.namespace
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = kubernetes_service_account.external_dns.metadata.0.namespace
  wait       = true
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.external_dns_chart_version

  set {
    name  = "rbac.create"
    value = false
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external_dns.metadata.0.name
  }

  set {
    name  = "rbac.pspEnabled"
    value = false
  }

  set {
    name  = "name"
    value = "${var.eks_cluster_name}-external-dns"
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "logLevel"
    value = var.external_dns_chart_log_level
  }

  set {
    name  = "sources"
    value = "{ingress,service}"
  }

  set {
    name  = "domainFilters"
    value = "{${join(",", var.external_dns_domain_filters)}}"
  }

  set {
    name  = "aws.zoneType"
    value = var.external_dns_zoneType
  }

  set {
    name  = "aws.region"
    value = var.aws_region
  }
}

resource "aws_iam_role" "external_dns" {
  name  = "${var.eks_cluster_name}-external-dns"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc_url}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${local.oidc_url}:sub": "system:serviceaccount:kube-system:external-dns"
        }
      }
    }
  ]
}
EOF

}
