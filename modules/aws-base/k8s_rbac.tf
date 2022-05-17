resource "kubernetes_service_account" "cluster_admin" {
  depends_on = [module.eks]
  metadata {
    name      = var.k8s_cluster_admin_sa
    namespace = "default"
  }
}

resource "kubernetes_cluster_role_binding" "cluster_admin" {
  depends_on = [module.eks]
  metadata {
    name = "${var.k8s_cluster_admin_sa}-cluster-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = var.k8s_cluster_admin_sa
    namespace = "default"
  }
}

data "kubernetes_secret" "cluster_admin_sa" {
  metadata {
    name = kubernetes_service_account.cluster_admin.default_secret_name
  }
}

resource "kubernetes_cluster_role" "k8s_clusterrole" {
  for_each = var.k8s_cluster_roles

  metadata {
    name   = each.key
    labels = lookup(each.value, "labels", {})
  }

  dynamic "rule" {
    for_each = each.value.rules
    content {
      api_groups = rule.value["api_groups"]
      resources  = rule.value["resources"]
      verbs      = rule.value["verbs"]
    }
  }
}

resource "kubernetes_cluster_role_binding" "k8s_clusterrolebinding" {
  for_each = var.k8s_cluster_role_bindings

  metadata {
    name = each.key
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value.cluster_role
  }

  dynamic "subject" {
    for_each = each.value.subjects
    content {
      kind      = subject.value["kind"]
      name      = subject.value["name"]
      api_group = lookup(subject.value, "api_group", null)
      namespace = lookup(subject.value, "namespace", null)
    }
  }
}

locals {
  k8s_role_bindings = {
    for i in var.k8s_role_bindings :
    "${i.namespace}-${i.name}" => i
  }
}

resource "kubernetes_role_binding" "k8s_rolebinding" {
  for_each = local.k8s_role_bindings

  metadata {
    name      = each.value.name
    namespace = each.value.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value.cluster_role
  }

  dynamic "subject" {
    for_each = each.value.subjects
    content {
      kind      = subject.value["kind"]
      name      = subject.value["name"]
      api_group = lookup(subject.value, "api_group", null)
      namespace = lookup(subject.value, "namespace", null)
    }
  }
}
