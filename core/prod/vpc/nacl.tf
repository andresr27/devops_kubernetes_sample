##############################
# ACL Rules - Public
##############################

resource "aws_network_acl" "acl_public" {
  vpc_id = aws_vpc.main.id

  subnet_ids = [
    aws_subnet.Public_a.id,
    aws_subnet.Public_b.id,
  ]

  tags = {
    Name            = "${var.env_prefix}_ACL_Public"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}

##############
## Ingress ###
##############

# Allow HTTP & HTTPS from anywhere
resource "aws_network_acl_rule" "aclr_pub_i_allow_http" {
  network_acl_id = aws_network_acl.acl_public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "aclr_pub_i_allow_https" {
  network_acl_id = aws_network_acl.acl_public.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "aclr_pub_i_allow_app" {
  network_acl_id = aws_network_acl.acl_public.id
  rule_number    = 300
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

##########
# Egress
##########

# Allow everything everywhere
resource "aws_network_acl_rule" "aclr_pub_e_allow_all" {
  network_acl_id = aws_network_acl.acl_public.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

##############################
# ACL Rules - Private
##############################

resource "aws_network_acl" "acl_private" {
  vpc_id = aws_vpc.main.id

  subnet_ids = [
    aws_subnet.Private_Presentation_a.id,
    aws_subnet.Private_Presentation_b.id,
     aws_subnet.Private_Service_a.id,
    aws_subnet.Private_Service_b.id,
    aws_subnet.Private_Backend_a.id,
    aws_subnet.Private_Backend_b.id,
  ]

  tags = {
    Name            = "${var.env_prefix}_ACL_Private"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
  }
}

##########
# Ingress
##########

resource "aws_network_acl_rule" "aclr_private_icmp" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 10
  egress         = false
  protocol       = "icmp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
  icmp_type      = -1
  icmp_code      = -1
}

resource "aws_network_acl_rule" "aclr_private_ssh" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "172.0.0.0/8"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "aclr_private_http" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "172.0.0.0/8"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "aclr_private_https" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 201
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "172.0.0.0/8"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "aclr_private_app" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 202
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

##########
# Egress
##########

resource "aws_network_acl_rule" "aclr_private_e_icmp" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 10
  egress         = true
  protocol       = "icmp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
  icmp_type      = -1
  icmp_code      = -1
}

resource "aws_network_acl_rule" "aclr_private_e_ssh" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "172.0.0.0/8"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "aclr_private_e_http" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "aclr_private_e_https" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 201
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "aclr_private_e_app" {
  network_acl_id = aws_network_acl.acl_private.id
  rule_number    = 210
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# No outbound UDP. Use AWS time sync service