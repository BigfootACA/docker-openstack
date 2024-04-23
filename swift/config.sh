#!/bin/bash
source /openstack.env
source /openstack.pw.env
set -ex

SWIFT_SECRET="$(md5sum<<<"${PWD_SWIFT}"|cut -f1 -d' ')"

CFG=/etc/swift/swift.conf
crudini --set $CFG swift-hash swift_hash_path_prefix "${SWIFT_SECRET:0:16}"
crudini --set $CFG swift-hash swift_hash_path_suffix "${SWIFT_SECRET:16:32}"
crudini --set $CFG storage-policy:0 name Policy-0
crudini --set $CFG storage-policy:0 default yes

CFG=/etc/swift/proxy-server.conf
crudini --set $CFG DEFAULT bind_port 8082
crudini --set $CFG DEFAULT user swift
crudini --set $CFG DEFAULT swift_dir /etc/swift/
crudini --set $CFG pipeline:main pipeline 'catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo versioned_writes proxy-logging proxy-server'
crudini --set $CFG app:proxy-server use 'egg:swift#proxy'
crudini --set $CFG app:proxy-server account_autocreate true
crudini --set $CFG filter:keystoneauth use 'egg:swift#keystoneauth'
crudini --set $CFG filter:keystoneauth operator_roles admin,user,service
crudini --set $CFG filter:authtoken paste.filter_factory keystonemiddleware.auth_token:filter_factory
crudini --set $CFG filter:authtoken www_authenticate_uri $SRV_API/service/keystone/
crudini --set $CFG filter:authtoken auth_url $SRV_API/service/keystone/
crudini --set $CFG filter:authtoken memcached_servers $SRV_MEMCACHED
crudini --set $CFG filter:authtoken auth_type password
crudini --set $CFG filter:authtoken project_domain_name Default
crudini --set $CFG filter:authtoken user_domain_name Default
crudini --set $CFG filter:authtoken project_name service
crudini --set $CFG filter:authtoken username swift
crudini --set $CFG filter:authtoken password $PWD_SWIFT
crudini --set $CFG filter:authtoken delay_auth_decision true
crudini --set $CFG filter:cache use 'egg:swift#memcache'
crudini --set $CFG filter:cache memcache_servers $SRV_MEMCACHED
crudini --set $CFG filter:tempauth use 'egg:swift#tempauth'
crudini --set $CFG filter:tempauth user_admin_admin 'admin .admin .reseller_admin'
crudini --set $CFG filter:tempauth user_admin_auditor 'admin_ro .reseller_reader'
crudini --set $CFG filter:s3api use 'egg:swift#s3api'
crudini --set $CFG filter:s3token use 'egg:swift#s3token'
crudini --set $CFG filter:s3token reseller_prefix AUTH_
crudini --set $CFG filter:s3token delay_auth_decision true
crudini --set $CFG filter:s3token auth_uri $SRV_API/service/keystone/v3
crudini --set $CFG filter:s3token http_timeout 10.0
crudini --set $CFG filter:healthcheck use 'egg:swift#healthcheck'
crudini --set $CFG filter:ratelimit use 'egg:swift#ratelimit'
crudini --set $CFG filter:read_only use 'egg:swift#read_only'
crudini --set $CFG filter:domain_remap use 'egg:swift#domain_remap'
crudini --set $CFG filter:catch_errors use 'egg:swift#catch_errors'
crudini --set $CFG filter:cname_lookup use 'egg:swift#cname_lookup'
crudini --set $CFG filter:staticweb use 'egg:swift#staticweb'
crudini --set $CFG filter:tempurl use 'egg:swift#tempurl'
crudini --set $CFG filter:formpost use 'egg:swift#formpost'
crudini --set $CFG filter:name_check use 'egg:swift#name_check'
crudini --set $CFG filter:etag-quoter use 'egg:swift#etag_quoter'
crudini --set $CFG filter:list-endpoints use 'egg:swift#list_endpoints'
crudini --set $CFG filter:proxy-logging use 'egg:swift#proxy_logging'
crudini --set $CFG filter:bulk use 'egg:swift#bulk'
crudini --set $CFG filter:slo use 'egg:swift#slo'
crudini --set $CFG filter:dlo use 'egg:swift#dlo'
crudini --set $CFG filter:container-quotas use 'egg:swift#container_quotas'
crudini --set $CFG filter:account-quotas use 'egg:swift#account_quotas'
crudini --set $CFG filter:gatekeeper use 'egg:swift#gatekeeper'
crudini --set $CFG filter:container_sync use 'egg:swift#container_sync'
crudini --set $CFG filter:xprofile use 'egg:swift#xprofile'
crudini --set $CFG filter:versioned_writes use 'egg:swift#versioned_writes'
crudini --set $CFG filter:copy use 'egg:swift#copy'
crudini --set $CFG filter:keymaster use 'egg:swift#keymaster'
crudini --set $CFG filter:keymaster meta_version_to_write 2
crudini --set $CFG filter:kms_keymaster use 'egg:swift#kms_keymaster'
crudini --set $CFG filter:kmip_keymaster use 'egg:swift#kmip_keymaster'
crudini --set $CFG filter:encryption use 'egg:swift#encryption'
crudini --set $CFG filter:listing_formats use 'egg:swift#listing_formats'
crudini --set $CFG filter:symlink use 'egg:swift#symlink'

