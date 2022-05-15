data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  eks_cluster_name = var.name
}
