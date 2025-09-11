##############################################################################
# Private Backend Tier Security Groups #######################################
# Private Backend NOTE: Add, edit or remove SG rule ports according to the services that you have running in this tier. I.e. Port 3306 for MySQL
# Private Backend NOTE Continued: Ensure to specify the source_security_group_id
##############################################################################
resource "aws_security_group" "sg_private_backend" {
  name        = "${var.env_prefix}_Backend"
  description = "Private Backend Tier Security Group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_Backend"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
    Description     = "Databases such as MSSQL will be deployed here. Note that most RDMS are deployed to the central AWS Database account."
  }
}

resource "aws_security_group_rule" "sg_private_backend_ssh" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow SSH from  Cloud Net"
  security_group_id = aws_security_group.sg_private_backend.id
  depends_on        = [aws_security_group.sg_private_backend]
}

resource "aws_security_group_rule" "sg_private_backend_mysql" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow mysql from  Cloud Net"
  security_group_id = aws_security_group.sg_private_backend.id
  depends_on        = [aws_security_group.sg_private_backend]
}

resource "aws_security_group" "sg_private_efs" {
  name        = "${var.env_prefix}_EFS"
  description = "Private EFS Tier Security Group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_EFS"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
    Description     = "Private AWS EFS ports."
  }
}

resource "aws_security_group_rule" "sg_private_backend_efs1" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow efs ports from  Cloud Net"
  security_group_id = aws_security_group.sg_private_efs.id
  depends_on        = [aws_security_group.sg_private_efs]
}

resource "aws_security_group_rule" "sg_private_backend_efs2" {
  type              = "ingress"
  protocol          = "udp"
  from_port         = 2049
  to_port           = 2049
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow efs ports from  Cloud Net"
  security_group_id = aws_security_group.sg_private_efs.id
  depends_on        = [aws_security_group.sg_private_efs]
}

resource "aws_security_group_rule" "sg_private_backend_efs3" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 100
  to_port           = 4000
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow efs ports from  Cloud Net"
  security_group_id = aws_security_group.sg_private_efs.id
  depends_on        = [aws_security_group.sg_private_efs]
}

resource "aws_security_group_rule" "sg_private_backend_egress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outgoing traffic on all ports to all destinations"
  security_group_id = aws_security_group.sg_private_backend.id
  depends_on        = [aws_security_group.sg_private_backend]
}

#####################################################
####### Private Services Security Group #############
#####################################################

resource "aws_security_group" "sg_private_services" {
  name        = "${var.env_prefix}_Private_Services"
  description = "Private Services Tier Security Group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_Private_Services"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
    Description     = "Private / Internal APIs will be deployed into this tier"
  }
}

resource "aws_security_group_rule" "sg_private_services_egress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outgoing traffic on all ports to all destinations"
  security_group_id = aws_security_group.sg_private_services.id
  depends_on        = [aws_security_group.sg_private_services]
}

resource "aws_security_group_rule" "sg_private_services_ingress_ssh" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow all inbound SSH traffic on port 22 to Private Services from  internal network"
  security_group_id = aws_security_group.sg_private_services.id
  depends_on = [aws_security_group.sg_private_services]
}

resource "aws_security_group_rule" "sg_private_services_ingress_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow all inbound HTTP traffic on port 80 to Private Services from  internal network"
  security_group_id = aws_security_group.sg_private_services.id
  depends_on = [aws_security_group.sg_private_services]
}

resource "aws_security_group_rule" "sg_private_services_ingress_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow all inbound HTTPS traffic on port 80 to Private Services from  internal network"
  security_group_id = aws_security_group.sg_private_services.id
  depends_on = [aws_security_group.sg_private_services]
}

resource "aws_security_group_rule" "sg_private_services_ingress_mongo" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 27017
  to_port           = 27017
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow all inbound Mongo traffic on port 27017 to Private Services from  internal network"
  security_group_id = aws_security_group.sg_private_services.id
  depends_on = [aws_security_group.sg_private_services]
}

#####################################################
#### Private - Presentation Security Groups #########
#####################################################

resource "aws_security_group" "sg_private_presentation" {
  name        = "${var.env_prefix}_Private_Presentation"
  description = "Private Presentation Security Group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_Private_Presentation"
    Environment     = var.env
    BusinessOwner   = var.businessowner
    BusinessUnit    = var.businessunit
    App             = var.app
    Orchestrated_By = "Terraform"
    Description     = "Private Presentation Applications and Internal Load Balancers will be deployed into this tier"
  }
}

