######################
####### Public #######
######################

resource "aws_subnet" "Public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr["PublicSubnet1CIDR"]
  availability_zone = var.availability_zone_a

  tags = {
    Name            = "${format("%s-Public-%sa", var.env_prefix, var.aws_region)}"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

resource "aws_subnet" "Public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr["PublicSubnet2CIDR"]
  availability_zone = var.availability_zone_b

  tags = {
    Name            = "${format("%s-Public-%sb", var.env_prefix, var.aws_region)}"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

#resource "aws_subnet" "Public_c" {
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = var.cidr["PublicSubnet3CIDR"]
#  availability_zone = var.availability_zone_c
#
#  tags = {
#    Name            = "${format("%s-Public-%sc", var.env_prefix, var.aws_region)}"
#    Environment     = "${var.env}"
#    BusinessOwner   = "${var.businessowner}"
#    BusinessUnit    = "${var.businessunit}"
#    App             = "${var.app}"
#    Orchestrated_By = "Terraform"
#  }
#}
#####################################
####### Private Presentation ########
#####################################

resource "aws_subnet" "Private_Presentation_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr["PrivSub4CIDR"]
  availability_zone = var.availability_zone_a

  tags = {
    Name            = "${format("%s-Private-Presentation-%sa", var.env_prefix, var.aws_region)}"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

resource "aws_subnet" "Private_Presentation_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr["PrivSub5CIDR"]
  availability_zone = var.availability_zone_b

  tags = {
    Name            = "${format("%s-Private-Presentation-%sb", var.env_prefix, var.aws_region)}"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

#resource "aws_subnet" "Private_Presentation_c" {
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = var.cidr["PrivSub6CIDR"]
#  availability_zone = var.availability_zone_c
#
#  tags = {
#    Name            = "${format("%s-Private-Presentation-%sc", var.env_prefix, var.aws_region)}"
#    Environment     = "${var.env}"
#    BusinessOwner   = "${var.businessowner}"
#    BusinessUnit    = "${var.businessunit}"
#    App             = "${var.app}"
#    Orchestrated_By = "Terraform"
#  }
#}

###############################
###### Private Service ########
###############################

resource "aws_subnet" "Private_Service_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr["PrivSub7CIDR"]
  availability_zone = var.availability_zone_a

  tags = {
    Name            = "${format("%s-Private-Service-%sa", var.env_prefix, var.aws_region)}"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

resource "aws_subnet" "Private_Service_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr["PrivSub8CIDR"]
  availability_zone = var.availability_zone_b

  tags = {
    Name            = "${format("%s-Private-Service-%sb", var.env_prefix, var.aws_region)}"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

#resource "aws_subnet" "Private_Service_c" {
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = var.cidr["PrivSub9CIDR"]
#  availability_zone = var.availability_zone_c
#
#  tags = {
#    Name            = "${format("%s-Private-Service-%sc", var.env_prefix, var.aws_region)}"
#    Environment     = "${var.env}"
#    BusinessOwner   = "${var.businessowner}"
#    BusinessUnit    = "${var.businessunit}"
#    App             = "${var.app}"
#    Orchestrated_By = "Terraform"
#  }
#}

##################################
####### Private Backend ##########
##################################

resource "aws_subnet" "Private_Backend_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr["PrivSub10CIDR"]
  availability_zone = var.availability_zone_a

  tags = {
    Name            = "${format("%s-Private-Backend-%sa", var.env_prefix, var.aws_region)}"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

resource "aws_subnet" "Private_Backend_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr["PrivSub11CIDR"]
  availability_zone = var.availability_zone_b

  tags = {
    Name            = "${format("%s-Private-Backend-%sb", var.env_prefix, var.aws_region)}"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

#resource "aws_subnet" "Private_Backend_c" {
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = var.cidr["PrivSub12CIDR"]
#  availability_zone = var.availability_zone_c
#
#  tags = {
#    Name            = "${format("%s-Private-Backend-%sc", var.env_prefix, var.aws_region)}"
#    Environment     = "${var.env}"
#    BusinessOwner   = "${var.businessowner}"
#    BusinessUnit    = "${var.businessunit}"
#    App             = "${var.app}"
#    Orchestrated_By = "Terraform"
#  }
#}