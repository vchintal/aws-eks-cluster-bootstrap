data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  registry_auth {
    address  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

module "lambda_function" {
  source             = "terraform-aws-modules/lambda/aws"
  function_name      = "${local.name}-lambda"
  create_package     = false
  image_uri          = module.docker_image.image_uri
  package_type       = "Image"
  timeout            = 20
  attach_policy_json = true
  policy_json        = <<-EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "eks:*"
                ],
                "Resource": ["*"]
            }
        ]
    }
  EOT

  memory_size = 2048

  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.eks.node_security_group_id, module.eks.cluster_primary_security_group_id, module.eks.cluster_security_group_id]
  attach_network_policy  = true
}

module "docker_image" {
  source          = "terraform-aws-modules/lambda/aws//modules/docker-build"
  create_ecr_repo = true
  ecr_repo        = "${local.name}-image"
  use_image_tag   = true
  image_tag       = "1.0"
  source_path     = "container-image"
  build_args = {
    CLUSTER_NAME = var.eks_cluster_name
    REGION       = var.aws_region
  }
}