#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

cinder-scheduler \
	--config-file /usr/share/cinder/cinder-dist.conf \
	--config-file /etc/cinder/cinder.conf \
	--use-syslog &

wait
exit $?
