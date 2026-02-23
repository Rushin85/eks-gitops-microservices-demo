data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket         = "eks-gitops-demo-shared-tfstate-gt-1234"
    key            = "vpc/terraform.tfstate"
    region         = var.region
    dynamodb_table = "eks-gitops-demo-shared-tflock"
    encrypt        = true
  }
}

locals {
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.name
  cluster_version = var.kubernetes_version

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnets

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  # EKS managed add-ons (safe defaults)
  cluster_addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = {}
  }

  eks_managed_node_groups = {
    default = {
      name            = "${var.name}-ng"
      instance_types  = var.node_instance_types

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
    }
  }

  tags = {
    Project = var.name
  }
}
