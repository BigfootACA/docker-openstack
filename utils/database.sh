#!/usr/bin/bash
cd "$(dirname "$0")/.."
source config/openstack.env
source config/openstack.pw.env
set -xe
mariadb<<EOF
CREATE DATABASE IF NOT EXISTS openstack_keystone;
CREATE DATABASE IF NOT EXISTS openstack_glance;
CREATE DATABASE IF NOT EXISTS openstack_neutron;
CREATE DATABASE IF NOT EXISTS openstack_placement;
CREATE DATABASE IF NOT EXISTS openstack_nova;
CREATE DATABASE IF NOT EXISTS openstack_nova_api;
CREATE DATABASE IF NOT EXISTS openstack_nova_cell0;
CREATE DATABASE IF NOT EXISTS openstack_cinder;
GRANT ALL PRIVILEGES ON openstack_keystone.*   TO 'keystone'@'%'          IDENTIFIED BY "$PWD_KEYSTONE";
GRANT ALL PRIVILEGES ON openstack_glance.*     TO 'glance'@'%'            IDENTIFIED BY "$PWD_GLANCE";
GRANT ALL PRIVILEGES ON openstack_placement.*  TO 'placement'@'%'         IDENTIFIED BY "$PWD_PLACEMENT";
GRANT ALL PRIVILEGES ON openstack_nova.*       TO 'nova'@'%'              IDENTIFIED BY "$PWD_NOVA";
GRANT ALL PRIVILEGES ON openstack_nova_api.*   TO 'nova'@'%'              IDENTIFIED BY "$PWD_NOVA";
GRANT ALL PRIVILEGES ON openstack_nova_cell0.* TO 'nova'@'%'              IDENTIFIED BY "$PWD_NOVA";
GRANT ALL PRIVILEGES ON openstack_neutron.*    TO 'neutron'@'%'           IDENTIFIED BY "$PWD_NEUTRON";
GRANT ALL PRIVILEGES ON openstack_cinder.*     TO 'cinder'@'%'            IDENTIFIED BY "$PWD_CINDER";
GRANT ALL PRIVILEGES ON openstack_keystone.*   TO 'keystone'@'localhost'  IDENTIFIED BY "$PWD_KEYSTONE";
GRANT ALL PRIVILEGES ON openstack_glance.*     TO 'glance'@'localhost'    IDENTIFIED BY "$PWD_GLANCE";
GRANT ALL PRIVILEGES ON openstack_placement.*  TO 'placement'@'localhost' IDENTIFIED BY "$PWD_PLACEMENT";
GRANT ALL PRIVILEGES ON openstack_nova.*       TO 'nova'@'localhost'      IDENTIFIED BY "$PWD_NOVA";
GRANT ALL PRIVILEGES ON openstack_nova_api.*   TO 'nova'@'localhost'      IDENTIFIED BY "$PWD_NOVA";
GRANT ALL PRIVILEGES ON openstack_nova_cell0.* TO 'nova'@'localhost'      IDENTIFIED BY "$PWD_NOVA";
GRANT ALL PRIVILEGES ON openstack_neutron.*    TO 'neutron'@'localhost'   IDENTIFIED BY "$PWD_NEUTRON";
GRANT ALL PRIVILEGES ON openstack_cinder.*     TO 'cinder'@'localhost'    IDENTIFIED BY "$PWD_CINDER ";
FLUSH PRIVILEGES;
EOF
mkdir -p /var/lib/keystone
mkdir -p /var/lib/glance
mkdir -p /var/lib/nova
mkdir -p /var/lib/neutron
mkdir -p /var/lib/cinder
