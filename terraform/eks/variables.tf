variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-gitops-demo"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "node_instance_types" {
  description = "EC2 instance types for nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}
