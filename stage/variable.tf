variable "aws_region" {
    type = string
    default = "ap-northeast-2"
}

variable "aws_azs" {
    type = list(string)
    default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnets" {
  type = map(string)
  default = {
    0 = "10.0.0.0/24"   # public 1
    1 = "10.0.1.0/24"   # public 2
    2 = "10.0.2.0/24"   # private 1
    3 = "10.0.3.0/24"   # private 2
  }
}

variable "domain" {
    type = string
    default = "eocis.app"
}

variable "aws-eks-node" {
    type = string
    default = "amazon-eks-node-1.21-v20210914"
}

variable "aws-eks-node-ami" {
    type = string
    default = "602401143452"
  
}

variable "eks_instance_type" {
    type = string
    default = "t3.medium"
}

variable "eks_instance_root_volume_type" {
    type = string
    default = "gp2"
}

variable "eks_instance_root_volume_size" {
    type = string
    default = "25"
}

variable "node_group_desired_capacity" {
    type = number
    default = 2
}

variable "node_group_max_capacity" {
    type = number
    default = 4
}

variable "node_group_min_capacity" {
    type = number
    default = 2
}