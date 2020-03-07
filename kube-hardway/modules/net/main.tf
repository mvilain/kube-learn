// net main.tf

# variable "env_name"
# variable "region"
# variable "vpc_cidr"
# variable "pubnet_name"
# variable "pubnet_cidr"
# variable "privnet_name"
# variable "privnet_cidr"
# variable "whitelist"

// ================================================== NETWORK + SUBNETS

resource "aws_vpc" "k8s" {
  cidr_block = var.vpc_cidr
}

data "aws_availability_zones" "available" {
  state = "available"
}
# data.aws_availability_zones.available.names is lists region's availability zones
# data.aws_availability_zones.available.zone_ids is lists region's availability zone ids

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.pubnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name                  = var.pubnet_name
  }
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.k8s.id
  cidr_block = var.privnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = var.privnet_name
  }
}

data "aws_subnet_ids" "k8s" {
  vpc_id = aws_vpc.k8s.id

  # yes, this is bad, but the subnets don't exist yet
  depends_on = [ aws_subnet.public, aws_subnet.private]
}
# data.aws_subnet_ids.k8s.ids lists region's default subnet ids

// ================================================== NAT GATEWAY

resource "aws_eip" "k8s" {
  vpc = true

#   instance                  = "${aws_instance.foo.id}"
#   associate_with_private_ip   = "10.0.0.12"
#   depends_on                  = ["aws_nat_gateway.priv"]
}

resource "aws_nat_gateway" "priv" {
  allocation_id = aws_eip.k8s.id
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "gw NAT"
  }
}

// ================================================== ROUTES

resource "aws_route_table" "pubnet" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = var.pubnet_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "k8s-pubnet"
  }
}

// ================================================== SECURITY GROUPS

resource "aws_security_group" "net_sg" {
  name  = "${var.env_name}_sg"
  description = "Allow http+https ports inbound, all outbound"
  vpc_id      = aws_vpc.k8s.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "LA POP"
    cidr_blocks = var.whitelist
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
    "Terraform" : "true"
    "Name"      : "${var.env_name}-sg"
  }
}

// ================================================== INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k8s.id

  tags = {
    Name = "k8s-pub-igw"
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
