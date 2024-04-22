#!/bin/bash
cd "$(dirname "$0")/.."
set -x
docker compose down --rmi all --remove-orphans
mariadb<<EOF
DROP DATABASE IF EXISTS openstack_zun;
DROP DATABASE IF EXISTS openstack_cinder;
DROP DATABASE IF EXISTS openstack_keystone;
DROP DATABASE IF EXISTS openstack_glance;
DROP DATABASE IF EXISTS openstack_neutron;
DROP DATABASE IF EXISTS openstack_placement;
DROP DATABASE IF EXISTS openstack_nova;
DROP DATABASE IF EXISTS openstack_nova_api;
DROP DATABASE IF EXISTS openstack_nova_cell0;
EOF
rm -rf /var/lib/keystone
rm -rf /var/lib/glance
rm -rf /var/lib/nova
rm -rf /var/lib/neutron
