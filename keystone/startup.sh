#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

keystone-manage db_sync

if ! [ -f /var/lib/keystone/.initialized ]; then
	source /openstack.pw.env
	chown keystone:keystone /var/lib/keystone
	mkdir -p /var/lib/keystone/{fernet,credential}-keys
	chown -R keystone:keystone /var/lib/keystone/{fernet,credential}-keys
	chown 0700 /var/lib/keystone/{fernet,credential}-keys
	keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
	keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
	keystone-manage bootstrap \
		--bootstrap-password "$PWD_ADMIN" \
		--bootstrap-admin-url "$SRV_API/service/keystone/v3/" \
		--bootstrap-internal-url "$SRV_API/service/keystone/v3/" \
		--bootstrap-public-url "$SRV_API/service/keystone/v3/" \
		--bootstrap-region-id "$REGION"
	touch /var/lib/keystone/.initialized
	unset "${!PWD_@}"
fi

httpd -DFOREGROUND &

wait
exit $?
