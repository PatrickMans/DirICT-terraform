# Configure the openstack provider
provider "openstack" {
  user_name  = "${var.user_name}"
  tenant_name = "${var.tenant_name}"
  password  = "${var.password}"
  insecure = true
  auth_url  = "${var.auth_url}"
}

# Configure the AWS Provider
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-west-1"
}

# Template for lb cloud-init bash
resource "template_file" "init_lb" {
    template = "${file("init_lb.tpl")}"
    vars {
        appl1_address = "${openstack_compute_instance_v2.appl1.network.0.fixed_ip_v4}"
        appl2_address = "${openstack_compute_instance_v2.appl2.network.0.fixed_ip_v4}"
        appl1_name = "${openstack_compute_instance_v2.appl1.name}"
        appl2_name = "${openstack_compute_instance_v2.appl2.name}"
        monitor_address = "${openstack_compute_instance_v2.monitor1.network.0.fixed_ip_v4}"
    }
}

# Template for appl cloud-init bash
resource "template_file" "init_appl" {
    template = "${file("init_appl.tpl")}"
    vars {
        monitor_address = "${openstack_compute_instance_v2.monitor1.network.0.fixed_ip_v4}"
        nfs_address = "${openstack_compute_instance_v2.db1.network.0.fixed_ip_v4}"
        db_address = "${openstack_compute_instance_v2.db1.network.0.fixed_ip_v4}"
        win_address = "${openstack_compute_instance_v2.win1.network.0.fixed_ip_v4}"
        ext_lb_fqdn = "${concat(var.ext_lb_name,".",var.environment,".",var.customer,".",var.domain_base)}"        
    }
}

# Template for db cloud-init bash
resource "template_file" "init_db" {
    template = "${file("init_db.tpl")}"
    vars {
        monitor_address = "${openstack_compute_instance_v2.monitor1.network.0.fixed_ip_v4}"
    }
}

# Template for monitor cloud-init bash
resource "template_file" "init_monitor" {
    template = "${file("init_monitor.tpl")}"
}

# Template for win cloud-init powershell
resource "template_file" "init_win" {
    template = "${file("init_win.tpl")}"
    vars {
        monitor_address = "${openstack_compute_instance_v2.monitor1.network.0.fixed_ip_v4}"
    }
}

resource "openstack_networking_network_v2" "frontend" {
  name = "frontend_${var.customer}_${var.environment}"
  region = "${var.region}"
  admin_state_up = "true"
}

resource "openstack_networking_network_v2" "backend" {
  name = "backend_${var.customer}_${var.environment}"
  region = "${var.region}"
  admin_state_up = "true"
}

resource "openstack_compute_keypair_v2" "terraform" {
  name = "SSH keypair for Terraform instances Customer ${var.customer} Environment ${var.environment}"
  region = "${var.region}"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

resource "openstack_networking_subnet_v2" "frontend" {
  name = "frontend_${var.customer}_${var.environment}"
  region = "${var.region}"
  network_id = "${openstack_networking_network_v2.frontend.id}"
  cidr = "172.16.10.0/24"
  ip_version = 4
  enable_dhcp = "true"
  dns_nameservers = ["8.8.8.8","8.8.4.4"]
}

resource "openstack_networking_subnet_v2" "backend" {
  name = "backend_${var.customer}_${var.environment}"
  region = "${var.region}"
  network_id = "${openstack_networking_network_v2.backend.id}"
  cidr = "172.16.20.0/24"
  ip_version = 4
  enable_dhcp = "true"
  dns_nameservers = ["8.8.8.8","8.8.4.4"]
}

resource "openstack_networking_router_v2" "terraform" {
  name = "terraform_${var.customer}_${var.environment}"
  region = "${var.region}"
  admin_state_up = "true"
  external_gateway = "${var.external_gateway}"
}

resource "openstack_networking_router_interface_v2" "frontend" {
  region = "${var.region}"
  router_id = "${openstack_networking_router_v2.terraform.id}"
  subnet_id = "${openstack_networking_subnet_v2.frontend.id}"
}

resource "openstack_networking_router_interface_v2" "backend" {
  region = "${var.region}"
  router_id = "${openstack_networking_router_v2.terraform.id}"
  subnet_id = "${openstack_networking_subnet_v2.backend.id}"
}

resource "openstack_compute_floatingip_v2" "float1" {
  depends_on = ["openstack_networking_router_interface_v2.frontend"]
  region = "${var.region}"
  pool = "${var.pool}"
}

resource "openstack_compute_floatingip_v2" "float2" {
  depends_on = ["openstack_networking_router_interface_v2.frontend"]
  region = "${var.region}"
  pool = "${var.pool}"
}

resource "openstack_compute_floatingip_v2" "float3" {
  depends_on = ["openstack_networking_router_interface_v2.backend"]
  region = "${var.region}"
  pool = "${var.pool}"
}

resource "openstack_compute_floatingip_v2" "float4" {
  depends_on = ["openstack_networking_router_interface_v2.backend"]
  region = "${var.region}"
  pool = "${var.pool}"
}

resource "openstack_compute_floatingip_v2" "float5" {
  depends_on = ["openstack_networking_router_interface_v2.backend"]
  region = "${var.region}"
  pool = "${var.pool}"
}

resource "openstack_compute_floatingip_v2" "float6" {
  depends_on = ["openstack_networking_router_interface_v2.backend"]
  region = "${var.region}"
  pool = "${var.pool}"
}

resource "openstack_compute_secgroup_v2" "terraform" {
  name = "terraform_${var.customer}_${var.environment}"
  region = "${var.region}"
  description = "Security group for the Terraform instances"
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "udp"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_blockstorage_volume_v1" "db" {
  name = "db-volume_${var.customer}_${var.environment}"
  region = "${var.region}"
  description = "database volume Customer ${var.customer} Environment ${var.environment}"
  size = "${var.db_vol_gb}"
}

resource "openstack_blockstorage_volume_v1" "nfs" {
  name = "nfs-volume_${var.customer}_${var.environment}"
  region = "${var.region}"
  description = "nfs volume Customer ${var.customer} Environment ${var.environment}"
  size = "${var.nfs_vol_gb}"
}

resource "openstack_blockstorage_volume_v1" "es" {
  name = "es-volume_${var.customer}_${var.environment}"
  region = "${var.region}"
  description = "elasticsearch volume Customer ${var.customer} Environment ${var.environment}"
  size = "${var.es_vol_gb}"
}

resource "openstack_compute_servergroup_v2" "appl" {
  name = "appl"
  policies = ["anti-affinity"]
}

resource "openstack_compute_instance_v2" "lb1" {
  name = "lb1"
  region = "${var.region}"
  image_name = "${var.image_ub}"
  flavor_name = "${var.flavor_lb}"
  key_pair = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.terraform.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.float1.address}"
  user_data = "${template_file.init_lb.rendered}"
  network {
    uuid = "${openstack_networking_network_v2.frontend.id}"
    fixed_ip_v4 = "172.16.10.51"
  }
}

