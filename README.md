# GitOps Microservices on AWS EKS

Goal: Deploy the Google microservices-demo app on AWS EKS using Terraform, Helm, and GitOps (Argo CD), including ingress + TLS, autoscaling, and a dev → prod promotion flow.

## Repo Structure
- terraform/  - EKS + VPC + IAM + S3 remote state
- helm/       - Helm chart + values for dev/prod
- gitops/     - Argo CD apps + environment overlays/values
- docs/       - Architecture diagram + demo steps

## Deliverables
- EKS provisioned via Terraform
- App deployed via Helm
- Argo CD GitOps configured (dev auto-sync, prod manual)
- Ingress reachable + TLS enabled
- Autoscaling demonstrated under load
