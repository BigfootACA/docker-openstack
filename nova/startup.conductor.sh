#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

crudini --set /etc/nova/nova.conf DEFAULT my_ip $LOCAL_IP

nova-conductor &

wait
exit $?
