terraform {
  backend "s3" {
    bucket         = "eks-gitops-demo-shared-tfstate-gt-1234"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "eks-gitops-demo-tflock"
    encrypt        = true
  }
}
