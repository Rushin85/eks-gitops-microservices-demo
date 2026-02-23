Project Conventions – eks-gitops-demo
This document defines mandatory naming and infrastructure standards for the project.
All contributors must follow these conventions.
1️⃣ Project Information
Project Name:
eks-gitops-demo
Environment:
dev
AWS Region:
us-east-1
These values are fixed unless explicitly updated and approved by the team.
2️⃣ Resource Naming Pattern
All AWS and Kubernetes resources must follow this pattern:
<project>-<env>-<resource>
Examples
eks-gitops-demo-dev-vpc
eks-gitops-demo-dev-eks
eks-gitops-demo-dev-nodegroup
eks-gitops-demo-dev-argocd
EKS Cluster Name:
eks-gitops-demo-dev
3️⃣ Terraform State Resources
S3 Bucket
eks-gitops-demo-tfstate-<unique-suffix>
DynamoDB Lock Table
eks-gitops-demo-tflock
State Key Example
foundation/terraform.tfstate
4️⃣ Mandatory AWS Tags
All Terraform-managed AWS resources must include:
Project = eks-gitops-demo
Environment = dev
ManagedBy = terraform
Owner = devops-team
Optional (recommended):
CostCenter = training
CreatedBy = terraform
5️⃣ Git Branch Strategy
Branches must follow this format:
main
feature/<short-description>
hotfix/<short-description>
Examples:
feature/terraform-foundation
feature/eks-cluster
feature/argocd-install
No personal or experimental branch names in production code.
6️⃣ Kubernetes Naming
Namespaces must be:
argocd
online-boutique
No random naming conventions allowed.
7️⃣ Enforcement
All pull requests must follow these standards.
Any deviation must be corrected before merge.
Naming consistency is mandatory.