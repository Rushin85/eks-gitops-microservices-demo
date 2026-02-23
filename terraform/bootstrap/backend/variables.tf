variable "region" {
  type        = string
  description = "AWS region for the Terraform backend"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Short project name used for resource naming"
  default     = "eks-gitops-demo"
}

variable "environment" {
  type        = string
  description = "Environment name. For backend bootstrap use 'shared'."
  default     = "shared"
}

variable "bucket_suffix" {
  type        = string
  description = "Unique suffix to avoid S3 bucket name collisions (e.g., gt-1234)"
}
