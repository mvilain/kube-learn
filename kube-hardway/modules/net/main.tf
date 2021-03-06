// net main.tf

# variable "env_name"
# variable "region"
# variable "vpc_cidr"
# variable "zone0_name"
# variable "zone0_cidr"
# variable "zone1_name"
# variable "zone1_cidr"
# variable "zone2_name"
# variable "zone2_cidr"
# variable "whitelist"

// ================================================== VPC + SUBNETS
resource "aws_vpc" "k8s" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

data "aws_availability_zones" "available" {
  state = "available"
}
# data.aws_availability_zones.available.names is lists region's availability zones
# data.aws_availability_zones.available.zone_ids is lists region's availability zone ids

resource "aws_subnet" "zone0" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.zone0_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name                  = var.zone0_name
  }

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_subnet" "zone1" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.zone1_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name                  = var.zone1_name
  }
}

resource "aws_subnet" "zone2" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.zone2_cidr
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name                  = var.zone2_name
  }
}

data "aws_subnet_ids" "k8s" {
  vpc_id = aws_vpc.k8s.id

  depends_on = [ aws_subnet.zone0, aws_subnet.zone1, aws_subnet.zone2 ]
}
# data.aws_subnet_ids.k8s.ids lists region's default subnet ids

// ================================================== NAT GATEWAY
#resource "aws_eip" "k8s" {
#  vpc = true
#}
#
#resource "aws_nat_gateway" "priv" {
#  allocation_id = aws_eip.k8s.id
#  subnet_id     = aws_subnet.private.id
#
#  tags = {
#    Name        = "gw NAT"
#    "Terraform" = "true"
#  }
#}

// ================================================== INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k8s.id

  tags = {
    Name        = "k8s-pub-igw"
    "Terraform" = "true"
  }
}


// ================================================== ROUTES + AZ ASSOCIATIONS
resource "aws_route_table" "igw" {
  vpc_id       = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "k8s-igw"
    "Terraform" = "true"
  }
}

resource "aws_route_table_association" "zone0" {
  subnet_id      = aws_subnet.zone0.id
  route_table_id = aws_route_table.igw.id
  
  depends_on = [ aws_subnet.zone0 ]
}

resource "aws_route_table_association" "zone1" {
  subnet_id      = aws_subnet.zone1.id
  route_table_id = aws_route_table.igw.id
  
  depends_on = [ aws_subnet.zone1 ]
}

resource "aws_route_table_association" "zone2" {
  subnet_id      = aws_subnet.zone2.id
  route_table_id = aws_route_table.igw.id
  
  depends_on = [ aws_subnet.zone2 ]
}

// ================================================== SECURITY GROUPS
resource "aws_security_group" "net_sg" {
  name        = "${var.env_name}_sg"
  description = "Allow ssh,icmp,https inbound, all outbound"
  vpc_id      = aws_vpc.k8s.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "LA POP 66"
    cidr_blocks = [ "66.212.16.0/20" ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "LA POP 67-208"
    cidr_blocks = [ "67.215.208.0/20" ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "LA POP 67-224"
    cidr_blocks = [ "67.215.224.0/19" ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "LA POP 69"
    cidr_blocks = [ "69.12.64.0/19" ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "LA POP 96"
    cidr_blocks = [ "96.44.128.0/18" ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "LA POP 97"
    cidr_blocks = [ "97.0.0.0/10" ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "LA POP 173"
    cidr_blocks = [ "173.254.192.0/18" ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SEA POP 199"
    cidr_blocks = [ "199.229.250.0/24" ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SF POP 206"
    cidr_blocks = [ "206.189.0.0/16" ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "uVerse"
    cidr_blocks = [ "75.24.0.0/13" ]
  }


# ping ICPM doesn't have a port
#https://blog.jwr.io/terraform/icmp/ping/security/groups/2018/02/02/terraform-icmp-rules.html
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    "Name"      : "${var.env_name}-sg"
    "Terraform" : "true"
  }
}


# output "net_sg_id" {
#   value = aws_security_group.net_sg.id
# }
# 
# output "availability_zones" {
#   value = data.aws_availability_zones.available.names
# }
# 
# output "availability_zone_ids" {
#   value = data.aws_availability_zones.available.zone_ids
# }
# 
# output "subnet_ids" {
#   value = data.aws_subnet_ids.k8s.ids
# }
