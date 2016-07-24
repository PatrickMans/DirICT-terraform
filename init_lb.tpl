#!/bin/bash
echo "Start of boot script"
export FACTER_member_ips="${appl1_address}"
export FACTER_member_names="${appl1_name}"
echo "Memers are: $FACTER_member_names, $FACTER_member_ips"

mkdir -p /etc/puppetlabs/puppet
mkdir -p /etc/puppetlabs/code/environments/production/hieradata

echo "Write hiera.yaml /etc/puppetlabs/puppet/hiera.yaml"
cat <<'EOF' >> /etc/puppetlabs/puppet/hiera.yaml
---
:backends:
  - json
  - yaml
:hierarchy:
  - "nodes/%{::trusted.certname}"
  - customer
  - relybv
  - common

:yaml:
  :datadir: "/etc/puppetlabs/code/environments/production/hieradata"
:json:
  :datadir: "/etc/puppetlabs/code/environments/production/hieradata"
EOF

echo "Write customer hieradata"
echo '${file("customer.json")}' > "/etc/puppetlabs/code/environments/production/hieradata/customer.json"

echo "Bootstrap puppet and apply role"
wget https://raw.githubusercontent.com/relybv/dirict-role_lb/master/files/bootme.sh && bash bootme.sh
