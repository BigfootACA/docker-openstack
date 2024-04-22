#!/bin/bash
source /openstack.env
set -ex

crudini --set /etc/nova/nova.conf DEFAULT my_ip $LOCAL_IP

nova-scheduler &

wait
exit $?
