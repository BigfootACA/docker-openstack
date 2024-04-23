#!/bin/bash
source /openstack.env
source /openstack.pw.env
set -ex

CFG=/etc/glance/glance-api.conf
crudini --set $CFG DEFAULT public_endpoint $SRV_API/service/glance/
crudini --set $CFG DEFAULT enabled_backends 'swift:swift,fs:file'
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
crudini --set $CFG glance_store default_backend swift
crudini --set $CFG fs filesystem_store_datadir /var/lib/glance/images/
crudini --set $CFG swift default_swift_reference swift
crudini --set $CFG swift swift_store_container glance
crudini --set $CFG swift swift_store_config_file /etc/glance/glance-swift.conf
crudini --set $CFG swift swift_store_create_container_on_put true
crudini --set $CFG swift swift_store_large_object_size 5120
crudini --set $CFG swift swift_store_large_object_chunk_size 200
crudini --set $CFG swift swift_enable_snet false
crudini --set $CFG oslo_limit auth_url $SRV_API/service/keystone/
crudini --set $CFG oslo_limit auth_type password
crudini --set $CFG oslo_limit user_domain_id default
crudini --set $CFG oslo_limit username glance
crudini --set $CFG oslo_limit system_scope all
crudini --set $CFG oslo_limit password $PWD_GLANCE
crudini --set $CFG oslo_limit region_name $REGION

CFG=/etc/glance/glance-swift.conf
crudini --set $CFG swift user service:swift
crudini --set $CFG swift key $PWD_SWIFT
crudini --set $CFG swift user_domain_id default
crudini --set $CFG swift project_domain_id default
crudini --set $CFG swift auth_version 3
crudini --set $CFG swift auth_address $SRV_API/service/keystone/v3

mkdir -p /var/lib/glance
