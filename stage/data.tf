data "aws_ami" "eks-worker" {
    filter{
        name = "name"
        values = ["${var.aws-eks-node}"]
    }

    most_recent = true
    owners = ["${var.aws-eks-node-ami}"]
  
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

data "aws_acm_certificate" "cert_arn" {
  domain   = "${var.domain}"
}