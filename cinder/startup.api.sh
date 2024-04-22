#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

cinder-manage db sync

if ! [ -f /var/lib/cinder/.initialized ]; then
	chown cinder:cinder /var/lib/cinder
	touch /var/lib/cinder/.initialized
fi

cinder-api \
	--config-file /usr/share/cinder/cinder-dist.conf \
	--config-file /etc/cinder/cinder.conf \
	--use-syslog &

wait
exit $?
