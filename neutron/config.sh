#!/bin/bash
source /openstack.env
source /openstack.pw.env
set -ex

CFG=/etc/neutron/neutron.conf
crudini --set $CFG DEFAULT notify_nova_on_port_status_changes true
crudini --set $CFG DEFAULT notify_nova_on_port_data_changes true
crudini --set $CFG DEFAULT core_plugin ml2
crudini --set $CFG DEFAULT network_link_prefix $SRV_API/service/neutron
crudini --set $CFG DEFAULT service_plugins router
crudini --set $CFG DEFAULT auth_strategy keystone
crudini --set $CFG DEFAULT transport_url rabbit://openstack:$PWD_RABBITMQ@$SRV_RABBITMQ
crudini --set $CFG experimental linuxbridge true
crudini --set $CFG database connection mysql+pymysql://neutron:$PWD_NEUTRON@$SRV_MYSQL/openstack_neutron
crudini --set $CFG keystone_authtoken www_authenticate_uri $SRV_API/service/keystone/
crudini --set $CFG keystone_authtoken auth_url $SRV_API/service/keystone/
crudini --set $CFG keystone_authtoken memcached_servers $SRV_MEMCACHED
crudini --set $CFG keystone_authtoken auth_type password
crudini --set $CFG keystone_authtoken project_domain_name Default
crudini --set $CFG keystone_authtoken user_domain_name Default
crudini --set $CFG keystone_authtoken project_name service
crudini --set $CFG keystone_authtoken username neutron
crudini --set $CFG keystone_authtoken password $PWD_NEUTRON
crudini --set $CFG nova auth_url $SRV_API/service/keystone/
crudini --set $CFG nova auth_type password
crudini --set $CFG nova project_domain_name Default
crudini --set $CFG nova user_domain_name Default
crudini --set $CFG nova region_name $REGION
crudini --set $CFG nova project_name service
crudini --set $CFG nova username nova
crudini --set $CFG nova password $PWD_NOVA
crudini --set $CFG oslo_concurrency lock_path /var/lib/neutron/tmp

CFG=/etc/neutron/plugins/ml2/ml2_conf.ini
crudini --set $CFG ml2 type_drivers local,vlan,vxlan
crudini --set $CFG ml2 tenant_network_types vxlan
crudini --set $CFG ml2 mechanism_drivers linuxbridge,l2population
crudini --set $CFG ml2 extension_drivers port_security
crudini --set $CFG ml2_type_vxlan vni_ranges 1:1000
crudini --set $CFG ml2_type_vlan network_vlan_ranges ${NET_VLAN_RANGE}
crudini --set $CFG ml2_type_flat flat_networks ${NET_FLAT_NETWORKS}

CFG=/etc/neutron/metadata_agent.ini
crudini --set $CFG DEFAULT metadata_proxy_shared_secret $PWD_METADATA

CFG=/etc/neutron/plugins/ml2/linuxbridge_agent.ini
crudini --set $CFG linux_bridge physical_interface_mappings ${NET_INTF_MAP}
crudini --set $CFG securitygroup enable_security_group true
crudini --set $CFG securitygroup firewall_driver iptables
crudini --set $CFG securitygroup enable_ipset true
crudini --set $CFG vxlan enable_vxlan true
crudini --set $CFG vxlan l2_population true

CFG=/etc/neutron/l3_agent.ini
crudini --set $CFG DEFAULT interface_driver linuxbridge

CFG=/etc/neutron/dhcp_agent.ini
crudini --set $CFG DEFAULT interface_driver linuxbridge
crudini --set $CFG DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
crudini --set $CFG DEFAULT enable_isolated_metadata true
chown -R neutron:neutron /etc/neutron

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
mkdir -p /var/lib/neutron
touch /etc/neutron/policy.yaml
