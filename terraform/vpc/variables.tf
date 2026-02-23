variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Base name used for tagging and resource naming"
  type        = string
  default     = "eks-gitops-demo"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "How many AZs to use (2 is enough for dev)"
  type        = number
  default     = 2
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway for all private subnets (cheaper for dev)"
  type        = bool
  default     = true
}
