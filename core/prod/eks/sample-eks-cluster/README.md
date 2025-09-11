# EKS Cluster

## Requirements

- CLI login to DevOps registry for state files storage and access to modules

## Usage

- Login to DevOps Terraform repository

  ```shell
  terraform login devops.sample-domain.io
  ```

- Create a `provider.tf` file for AWS and JFrog backend to store state files. Take note that workspace name
should be your cluster name
  ```
  terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
      }
    }

    backend "remote" {
      hostname     = "devops.sample-domain.io"
      organization = "k8s-terraform-state"
      workspaces {
        name = "WD-EKS-Apps-Cluster-Dev"
      }
    }
  }
  ```

- Create a `main.tf` file following this [full example configuration](#example-configuration).
Remember to edit all the variables per your environment specifications

- Initialize your configuration
  ```shell
  terraform init
  ```

- Format your terraform `.tf` files
  ```shell
  terraform fmt --recursive
  ```

- Validate your configuration
  ```shell
  terraform plan
  ```

- Deploy your cluster and bastion host
  ```shell
  terraform apply
  ```

## Example configuration
- main.tf

  ```
  module "eks-cluster" {
    source  = "devops.sample-domain.io/devops-terraform-modules/eks-provisioning/aws"
    version = "3.0.0"

    region      = "us-west-2"
    vpc_id      = "vpc-*************" # Change for datasource and use VPC name for better redability
    subnet_tier = "Presentation"

    cluster_name             = local.cluster_name
    kubernetes_version       = "1.23"
    node_group_name          = "${local.cluster_name}-NG"
    node_group_instance_type = "t3.medium"
    desired_cluster_size     = 2
    desired_cluster_max_size = 2
    desired_cluster_min_size = 2
    capacity_type            = "ON_DEMAND"

    name           = local.cluster_name
    app_name       = "AWS"
    environment    = "Dev"
    business_unit  = "Devops Rules"
    business_owner = "devops@sample-domain.com"

    cicd_user = {
      "arn"  = "arn:aws:iam::***********:user/cicd-user",
      "name" = "cicd-user"
    }

    bastion_access_role_name = "${local.cluster_name}-Bastion-Role"

    cluster_tags = {
      "alpha.eksctl.io/cluster-oidc-enabled" = true
    }
  }

  locals {
    cluster_name           = "eks-cluster"
    private_key_location   = file("~/.ssh/devops-ssh-key.pem")
    tentacle_instances_ips = ["172.0.0.235"]
  }
  ```
