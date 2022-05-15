module "subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.vpc_cidr
  networks = [
    {
      name     = "private_subnets"
      new_bits = 1
    },
    {
      name     = "public_subnets"
      new_bits = 3
    }
  ]
}

locals {
  aws_azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  # divide each network cidr to 4 subnets and slice it to number of AZs
  private_subnets     = slice(cidrsubnets(module.subnet_addrs.network_cidr_blocks["private_subnets"], 2, 2, 2, 2), 0, var.az_count)
  public_subnets      = slice(cidrsubnets(module.subnet_addrs.network_cidr_blocks["public_subnets"], 2, 2, 2, 2), 0, var.az_count)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name = var.name
  cidr = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_dhcp_options  = true

  azs                 = local.aws_azs
  private_subnets     = local.private_subnets
  public_subnets      = local.public_subnets

  enable_nat_gateway              = true
  one_nat_gateway_per_az          = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
  }

  tags = var.tags
}
