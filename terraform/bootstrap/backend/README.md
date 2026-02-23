# Terraform Backend Bootstrap

This folder creates:
- S3 bucket for Terraform state (versioned + encrypted + private)
- DynamoDB table for state locking

Run once per project/account.

## Run
1) Ensure AWS creds are set:
   aws sts get-caller-identity

2) Init/apply:
   terraform init
   terraform apply -var="bucket_suffix=gt-1234"

## Outputs
Use the output values to configure backends in other Terraform stacks.
