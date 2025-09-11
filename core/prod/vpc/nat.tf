resource "aws_eip" "nat_zone_a" {
  tags = {
    Name            = "${var.env_prefix}-nat_A"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}

resource "aws_eip" "nat_zone_b" {
  tags = {
    Name            = "${var.env_prefix}-nat_B"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}

resource "aws_eip" "nat_zone_c" {
  tags = {
    Name            = "${var.env_prefix}-nat_C"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_zone_a.id
  subnet_id     = aws_subnet.Public_a.id
  depends_on    = [aws_eip.nat_zone_a]

  tags = {
    Name            = "${var.env_prefix}-gw-nat_A"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_zone_b.id
  subnet_id     = aws_subnet.Public_b.id
  depends_on    = [aws_eip.nat_zone_b]

  tags = {
    Name            = "${var.env_prefix}-gw-nat_B"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}
