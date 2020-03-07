// net variables.tf

# variable "env_name"
# variable "region"
# variable "vpc_cidr"
# variable "pubnet_name"
# variable "pubnet_cidr"
# variable "privnet_name"
# variable "privnet_cidr"
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

variable "pubnet_name" {
  type        = string
  description = "name to use for public subnet"
}

variable "pubnet_cidr" {
  type        = string
  description = "CIDR for public subnet"
}

variable "privnet_name" {
  type        = string
  description = "name to use for private subnet"
}
variable "privnet_cidr" {
  type        = string
  description = "CIDR for private subnet"
}

variable "whitelist" {
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
}
