locals {
  cluster_name  = "prod-eks-cluster"
  cluster_arn   = data.aws_eks_cluster.this.arn
  token         = data.aws_eks_cluster_auth.this.token
  token_octopus = lookup(module.eks-cluster.octopus-secret.data, "token", "")
  endpoint      = module.eks-cluster.endpoint
  certificate   = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

}
