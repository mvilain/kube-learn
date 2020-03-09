// k8s_master main.tf

# variable "env_name"
# variable "az"
# variable "subnet_ids"
# variable "sg_ids"
# variable "keypair_name"
# variable "ami"
# variable "type"
# variable "desired_capacity"
# variable "max_size"
# variable "min_size"

// ================================================== ELB
resource "aws_elb" "web" {
  name               = "${var.env_name}-web-lb"
  security_groups    = [ var.sg_ids ]
  subnets            = var.subnet_ids

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  
  tags = {
    "Terraform" : "true"
    "Name"      : "${var.env_name}-web-lb"
  }
}
#output "aws_elb.web." {
#  value = aws_security_group.net_sg.id
#}

// ================================================== AUTOSCALING
# https://github.com/cloudposse/terraform-aws-ec2-autoscale-group
resource "aws_autoscaling_group" "k8s" {
  name                 = "${var.env_name}-k8s-asg"
  desired_capacity     = var.desired_capacity
  health_check_type    = "ELB"
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = [ var.subnet_ids[1] ]

  launch_template {
      id               = aws_launch_template.k8-master.id
      version          = "$Latest"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "${var.env_name}-ks8-master"
    propagate_at_launch = true
  }
}

// ================================================== LT -> ELB
resource "aws_launch_template" "k8-master" {
  name                                 = "${var.env_name}-k8s-lt"
  description                          = "k8s master"
  disable_api_termination               = false
#  ebs_optimized                         = true
  instance_initiated_shutdown_behavior  = "terminate"
  image_id                              = var.ami
  instance_type                         = var.type
  key_name                              = var.keypair_name
  vpc_security_group_ids                = [ var.sg_ids ]

  block_device_mappings {
    device_name                         = "/dev/sda1"
    ebs { 
      volume_size                       = 20 
    }
  }
#  cpu_options {
#    core_count                          = 1
#    threads_per_core                    = 2
#  }
#  credit_specification { 
#    cpu_credits                         = "standard" 
#  }

  instance_market_options { 
    market_type                         = "spot"
    spot_options {
      instance_interruption_behavior    = "terminate"
    }
  }

  monitoring { 
    enabled                             = true
  }

#  network_interfaces { 
#    associate_public_ip_address         = true 
#    security_groups                     = [ var.sg_ids ]
#    subnet_id                           = var.subnet_ids[0]
#  }
#  placement {
#    availability_zone                   = "us-west-2a"
#  }

  tag_specifications {
    resource_type                       = "instance"

    tags = {
      Name                              = "${var.env_name}-k8s-master"
      "Terraform"                       = "true"
    }
  }

}
