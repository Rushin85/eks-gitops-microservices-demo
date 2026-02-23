variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "eks-gitops-demo"
}

variable "kubernetes_version" {
  type    = string
  default = "1.29"
}
