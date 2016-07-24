# specify customer and environment
variable "customer" {
    default = "dirict"
}

variable "environment" {
    default = "dirict-test"
}

# specify external domain base
variable "domain_base" {
    default = "openstack.rely.nl"
}

# specify A record name for external load balancer
variable "ext_lb_name" {
    default = "testlb"
}

# specify AWS credentials as 'export TF_VAR_aws_access_key=<accesskey>; export TF_VAR_aws_secret_key=<secretkey>'
variable "aws_access_key" {}
variable "aws_secret_key" {}

# specify stack user
variable "user_name" {}

# set password as 'export TF_VAR_password=<password>'
variable "password" {}

# generate your own key
variable "ssh_key_file" {
    default = "~/.ssh/id_rsa.terraform"
}

############### adjust as needed ###############
variable "db_vol_gb" {
    default = 10
}

variable "nfs_vol_gb" {
    default = 10
}

variable "es_vol_gb" {
    default = 10
}


############### leave unchanged for naturalis openstack ###################
variable "tenant_name" {
    default = "dirict-test"
}

variable "auth_url" {
    default = "https://access.openstack.rely.nl:5000/v2.0"
}

variable "region" {
    default = "RegionOne"
}

variable "external_gateway" {
    default = "2613fe91-7fa1-4033-8fd3-678e7e9e15e7"
}

variable "pool" {
    default = "external"
}

variable "image_deb" {
    default = "debian-7-amd64"
}

variable "image_ub" {
    default = "Ubuntu 14.04 LTS"
}

variable "image_win" {
    default = "Windows Server 2012 R2 Std Eval"
}

variable "flavor_appl" {
    default = "ha_localdisk.1c.1r.20h"
}

variable "flavor_db" {
    default = "ha_localdisk.1c.1r.20h"
}

variable "flavor_mon" {
    default = "ha_localdisk.2c.4r.60h"
}

variable "flavor_win" {
    default = "ha_localdisk.2c.4r.60h"
}

variable "flavor_lb" {
    default = "ha_localdisk.1c.1r.20h"
}

variable "flavor_jump" {
    default = "ha_localdisk.1c.1r.20h"
}
