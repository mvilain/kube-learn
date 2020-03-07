// web_server input variables.tf

# variable "env_name"
# variable "az"
# variable "subnet_ids"
# variable "sg_ids"
# variable "ami"
# variable "type"
# variable "desired_capacity"
# variable "max_size"
# variable "min_size"

variable "env_name" {
  type        = string
  description = "environment name of the type of network (prod/stage/test/dev)"
  default     = "prod"
}

variable "az" {
  type        = list(string)
  description = "regional availabity zones"
}

variable "subnet_ids" {
  type        = list(string)
  description = "regional subnet ids"
}

variable "sg_ids" {
  description = "security groups for web_server"
  type        = string
}

variable "ami" {
  type        = string
  description = "region (AMI) for CentOS 7"
  default     = "ami-77724e12"
  
#  validation {
#    condition     = length(var.prod_web_ami) > 4 && substr(var.prod_web_ami, 0, 4) == "ami-"
#    error_message = "Machine Image must be a valid AMI id, starting with \"ami-\"."
#  }
}

variable "type" {
  type        = string
  default     = "t2.nano"
}

variable "desired_capacity" {
  type        = number
  default     = 1
}

variable "max_size" {
  type        = number
  default     = 1
}

variable "min_size" {
  type        = number
  default     = 1
}
