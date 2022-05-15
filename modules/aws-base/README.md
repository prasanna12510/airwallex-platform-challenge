# AWS Base Resources

This terraform project creates base infra required to run services. It creates:

* VPC with specified region
  * subnets
  * nat gateways
  * internet gateways
  * routing tables
  * default security groups
  * etc

## EKS Node Groups and Worker Groups

This module supports creating AWS managed EKS node pool (Node Groups) and self-managed EKS node pool (Worker Groups).

It accepts similiar inputs as the underline terraform module [terraform-aws-modules/terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/local.tf) with some extra requirements:

* `name` is mandatory for each node pool
* `subnets` will be ignored

Examples values of the 2 terraform variables:

```hcl
eks_node_groups = {
  node-group-1 = {
    desired_capacity = 1
    max_capacity     = 10
    min_capacity     = 1

    instance_types = ["m5.4xlarge"]
  }
}
eks_worker_groups_launch_template = [
  {
    name                 = "worker-group-1"
    instance_type        = "m5.large"
    asg_desired_capacity = 2
  },
]
```
Special notes:
- AWS managed group with taint is possible with [custom launch template](https://github.com/aws/containers-roadmap/issues/864#issuecomment-753371535)
