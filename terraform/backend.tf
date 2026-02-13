terraform {
  backend "s3" {
    bucket         = "eks-gitops-demo-tfstate-gt-1234"
    key            = "state/eks-gitops-demo.tfstate"
    region         = "us-east-1"
    dynamodb_table = "eks-gitops-demo-tflock"
    encrypt        = true
  }
}
