
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.34.0"

  cluster_endpoint_public_access           = false
  enable_cluster_creator_admin_permissions = true

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  access_entries = {
    ec2-access-entry = {
      principal_arn = module.lambda_function.lambda_role_arn
      policy_associations = {
        cluster-admin-policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

  # Enable auto-mode 
  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  tags = local.tags
}
