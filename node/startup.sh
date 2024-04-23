#!/bin/bash
source /openstack.env
set -ex
function set_service(){
	local value="$1"
	shift
	if [ "$value" == "1" ]
	then systemctl enable $@
	else systemctl disable $@
	fi
}
chown nova:nova /var/lib/nova
chown cinder:cinder /var/lib/cinder
chown neutron:neutron /var/lib/neutron
mkdir -p /var/lib/nova/instances
chown nova:nova /var/lib/nova/instances
set_service "$USE_NOVA_COMPUTE" \
	openstack-nova-compute.service \
	libvirtd.socket \
	libvirtd.service
set_service "$USE_CINDER_VOLUME" \
	openstack-cinder-volume.service
set_service "$USE_NEUTRON_AGENT_L3" \
	neutron-l3-agent.service
set_service "$USE_NEUTRON_AGENT_DHCP" \
	neutron-dhcp-agent.service
set_service "$USE_NEUTRON_AGENT_METADATA" \
	neutron-metadata-agent.service
set_service "$USE_NEUTRON_AGENT_LINUXBRIDGE" \
	neutron-linuxbridge-agent.service
set_service "$USE_SWIFT_STORAGE" \
	openstack-swift-account-auditor.service \
	openstack-swift-account-reaper.service \
	openstack-swift-account-replicator.service \
	openstack-swift-account.service \
	openstack-swift-container-auditor.service \
	openstack-swift-container-replicator.service \
	openstack-swift-container.service \
	openstack-swift-container-updater.service \
	openstack-swift-object-auditor.service \
	openstack-swift-object-replicator.service \
	openstack-swift-object.service \
	openstack-swift-object-updater.service \
	openstack-swift-rsyncd.service
unset "${!PWD_@}"
exec /lib/systemd/systemd --system
