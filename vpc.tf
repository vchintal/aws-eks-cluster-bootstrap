module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.19.0"

  name = local.name
  cidr = var.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 10)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

# Explicitly create a Internet Gateway here in the Private EKS VPC as without an
# internet gateway, a NLB cannot be created. Config option of create_igw = true
# (default) did not work during the VPC creation as it requires public subnets
# and the related routes that connect them to IGW
# resource "aws_internet_gateway" "igw" {
#   vpc_id = module.vpc.vpc_id
#   tags   = local.tags
# }

# module "vpc_endpoints" {
#   source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version = "~> 5.19.0"

#   vpc_id = module.vpc.vpc_id

#   # Security group
#   create_security_group      = true
#   security_group_name_prefix = "${local.name}-vpc-endpoints-"
#   security_group_description = "VPC endpoint security group"
#   security_group_rules = {
#     ingress_https = {
#       description = "HTTPS from VPC"
#       cidr_blocks = [module.vpc.vpc_cidr_block]
#     }
#   }

#   endpoints = merge({
#     s3 = {
#       service         = "s3"
#       service_type    = "Gateway"
#       route_table_ids = module.vpc.private_route_table_ids
#       tags = {
#         Name = "${local.name}-s3"
#       }
#     }
#     },
#     { for service in toset(["autoscaling", "ecr.api", "ecr.dkr", "ec2", "ec2messages", "elasticloadbalancing", "sts", "kms", "logs", "ssm", "ssmmessages"]) :
#       replace(service, ".", "_") =>
#       {
#         service             = service
#         subnet_ids          = module.vpc.private_subnets
#         private_dns_enabled = true
#         tags                = { Name = "${local.name}-${service}" }
#       }
#   })

#   tags = local.tags
# }