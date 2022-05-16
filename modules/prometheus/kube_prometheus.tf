resource "helm_release" "prometheus_operator" {
  atomic           = var.atomic
  chart            = var.chart_name
  cleanup_on_fail  = var.cleanup_on_fail
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true
  repository       = var.chart_repository
  timeout          = var.timeout
  version          = var.chart_version

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}


resource "null_resource" "wait_for_prometheus_operator" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nWaiting for the prometheus operator...\n"
      kubectl wait --namespace ${helm_release.prometheus_operator.namespace} \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/name=prometheus \
        --timeout=300s
    EOF
  }

  depends_on = [helm_release.ingress_nginx]
}