resource "aws_security_group_rule" "sg_private_presentation_egress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outgoing traffic on all ports to all destinations"
  security_group_id = aws_security_group.sg_private_presentation.id
  depends_on        = [aws_security_group.sg_private_presentation]
}

resource "aws_security_group_rule" "sg_private_presentation_ping" {
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Ping from  internal network to Private Presentation"
  security_group_id = aws_security_group.sg_private_presentation.id
  depends_on        = [aws_security_group.sg_private_presentation]
}

resource "aws_security_group_rule" "sg_private_presentation_ingress_ssh" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "SSH access from  Cloud Net to Private Presentation resources"
  security_group_id = aws_security_group.sg_private_presentation.id
  depends_on        = [aws_security_group.sg_private_presentation]
}

resource "aws_security_group_rule" "sg_private_presentation_ingress_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "HTTP Access from all the  network to Private Presentation resources"
  security_group_id = aws_security_group.sg_private_presentation.id
  depends_on        = [aws_security_group.sg_private_presentation]
}

resource "aws_security_group_rule" "sg_private_presentation_ingress_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "HTTPS Access from all the  network to Private Presentation resources"
  security_group_id = aws_security_group.sg_private_presentation.id
  depends_on        = [aws_security_group.sg_private_presentation]
}


######################################################################
####  Private Presentation Internal Load Balancer Security Groups ####
######################################################################

resource "aws_security_group" "sg_internal_elbs" {
  name        = "${var.env_prefix}_Internal_ELBs"
  description = "Web Traffic for Internal ELBs and ALBs Security Group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_Internal_ELB"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
    Description     = "For Internal ELBs and ALBs"
  }
}

resource "aws_security_group_rule" "sg_internal_elbs_egress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outgoing traffic on all ports to all destinations"
  security_group_id = aws_security_group.sg_internal_elbs.id
  depends_on        = [aws_security_group.sg_internal_elbs]
}

resource "aws_security_group_rule" "sg_internal_elbs_ingress_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "HTTP traffic from internal  network to Internal ELBs and ALBs"
  security_group_id = aws_security_group.sg_internal_elbs.id
  depends_on        = [aws_security_group.sg_internal_elbs]
}

resource "aws_security_group_rule" "sg_internal_elbs_ingress_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["172.0.0.0/8"]
  security_group_id = aws_security_group.sg_internal_elbs.id
  description       = "HTTPS traffic from internal  network to Internal ELBs and ALBs"
  depends_on        = [aws_security_group.sg_internal_elbs]
}


###########################################################################
####################### Public Security Groups ############################
#           Need to add Cloudfront SGs as optional resources              #
###########################################################################

resource "aws_security_group" "sg_public_elbs" {
  name        = "${var.env_prefix}_Public_ELBs"
  description = "Web Traffic for ELBs and ALBs Security Group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_Public_ELB"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
    Description     = "Public ELBs and ALBs will be deployed into this tier"
  }
}

resource "aws_security_group_rule" "sg_public_elbs_egress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_public_elbs.id
  depends_on        = [aws_security_group.sg_public_elbs]
}

resource "aws_security_group_rule" "sg_public_elbs_ingress_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTP access from anywhere to Public ELBs "
  security_group_id = aws_security_group.sg_public_elbs.id
  depends_on        = [aws_security_group.sg_public_elbs]
}

resource "aws_security_group_rule" "sg_public_elbs_ingress_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_public_elbs.id
  depends_on        = [aws_security_group.sg_public_elbs]
}

resource "aws_security_group" "sg_ecs_services" {
  name        = "${var.env_prefix}_Ecs"
  description = "Private Ecs Services"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_ECS"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
    Description     = "ECS range port for containers"
  }
}

resource "aws_security_group_rule" "sg_private_ecs" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 10000
  to_port           = 65535
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "Allow ecs container and tasks port range"
  security_group_id = aws_security_group.sg_ecs_services.id
  depends_on        = [aws_security_group.sg_ecs_services]
}

resource "aws_security_group" "sg_private_ftp" {
  name        = "${var.env_prefix}_Private_FTP"
  description = "Private FTP"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name            = "${var.env_prefix}_Private_FTP"
    Environment     = "${var.env}"
    BusinessOwner   = "${var.businessowner}"
    BusinessUnit    = "${var.businessunit}"
    App             = "${var.app}"
    Orchestrated_By = "Terraform"
    Description     = "FTP SG"
  }
}

resource "aws_security_group_rule" "sg_private_ftp" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 20
  to_port           = 21
  cidr_blocks       = ["172.0.0.0/8"]
  description       = "FTP access internal"
  security_group_id = aws_security_group.sg_private_ftp.id
  depends_on        = [aws_security_group.sg_private_ftp]
}