resource "openstack_compute_instance_v2" "appl1" {
  name = "appl1"
  region = "${var.region}"
  image_name = "${var.image_deb}"
  flavor_name = "${var.flavor_appl}"
  key_pair = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.terraform.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.float2.address}"
  user_data = "${template_file.init_appl.rendered}"
  network {
    uuid = "${openstack_networking_network_v2.frontend.id}"
    fixed_ip_v4 = "172.16.10.101"
  }
  scheduler_hints {
    group = "${openstack_compute_servergroup_v2.appl.id}"
  }
}

resource "openstack_compute_instance_v2" "appl2" {
  name = "appl2"
  region = "${var.region}"
  image_name = "${var.image_deb}"
  flavor_name = "${var.flavor_appl}"
  key_pair = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.terraform.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.float3.address}"
  user_data = "${template_file.init_appl.rendered}"
  network {
    uuid = "${openstack_networking_network_v2.frontend.id}"
    fixed_ip_v4 = "172.16.10.102"
  }
  scheduler_hints {
    group = "${openstack_compute_servergroup_v2.appl.id}"
  }
}

resource "openstack_compute_instance_v2" "db1" {
  name = "db1"
  region = "${var.region}"
  image_name = "${var.image_deb}"
  flavor_name = "${var.flavor_db}"
  key_pair = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.terraform.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.float4.address}"
  user_data = "${template_file.init_db.rendered}"
  network {
    uuid = "${openstack_networking_network_v2.backend.id}"
    fixed_ip_v4 = "172.16.20.101"
  }
  volume {
    volume_id = "${openstack_blockstorage_volume_v1.db.id}"
    device = "/dev/vdb"
  }
  volume {
    volume_id = "${openstack_blockstorage_volume_v1.nfs.id}"
    device = "/dev/vdc"
  }
}

resource "openstack_compute_instance_v2" "monitor1" {
  name = "monitor1"
  region = "${var.region}"
  image_name = "${var.image_ub}"
  flavor_name = "${var.flavor_mon}"
  key_pair = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.terraform.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.float5.address}"
  user_data = "${template_file.init_monitor.rendered}"
  network {
    uuid = "${openstack_networking_network_v2.frontend.id}"
    fixed_ip_v4 = "172.16.10.201"
  }
  volume {
    volume_id = "${openstack_blockstorage_volume_v1.es.id}"
    device = "/dev/vdb"
  }
}

resource "openstack_compute_instance_v2" "win1" {
  name = "win1"
  region = "${var.region}"
  image_name = "${var.image_win}"
  flavor_name = "${var.flavor_win}"
  key_pair = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.terraform.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.float6.address}"
  user_data = "${template_file.init_win.rendered}"
  network {
    uuid = "${openstack_networking_network_v2.backend.id}"
  }
 }
