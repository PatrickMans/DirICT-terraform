# Create customer zone
resource "aws_route53_zone" "customer" {
  name = "${concat(var.customer,".",var.domain_base)}"
}

# Create environment zone
resource "aws_route53_zone" "environment" {
   name = "${concat(,var.environment,".",var.customer,".",var.domain_base)}"
}

# Create A record for external load balancer address
resource "aws_route53_record" "ext_lb_name" {
   zone_id = "${aws_route53_zone.environment.zone_id}"
   name = "${concat(var.ext_lb_name,".",var.environment,".",var.customer,".",var.domain_base)}"
   type = "A"
   ttl = "10"
   records = ["${openstack_compute_floatingip_v2.float1.address}"]
}

# Create NS record for environment
resource "aws_route53_record" "environment-ns" {
   zone_id = "${aws_route53_zone.environment.zone_id}"
   name = "${concat(var.environment,".",var.customer,".",var.domain_base)}"
   type = "NS"
   ttl = "10"
   records = [
      "${aws_route53_zone.environment.name_servers.0}",
      "${aws_route53_zone.environment.name_servers.1}",
      "${aws_route53_zone.environment.name_servers.2}",
      "${aws_route53_zone.environment.name_servers.3}"
   ]
}
