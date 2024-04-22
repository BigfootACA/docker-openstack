#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

neutron-db-manage \
	--config-file /etc/neutron/neutron.conf \
	--config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
	upgrade head

if ! [ -f /var/lib/neutron/.initialized ]; then
	chown neutron:neutron /var/lib/neutron
	touch /var/lib/neutron/.initialized
fi

neutron-server \
	--config-file /usr/share/neutron/neutron-dist.conf \
	--config-dir /usr/share/neutron/server \
	--config-file /etc/neutron/neutron.conf \
	--config-file /etc/neutron/plugin.ini \
	--config-dir /etc/neutron/conf.d/common \
	--config-dir /etc/neutron/conf.d/neutron-server &

wait
exit $?
