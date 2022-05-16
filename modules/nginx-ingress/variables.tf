variable "kind_cluster_config_path" {
  type        = string
  description = "The location where this cluster's kubeconfig will be saved to."
  default     = "~/.kube/kindconfig"
}

variable "atomic" {
  default     = true
  description = "Purge the chart on a failed installation. Default's to \"true\"."
  type        = bool
}

variable "cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}


variable "ingress_nginx_helm_version" {
  type        = string
  description = "The Helm version for the nginx ingress controller."
  default     = "4.0.13"
}

variable "ingress_nginx_namespace" {
  type        = string
  description = "The nginx ingress namespace (it will be created if needed)."
  default     = "ingress-nginx"
}
