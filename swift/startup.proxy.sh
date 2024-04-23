#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

if ! [ -f /var/lib/swift/.initialized ]; then
	chown swift:swift /var/lib/swift
	touch /var/lib/swift/.initialized
fi

swift-proxy-server -v /etc/swift/proxy-server.conf &

wait
exit $?
