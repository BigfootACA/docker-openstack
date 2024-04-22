#!/bin/bash
source /openstack.env
set -ex

crudini --set /etc/nova/nova.conf DEFAULT my_ip $LOCAL_IP

if ! [ -f /var/lib/nova/.initialized ]; then
	chown nova:nova /var/lib/nova
	nova-manage api_db sync
	nova-manage cell_v2 map_cell0
	nova-manage cell_v2 create_cell --name=cell1 --verbose
	nova-manage db sync
	nova-manage cell_v2 list_cells
	touch /var/lib/nova/.initialized
fi

nova-api &

wait
exit $?
