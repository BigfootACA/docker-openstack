#!/bin/bash
source /openstack.env
source /openstack.pw.env
set -ex

CFG=/etc/cinder/cinder.conf
crudini --set $CFG DEFAULT my_ip $LOCAL_IP
crudini --set $CFG DEFAULT enabled_backends lvm
crudini --set $CFG DEFAULT glance_api_servers $SRV_API/service/glance/
crudini --set $CFG DEFAULT auth_strategy keystone
crudini --set $CFG DEFAULT use_forwarded_for true
crudini --set $CFG DEFAULT use_stderr true
crudini --set $CFG DEFAULT public_endpoint $SRV_API/service/cinder/
crudini --set $CFG DEFAULT transport_url rabbit://openstack:$PWD_RABBITMQ@$SRV_RABBITMQ
crudini --set $CFG database connection mysql+pymysql://cinder:$PWD_CINDER@$SRV_MYSQL/openstack_cinder
crudini --set $CFG keystone_authtoken www_authenticate_uri $SRV_API/service/keystone/
crudini --set $CFG keystone_authtoken auth_url $SRV_API/service/keystone/
crudini --set $CFG keystone_authtoken memcached_servers $SRV_MEMCACHED
crudini --set $CFG keystone_authtoken auth_type password
crudini --set $CFG keystone_authtoken project_domain_name Default
crudini --set $CFG keystone_authtoken user_domain_name Default
crudini --set $CFG keystone_authtoken project_name service
crudini --set $CFG keystone_authtoken username cinder
crudini --set $CFG keystone_authtoken password $PWD_CINDER
crudini --set $CFG oslo_concurrency lock_path /var/lib/cinder/lock
crudini --set $CFG lvm volume_driver cinder.volume.drivers.lvm.LVMVolumeDriver
crudini --set $CFG lvm target_protocol iscsi
crudini --set $CFG lvm target_helper lioadm
chown -R cinder:cinder /etc/cinder
