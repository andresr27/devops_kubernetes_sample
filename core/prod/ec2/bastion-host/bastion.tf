module "ec2-bastion" {
  source = "git@change-repository.io:project/terraform-aws-modules.git//bastion"

  account_id          = "*************"
  vpc_name            = ["prod"]
  security_group_name = "prod-sg-name"
  subnet_name         = ["prod-private-2a"]
  environment         = "Prod"
  dns_zone            = "sample-domain.io"
  ssh_key_name        = "devops_rule_team"
}