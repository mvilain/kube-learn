# kubernetes_master terraform module

This module builds the kubernetes master service with multiple instances of the service behind a load balancer with autoscaling set up.


https://binx.io/blog/2019/09/02/how-to-dynamically-bind-elastic-ip-addresses-to-an-auto-scaling-group/

## adding DNS to load balencer

- https://stackoverflow.com/questions/50471485/terraform-assigning-elastic-ips-to-auto-scaling-group-instances

```
# Set up the load balancer
resource "aws_alb" "example" {
  name            = "example"
  internal        = false
  security_groups = ["${aws_security_group.example.id}"]
  subnets         = ["${data.aws_subnet_ids.example.ids}"]
}

# Get the zone id for the zone you are setting this in
data "aws_route53_zone" "example" {
  name         = "example.com"
  private_zone = false
}

# Set the record, replace <your dns name> with the name you want to use
resource "aws_route53_record" "build" {
  provider = "aws"
  zone_id  = "${data.aws_route53_zone.example.zone_id}"
  name     = "<your dns name>"
  type     = "A"

  alias {
    name                   = "${aws_alb.example.dns_name}"
    zone_id                = "${aws_alb.eaxmple.zone_id}"
    evaluate_target_health = false
  }
}
```