variable "name" {
  type        = string
  description = "Name is used to name all resources created (as prefix)"
  default     = "aws-demo"
}

variable "aws_account_id" {
  description = "account id number"
  default = ""
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default = "ap-southeast-1"
}

variable "external_dns_chart_version" {
  description = "External-dns Helm chart version to deploy. 3.0.0 is the minimum version for this function"
  type        = string
  default     = "6.4.0"
}

variable "external_dns_chart_log_level" {
  description = "External-dns Helm chart log leve. Possible values are: panic, debug, info, warn, error, fatal"
  type        = string
  default     = "warning"
}

variable "external_dns_zoneType" {
  description = "External-dns Helm chart AWS DNS zone type (public, private or empty for both)"
  type        = string
  default     = ""
}


variable  "eks_cluster_name" {
  description = "EKS cluster name"
  type = string
}

variable "external_dns_domain_filters" {
  description = "External-dns Domain filters."
  type        = list(string)
  default = []
}
