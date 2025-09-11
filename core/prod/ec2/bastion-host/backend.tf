terraform {
  backend "remote" {
    hostname     = "devops.sample-domain.io"
    organization = "k8s-terraform-state"
    workspaces {
      name = "eks-bastion-prod"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}