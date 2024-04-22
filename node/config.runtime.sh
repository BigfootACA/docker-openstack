#!/bin/bash
source /openstack.env
set -ex

NODE_IP=$(bash /utils/get-ipv4.sh eth-manage)

crudini --set /etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan local_ip "$NODE_IP"
crudini --set /etc/neutron/metadata_agent.ini DEFAULT nova_metadata_host "$NODE_IP"
crudini --set /etc/cinder/cinder.conf DEFAULT my_ip "$NODE_IP"
crudini --set /etc/cinder/cinder.conf lvm volume_group "$CINDER_LVM_GROUP"
crudini --set /etc/nova/nova.conf DEFAULT my_ip "$NODE_IP"
crudini --del /etc/nova/nova.conf api_database connection
crudini --del /etc/cinder/cinder.conf DEFAULT use_stderr

if ! [ -h /etc/iscsi/initiatorname.iscsi ]; then
	rm -f /etc/iscsi/initiatorname.iscsi
	ln -s /var/lib/cinder/initiatorname.iscsi /etc/iscsi/initiatorname.iscsi
	if ! [ -f /var/lib/cinder/initiatorname.iscsi ]; then
		echo "InitiatorName=$(iscsi-iname)" > /var/lib/cinder/initiatorname.iscsi
	fi
fi
