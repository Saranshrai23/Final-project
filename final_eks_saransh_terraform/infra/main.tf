module "vpc" {
  source = "../modules/vpc"

  name                 = var.name
  cidr_block           = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "iam" {
  source = "../modules/iam"
  name   = var.name
}

module "EKS" {
  source = "../modules/EKS"

  name               = var.name
  region             = var.region
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  endpoint_public_access  = true
  endpoint_private_access = false

  desired_size = 3
  min_size     = 2
  max_size     = 5
}

