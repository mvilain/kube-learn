// net outputs.tf

output "net_sg_id" {
  value = aws_security_group.net_sg.id
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "availability_zone_ids" {
  value = data.aws_availability_zones.available.zone_ids
}

output "subnet_ids" {
  value = data.aws_subnet_ids.k8s.ids
}
