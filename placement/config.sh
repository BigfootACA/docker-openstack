#!/bin/bash
source /openstack.env
source /openstack.pw.env
set -ex

CFG=/etc/placement/placement.conf
crudini --set $CFG placement_database connection mysql+pymysql://placement:$PWD_PLACEMENT@$SRV_MYSQL/openstack_placement
crudini --set $CFG keystone_authtoken auth_url $SRV_API/service/keystone/
crudini --set $CFG keystone_authtoken memcached_servers $SRV_MEMCACHED
crudini --set $CFG keystone_authtoken auth_type password
crudini --set $CFG keystone_authtoken project_domain_name Default
crudini --set $CFG keystone_authtoken user_domain_name Default
crudini --set $CFG keystone_authtoken project_name service
crudini --set $CFG keystone_authtoken username placement
crudini --set $CFG keystone_authtoken password $PWD_PLACEMENT
crudini --set $CFG api auth_strategy keystone

oslopolicy-convert-json-to-yaml \
	--namespace placement \
	--policy-file /etc/placement/policy.json \
	--output-file /etc/placement/policy.yaml
rm -f /etc/placement/policy.json
