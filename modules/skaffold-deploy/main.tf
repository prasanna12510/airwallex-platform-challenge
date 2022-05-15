locals {
  clone_path = "${path.module}/../../service"
}


resource "null_resource" "generate_data_file" {
  for_each = {
    for k, v in var.data_files : k => v if v != yamlencode({})
  }

  provisioner "local-exec" {
    command = <<-EOT
    cat <<EOF > ${local.clone_path}/${var.git_relative_path}/${each.key}
    ${each.value}
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
}


resource "null_resource" "script_run" {
  count = var.script_run ? 1 : 0
  depends_on = [null_resource.generate_data_file]

  provisioner "local-exec" {
    working_dir = "${local.clone_path}/${var.service_name}"
    command     = "/bin/bash ${var.script_path}"
  }

  triggers = {
    always_run = timestamp()
  }
}


resource "null_resource" "skaffold_run" {
  depends_on = [null_resource.generate_data_file, null_resource.script_run]

  provisioner "local-exec" {
    working_dir = "${local.clone_path}/${var.service_name}"
    environment = var.envs
    command     = "skaffold deploy ${var.skaffold_arg}"
  }

  triggers = {
    always_run = timestamp()
  }
}
