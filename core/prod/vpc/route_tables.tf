###### Route Tables Associations ########## 

#######################################
############# Public    ###############
#######################################

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_RT_Public"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "rt_public" {
  route_table_id         = aws_route_table.Public.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.Public]
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "Assoc_Public_a" {
  subnet_id      = aws_subnet.Public_a.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_route_table_association" "Assoc_Public_b" {
  subnet_id      = aws_subnet.Public_b.id
  route_table_id = aws_route_table.Public.id
}

#resource "aws_route_table_association" "Assoc_Public_c" {
#  subnet_id      = aws_subnet.Public_c.id
#  route_table_id = aws_route_table.Public.id
#}

#######################################
######## Private Zone A ###############
#######################################

resource "aws_route_table" "Private_Zone_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_RT_Private_a"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}

resource "aws_route" "rt_private_a" {
  route_table_id         = aws_route_table.Private_Zone_a.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.Private_Zone_a]
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

resource "aws_route_table_association" "Private_Presentation_a" {
  subnet_id      = aws_subnet.Private_Presentation_a.id
  route_table_id = aws_route_table.Private_Zone_a.id
}

resource "aws_route_table_association" "Private_Service_a" {
  subnet_id      = aws_subnet.Private_Service_a.id
  route_table_id = aws_route_table.Private_Zone_a.id
}

resource "aws_route_table_association" "Private_Backend_a" {
  subnet_id      = aws_subnet.Private_Backend_a.id
  route_table_id = aws_route_table.Private_Zone_a.id
}

#######################################
######## Private Zone B ###############
#######################################

resource "aws_route_table" "Private_Zone_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_RT_Private_b"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

resource "aws_route" "rt_private_b" {
  route_table_id         = aws_route_table.Private_Zone_b.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.Private_Zone_b]
  nat_gateway_id         = aws_nat_gateway.nat_b.id
}

resource "aws_route_table_association" "Private_Presentation_b" {
  subnet_id      = aws_subnet.Private_Presentation_b.id
  route_table_id = aws_route_table.Private_Zone_b.id
}

resource "aws_route_table_association" "Private_Service_b" {
  subnet_id      = aws_subnet.Private_Service_b.id
  route_table_id = aws_route_table.Private_Zone_b.id
}

resource "aws_route_table_association" "Private_Backend_b" {
  subnet_id      = aws_subnet.Private_Backend_b.id
  route_table_id = aws_route_table.Private_Zone_b.id
}

#######################################
######## Private Zone C ###############
#######################################

resource "aws_route_table" "Private_Zone_c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_RT_Private_c"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}

#resource "aws_route" "rt_private_c" {
#  route_table_id         = aws_route_table.Private_Zone_c.id
#  destination_cidr_block = "0.0.0.0/0"
#  depends_on             = [aws_route_table.Private_Zone_c]
#  nat_gateway_id         = aws_nat_gateway.nat_c.id
#}
#
#resource "aws_route_table_association" "Private_Presentation_c" {
#  subnet_id      = aws_subnet.Private_Presentation_c.id
#  route_table_id = aws_route_table.Private_Zone_c.id
#}
#
#resource "aws_route_table_association" "Private_Service_c" {
#  subnet_id      = aws_subnet.Private_Service_c.id
#  route_table_id = aws_route_table.Private_Zone_c.id
#}
#
#resource "aws_route_table_association" "Private_Backend_c" {
#  subnet_id      = aws_subnet.Private_Backend_c.id
#  route_table_id = aws_route_table.Private_Zone_c.id
#}