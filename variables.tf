variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "eks_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.31"
}
