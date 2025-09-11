data "aws_eks_cluster" "this" {
  name = local.cluster_name
  depends_on = [
    module.eks-cluster
  ]
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity.0.oidc.0.issuer
}
