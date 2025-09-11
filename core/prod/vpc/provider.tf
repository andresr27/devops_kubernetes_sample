# terraform init -backend-config=backend.conf
# terraform plan -var-file=example.tfvars
# terraform apply -var-file=example.tfvars
# terraform destroy -var-file=example.tfvars
provider "aws" {
  region = var.aws_region
}

# 
terraform {

  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

}