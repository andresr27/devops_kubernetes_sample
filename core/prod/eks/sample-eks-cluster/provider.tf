terraform {
  backend "remote" {
    hostname     = "devops.sample-domain.io"
    organization = "k8s-terraform-state"
    workspaces {
      name = "WD-EKS-Apps-Cluster-Prd"
    }
  }
  required_providers {
    aws = {
      version = "~> 4.58.0"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}
