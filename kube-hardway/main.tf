//================================================== VARIABLES
variable "K8S_REGION" {
  type        = string
  description = "AWS region to use for Kubernetes cluster"
}

variable "K8S_KEYNAME" {
  type        = string
  description = "ssh public key name for Kubernetes cluster"
}

variable "K8S_KEY" {
  type        = string
  description = "ssh public key for Kubernetes cluster"
}

variable "K8S_BUCKET" {
  type        = string
  description = "AWS S3 Bucket to store Terraform state for Kubernetes cluster"
}

variable "K8S_DYNAMODB_TABLE" {
  type        = string
  description = "AWS S3 database to store Terraform state for Kubernetes cluster"
}

# CentOS 7 in us-east-2
variable "K8S_AMI" {
  type        = string
  description = "regional AMI to use for Kubernetes"
}

variable "K8S_TYPE" {
  type        = string
  description = "regional EC2 type to use for Kubernetes"
}

variable "K8S_VPC_CIDR" {
  type        = string
  description = "VPC network CIDR for Kubernetes cluster"
  default     = "10.10.0.0/16"
}

variable "ZONE0_NAME" {
  type        = string
  description = "VPC public subnet name"
  default     = "k8s_pubnet"
}
variable "ZONE0_CIDR" {
  type        = string
  description = "VPC public subnet CIDR block"
  default     = "10.10.10.0/24"
}

variable "ZONE1_NAME" {
  type        = string
  description = "VPC ZONE1 subnet name"
  default     = "k8s_privnet"
}
variable "ZONE1_CIDR" {
  type        = string
  description = "VPC ZONE1 subnet CIDR block"
  default     = "10.10.20.0/24"
}

variable "ZONE2_NAME" {
  type        = string
  description = "VPC ZONE2 subnet name"
  default     = "k8s_privnet"
}
variable "ZONE2_CIDR" {
  type        = string
  description = "VPC ZONE2 subnet CIDR block"
  default     = "10.10.20.0/24"
}

variable "k8s_whitelist" {
  type        = list(string)
  description = "list of CIDR ranges to allow ingress access"
}

######################################################################

provider "aws" {
  profile = "kube-hardway"
  version = "~> 2.8"
  region  = var.K8S_REGION
}

//================================================== S3 ENCRYPTED BACKEND+LOCKS
#terraform {
#  backend "local" {
#    path = "./terraform.tfstate"
#  }
#}
# this can't use variables
#terraform {
#    backend "s3" {
#    bucket         = "mvilain-prod-tfstate-backend"
#    key            = "global/s3/terraform.tfstate"
#    region         = "us-east-2"
#    profile        = "k8s"
#    dynamodb_table = "mvilain-prod-tfstate-locks"
#    encrypt        = true
#  }
#}

# set the key for k8s
resource "aws_key_pair" "k8s" {
  key_name   = var.K8S_KEYNAME
  public_key = var.K8S_KEY
}

// ================================================== NETWORK + SUBNETS
module "net_setup" {
  source = "./modules/net"

  #inputs:
  env_name     = "prod"
  region       = var.K8S_REGION
  vpc_cidr     = var.K8S_VPC_CIDR
  zone0_name   = var.ZONE0_NAME
  zone0_cidr   = var.ZONE0_CIDR
  zone1_name   = var.ZONE1_NAME
  zone1_cidr   = var.ZONE1_CIDR
  zone2_name   = var.ZONE2_NAME
  zone2_cidr   = var.ZONE2_CIDR
  whitelist    = var.k8s_whitelist

#   output "net_sg_id" {
#     value = aws_security_group.net_sg.id
#   }
# 
#   output "availability_zones" {
#     value = data.aws_availability_zones.available.names
#   }
#   output "availability_zone_ids" {
#     value = data.aws_availability_zones.available.zone_ids
#   }
#   output "subnet_ids" {
#     value = data.aws_subnet_ids.k8s.ids
#   }
}

// ================================================== k8s master

module "k8s_master" {
  source = "./modules/k8s_master"

  #inputs:
  env_name         = "prod"
  az               = module.net_setup.availability_zones
  subnet_ids       = module.net_setup.subnet_ids
  sg_ids           = module.net_setup.net_sg_id
  keypair_name     = var.K8S_KEYNAME
  ami              = var.K8S_AMI
  type             = var.K8S_TYPE
  desired_capacity = 3
  max_size         = 3
  min_size         = 3

  #outputs:
  # none 
}
