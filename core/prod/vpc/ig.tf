######################
## Internet Gateway ##
######################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_Internet_Gateway"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
  }
}