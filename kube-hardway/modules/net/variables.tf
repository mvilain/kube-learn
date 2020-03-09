// net variables.tf

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


variable "env_name" {
  type        = string
  description = "environment name of the type of network (prod/stage/test/dev)"
  default     = "prod"
}

variable "region" {
  type        = string
  description = "region (AMI) to use for kubernetes cluster"
  default     = "us-east-2"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
}

variable "zone0_name" {
  type        = string
  description = "name to use for zone0 subnet"
}

variable "zone0_cidr" {
  type        = string
  description = "CIDR for zone0 subnet"
}

variable "zone1_name" {
  type        = string
  description = "name to use for zone1 subnet"
}

variable "zone1_cidr" {
  type        = string
  description = "CIDR for zone1 subnet"
}

variable "zone2_name" {
  type        = string
  description = "name to use for zone2 subnet"
}

variable "zone2_cidr" {
  type        = string
  description = "CIDR for zone2 subnet"
}

variable "whitelist" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
}
