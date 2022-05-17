variable "name" {
  type        = string
  description = "Name is used to name all resources created (as prefix)"
  default     = "aws-demo"
}

variable "az_count" {
  type        = number
  description = "Number of AZs to use for resources, should be no greater than number of available zones in the region"
  default     = 3
}

variable "tags" {
  type        = map(any)
  description = "Tags/Labels for created AWS resources"
  default = {
    environment = "dev"
  }
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "0.0.0.0/0"
}

variable "eks_cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.21"
}

variable "eks_node_groups" {
  description = "AWS-managed node pool. Will create ASG-per-AZ. See https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/node_groups#node_groups-and-node_groups_defaults-keys"
  type        = map(any)
  default     = {}
}

variable "eks_worker_groups_launch_template" {
  description = "Self-managed node pool. Will create ASG-per-AZ. See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/local.tf"
  type        = any
  default     = []
}

variable "eks_cluster_enabled_log_types" {
  description = "A list of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = []
}

variable "k8s_cluster_roles" {
  description = "Kubernetes cluster roles to create"
  type        = any
  default     = {}

}

variable "k8s_cluster_role_bindings" {
  type        = any
  description = "Kubernetes cluster role bindings to create"
  default     = {}

}

variable "k8s_role_bindings" {
  type        = any
  description = "Kubernetes role bindings to create"
  default     = []
}

variable "k8s_cluster_admin_sa" {
  type        = string
  default     = "terraform-operator"
  description = "Kubernetes service account name with binding to ClusterRole cluster-admin"
}
