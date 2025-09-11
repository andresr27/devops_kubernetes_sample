module "eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "example"
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = "vpc-1234556abcdef"
  subnet_ids = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]

  admin_roles = [
    "AWS_SSO-DevOps_84750204uhfif98dwqhfwjkasfeqwf",
  ]

  admin_users = [
    "terraform-user",
  ]

  eks_addons = [
    "coredns",
    "vpc-cni",
    "kube-proxy",
    "aws-ebs-csi-driver"   #commented due to it being installed from outside tf
  ]

  tags = {
    name           = local.cluster_name
    app_name       = "AWS"
    environment    = "Prod"
    business_owner = "devops_rules_team"
  }
}



