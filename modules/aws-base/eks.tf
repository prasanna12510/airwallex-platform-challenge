locals {
  eks_subnets = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  eks_node_pool_az_suffix = [
    for i in range(var.az_count) : trimprefix(data.aws_availability_zones.available.names[i], data.aws_availability_zones.available.id)
  ]

  eks_worker_groups_launch_template = flatten([
    for group in var.eks_worker_groups_launch_template : [
      for i in range(lookup(group, "az_count", var.az_count)) : merge(group, {
        name    = "${group["name"]}-${local.eks_node_pool_az_suffix[i]}",
        subnets = [module.vpc.private_subnets[i]]
        tags = concat([
          {
            "key"                 = "eks-cluster"
            "value"               = "${local.eks_cluster_name}"
            "propagate_at_launch" = "false"
          },
        ], lookup(group, "tags", []))
      })
    ]
  ])
  eks_node_groups = merge([
    for i in range(var.az_count) : {
      for name, group in var.eks_node_groups : "${name}-${local.eks_node_pool_az_suffix[i]}" =>
      merge(group, {
        subnets = [module.vpc.private_subnets[i]]
      })
    }
  ]...)
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.1.0"
  depends_on      = [module.vpc, aws_route53_zone.private]
  cluster_name    = local.eks_cluster_name
  cluster_version = var.eks_cluster_version

  vpc_id  = module.vpc.vpc_id
  subnets = local.eks_subnets

  write_kubeconfig                                   = true
  cluster_endpoint_private_access                    = true
  cluster_endpoint_private_access_cidrs              = [var.vpc_cidr]
  cluster_create_endpoint_private_access_sg_rule     = true
  enable_irsa                                        = true
  create_fargate_pod_execution_role                  = false
  worker_create_cluster_primary_security_group_rules = true
  cluster_enabled_log_types                          = var.eks_cluster_enabled_log_types

  workers_group_defaults = {
    metadata_http_put_response_hop_limit = 3
    #Restricting Access to metadata endpoint
    #https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html
    metadata_http_endpoint = "enabled"  # The state of the metadata service: enabled, disabled.
    metadata_http_tokens   = "required" # If session tokens are required: optional, required.
  }
  worker_groups_launch_template = local.eks_worker_groups_launch_template
  node_groups_defaults          = {}
  node_groups                   = local.eks_node_groups

  tags = var.tags
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
