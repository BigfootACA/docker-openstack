#!/bin/bash
source /openstack.env
source /openstack.pw.env
set -ex

CFG=/etc/keystone/keystone.conf
crudini --set $CFG token provider fernet
crudini --set $CFG DEFAULT public_endpoint $SRV_API/service/keystone/
crudini --set $CFG DEFAULT admin_endpoint $SRV_API/service/keystone/
crudini --set $CFG database connection mysql+pymysql://keystone:$PWD_KEYSTONE@$SRV_MYSQL/openstack_keystone

oslopolicy-convert-json-to-yaml \
	--namespace keystone \
	--policy-file /etc/keystone/policy.json \
	--output-file /etc/keystone/policy.yaml
rm -f /etc/keystone/policy.json
mkdir -p /var/lib/keystone

rm -rf /etc/keystone/fernet-keys /etc/keystone/credential-keys
ln -sf /var/lib/keystone/fernet-keys /etc/keystone/fernet-keys
ln -sf /var/lib/keystone/credential-keys /etc/keystone/credential-keys
