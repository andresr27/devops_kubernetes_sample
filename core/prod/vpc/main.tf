resource "aws_vpc" "main" {
  cidr_block           = var.cidr["VPC"]
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name            = "${var.env_prefix}_VPC"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}

resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name         = var.domain_name
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name            = "${var.env_prefix}_DHCP"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}
