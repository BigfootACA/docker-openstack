#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

glance-manage db_sync

if ! [ -f /var/lib/glance/.initialized ]; then
	chown glance:glance /var/lib/glance
	touch /var/lib/glance/.initialized
fi

set +x
source /admin-rc
set -x
crudini --set /etc/glance/glance-api.conf \
	oslo_limit endpoint_id \
	"$(openstack endpoint list \
		--region $REGION \
		--service image \
		--interface public \
		-f value \
		-c ID \
	)"
unset OS_PASSWORD
unset "${!PWD_@}"

glance-api &

wait
exit $?
