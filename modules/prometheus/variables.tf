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

variable "chart_name" {
  default     = "kube-prometheus-stack"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "chart_repository" {
  default     = "https://prometheus-community.github.io/helm-charts"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "chart_version" {
  default     = "16.12.1"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "namespace" {
  description = "The namespace used for the operator deployment"
  default     = "monitoring"
  type        = string
}

variable "release_name" {
  default     = "kube-prometheus-stack"
  description = "The name of the helm release"
  type        = string
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}
