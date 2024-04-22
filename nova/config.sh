#!/bin/bash
source /openstack.env
source /openstack.pw.env
set -ex

CFG=/etc/nova/nova.conf
crudini --set $CFG DEFAULT public_endpoint $SRV_API/service/nova/
crudini --set $CFG DEFAULT my_ip $LOCAL_IP
crudini --set $CFG DEFAULT enabled_apis osapi_compute,metadata
crudini --set $CFG DEFAULT compute_driver libvirt.LibvirtDriver
crudini --set $CFG DEFAULT instances_path /var/lib/nova/instances
crudini --set $CFG DEFAULT state_path /var/lib/nova
crudini --set $CFG DEFAULT transport_url rabbit://openstack:$PWD_RABBITMQ@$SRV_RABBITMQ
crudini --set $CFG database connection mysql+pymysql://nova:$PWD_NOVA@$SRV_MYSQL/openstack_nova
crudini --set $CFG api_database connection mysql+pymysql://nova:$PWD_NOVA@$SRV_MYSQL/openstack_nova_api
crudini --set $CFG keystone_authtoken www_authenticate_uri $SRV_API/service/keystone/
crudini --set $CFG keystone_authtoken auth_url $SRV_API/service/keystone/
crudini --set $CFG keystone_authtoken memcached_servers $SRV_MEMCACHED
crudini --set $CFG keystone_authtoken auth_type password
crudini --set $CFG keystone_authtoken project_domain_name Default
crudini --set $CFG keystone_authtoken user_domain_name Default
crudini --set $CFG keystone_authtoken project_name service
crudini --set $CFG keystone_authtoken username nova
crudini --set $CFG keystone_authtoken password $PWD_NOVA
crudini --set $CFG api auth_strategy keystone
crudini --set $CFG api use_forwarded_for true
crudini --set $CFG api compute_link_prefix $SRV_API/service/nova
crudini --set $CFG service_user send_service_user_token true
crudini --set $CFG service_user auth_url $SRV_API/service/keystone/
crudini --set $CFG service_user auth_strategy keystone
crudini --set $CFG service_user auth_type password
crudini --set $CFG service_user project_domain_name Default
crudini --set $CFG service_user project_name service
crudini --set $CFG service_user user_domain_name Default
crudini --set $CFG service_user username nova
crudini --set $CFG service_user password $PWD_NOVA
crudini --set $CFG vnc enabled true
crudini --set $CFG vnc server_listen '$my_ip'
crudini --set $CFG vnc server_proxyclient_address '$my_ip'
crudini --set $CFG vnc novncproxy_base_url $SRV_API/vnc/vnc_auto.html
crudini --set $CFG glance api_servers $SRV_API/service/glance
crudini --set $CFG oslo_concurrency lock_path /var/lib/nova/lock
crudini --set $CFG placement region_name $REGION
crudini --set $CFG placement project_domain_name Default
crudini --set $CFG placement project_name service
crudini --set $CFG placement auth_type password
crudini --set $CFG placement user_domain_name Default
crudini --set $CFG placement auth_url $SRV_API/service/keystone/v3
crudini --set $CFG placement username placement
crudini --set $CFG placement password $PWD_PLACEMENT
crudini --set $CFG neutron auth_url $SRV_API/service/keystone
crudini --set $CFG neutron auth_type password
crudini --set $CFG neutron project_domain_name Default
crudini --set $CFG neutron user_domain_name Default
crudini --set $CFG neutron region_name $REGION
crudini --set $CFG neutron project_name service
crudini --set $CFG neutron username neutron
crudini --set $CFG neutron password $PWD_NEUTRON
crudini --set $CFG neutron service_metadata_proxy true
crudini --set $CFG neutron metadata_proxy_shared_secret $PWD_METADATA
crudini --set $CFG libvirt virt_type kvm
crudini --set $CFG cinder os_region_name $REGION
chown -R nova:nova /etc/nova

oslopolicy-convert-json-to-yaml \
	--namespace nova \
	--policy-file /etc/nova/policy.json \
	--output-file /etc/nova/policy.yaml
rm -f /etc/nova/policy.json
mkdir -p /var/lib/nova /var/lib/libvirt