CFG=/etc/swift/account-server.conf
crudini --set $CFG DEFAULT bind_port 6202
crudini --set $CFG DEFAULT user swift
crudini --set $CFG DEFAULT swift_dir /etc/swift
crudini --set $CFG DEFAULT devices /var/lib/swift/store
crudini --set $CFG pipeline:main pipeline 'healthcheck recon account-server'
crudini --set $CFG app:account-server use 'egg:swift#account'
crudini --set $CFG filter:healthcheck use 'egg:swift#healthcheck'
crudini --set $CFG filter:recon use 'egg:swift#recon'
crudini --set $CFG filter:recon recon_cache_path /var/cache/swift
crudini --set $CFG filter:backend_ratelimit use 'egg:swift#backend_ratelimit'
crudini --set $CFG filter:xprofile use 'egg:swift#xprofile'

CFG=/etc/swift/container-server.conf
crudini --set $CFG DEFAULT bind_port 6201
crudini --set $CFG DEFAULT user swift
crudini --set $CFG DEFAULT swift_dir /etc/swift
crudini --set $CFG DEFAULT devices /var/lib/swift/store
crudini --set $CFG pipeline:main pipeline 'healthcheck recon container-server'
crudini --set $CFG app:container-server use 'egg:swift#container'
crudini --set $CFG filter:healthcheck use 'egg:swift#healthcheck'
crudini --set $CFG filter:recon use 'egg:swift#recon'
crudini --set $CFG filter:recon recon_cache_path /var/cache/swift
crudini --set $CFG filter:backend_ratelimit use 'egg:swift#backend_ratelimit'
crudini --set $CFG filter:xprofile use 'egg:swift#xprofile'

CFG=/etc/swift/object-server.conf
crudini --set $CFG DEFAULT bind_port 6200
crudini --set $CFG DEFAULT user swift
crudini --set $CFG DEFAULT swift_dir /etc/swift
crudini --set $CFG DEFAULT devices /var/lib/swift/store
crudini --set $CFG pipeline:main pipeline 'healthcheck recon object-server'
crudini --set $CFG app:object-server use 'egg:swift#object'
crudini --set $CFG filter:healthcheck use 'egg:swift#healthcheck'
crudini --set $CFG filter:recon use 'egg:swift#recon'
crudini --set $CFG filter:recon recon_cache_path /var/cache/swift
crudini --set $CFG filter:recon recon_cache_path /var/lock
crudini --set $CFG filter:backend_ratelimit use 'egg:swift#backend_ratelimit'
crudini --set $CFG filter:xprofile use 'egg:swift#xprofile'

chown -R swift:swift /etc/swift
mkdir -p /var/lib/swift
chown swift:swift /var/lib/swift

mkdir -p /var/cache/swift
chown -R root:swift /var/cache/swift
chmod -R 775 /var/cache/swift

cd /etc/swift
swift-ring-builder account.builder create 10 3 1
swift-ring-builder container.builder create 10 3 1
swift-ring-builder object.builder create 10 3 1
grep -Ev '^\s*#.*$|^\s*//.*$|^\s*$' /swift.txt | \
while read -r ip device weight; do
	swift-ring-builder account.builder add \
		--region 1 --zone 1 --ip "$ip" --port 6202 \
		--device "$device" --weight "$weight"
	swift-ring-builder container.builder add \
		--region 1 --zone 1 --ip "$ip" --port 6201 \
		--device "$device" --weight "$weight"
	swift-ring-builder object.builder add \
		--region 1 --zone 1 --ip "$ip" --port 6200 \
		--device "$device" --weight "$weight"
done
swift-ring-builder account.builder rebalance
swift-ring-builder container.builder rebalance
swift-ring-builder object.builder rebalance
swift-ring-builder account.builder
swift-ring-builder container.builder
swift-ring-builder object.builder
