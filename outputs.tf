output "customer" {
    value = "${var.customer}"
}

output "customer environment" {
    value = "${var.environment}"
}

output "customer fqdn" {
    value = "${concat(var.ext_lb_name,".",var.environment,".",var.customer,".",var.domain_base)}"
}

output "customer nameservers" {
    value = "${aws_route53_zone.environment.name_servers.0}, ${aws_route53_zone.environment.name_servers.1}, ${aws_route53_zone.environment.name_servers.2}, ${aws_route53_zone.environment.name_servers.3}"
}

output "load balancer members" {
    value = "${openstack_compute_instance_v2.appl1.network.0.fixed_ip_v4}"
}

output "load balancer public address" {
    value = "${openstack_compute_floatingip_v2.float1.address}"
}

output "application servers https working test" {
    value = "https://${openstack_compute_floatingip_v2.float1.address}/working.html"
}

output "Jump host public address" {
    value = "${openstack_compute_floatingip_v2.float2.address}"
}
