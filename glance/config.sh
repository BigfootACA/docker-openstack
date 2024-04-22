#!/bin/bash
source /openstack.env
source /openstack.pw.env
set -ex

CFG=/etc/glance/glance-api.conf
crudini --set $CFG DEFAULT public_endpoint $SRV_API/service/glance/
crudini --set $CFG DEFAULT enabled_backends fs:file
crudini --set $CFG database connection mysql+pymysql://glance:$PWD_GLANCE@$SRV_MYSQL/openstack_glance
crudini --set $CFG keystone_authtoken www_authenticate_uri $SRV_API/service/keystone/
crudini --set $CFG keystone_authtoken auth_url $SRV_API/service/keystone/
crudini --set $CFG keystone_authtoken memcached_servers $SRV_MEMCACHED
crudini --set $CFG keystone_authtoken auth_type password
crudini --set $CFG keystone_authtoken project_domain_name Default
crudini --set $CFG keystone_authtoken user_domain_name Default
crudini --set $CFG keystone_authtoken project_name service
crudini --set $CFG keystone_authtoken username glance
crudini --set $CFG keystone_authtoken password $PWD_GLANCE
crudini --set $CFG paste_deploy flavor keystone
crudini --set $CFG glance_store default_backend fs
crudini --set $CFG fs filesystem_store_datadir /var/lib/glance/images/
crudini --set $CFG oslo_limit auth_url $SRV_API/service/keystone/
crudini --set $CFG oslo_limit auth_type password
crudini --set $CFG oslo_limit user_domain_id default
crudini --set $CFG oslo_limit username glance
crudini --set $CFG oslo_limit system_scope all
crudini --set $CFG oslo_limit password $PWD_GLANCE
crudini --set $CFG oslo_limit region_name $REGION

mkdir -p /var/lib/glance
