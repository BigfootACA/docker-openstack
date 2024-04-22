#!/bin/bash
source /openstack.env
set -ex

crudini --set /etc/nova/nova.conf DEFAULT my_ip $LOCAL_IP

if [ -f /etc/sysconfig/openstack-nova-novncproxy ]
then source /etc/sysconfig/openstack-nova-novncproxy
fi

nova-novncproxy --web /usr/share/novnc/ $OPTIONS &

wait
exit $?
