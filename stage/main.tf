terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5"
    }
  }

  required_version = ">= 1.0.5"
}

provider "aws" {
  region                  = "ap-northeast-2"     # Region
  shared_credentials_file = "~/.aws/credentials" # AWS Profile Path
}

# Kubernetes
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

locals {
  cluster_name = "EKS-cluster"
}

# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc"
  cidr = "${var.vpc_cidr}"

  azs             = var.aws_azs
  private_subnets = ["${var.subnets[2]}", "${var.subnets[3]}"]
  public_subnets  = ["${var.subnets[0]}", "${var.subnets[1]}"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
  }
  # Subnet Tagging for EKS Cluster
  private_subnet_tags = merge(
      {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/elb" = 1
      }
    )

}

# EKS Module
module "eks" {
  source          = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = local.cluster_name
  vpc_id          = module.vpc.vpc_id
  subnets         = [module.vpc.private_subnets[0],module.vpc.private_subnets[1]]
  manage_aws_auth = true

  workers_group_defaults = {
    instance_type                     = "${var.eks_instance_type}"
    root_volume_size                  = "${var.eks_instance_root_volume_size}"
    root_volume_type                  = "${var.eks_instance_root_volume_type}"
  }

  node_groups = {
      first = {
          desired_capacity = "${var.node_group_desired_capacity}"
          max_capacity = "${var.node_group_max_capacity}"
          min_capacity = "${var.node_group_min_capacity}"
      }
  }
}

# Ingress-Controller Policy Attachment
resource "aws_iam_role_policy" "worker_policy" {
  name   = "eks-worker-policy"
  role   = module.eks.worker_iam_role_name
  policy = data.http.worker_policy.body
}

# Use AWS-ALB-Ingress-Controller Policy
data "http" "worker_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.1/docs/install/iam_policy.json"

  request_headers = {
    Accept = "application/json"
  }
}