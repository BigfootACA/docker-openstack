#!/bin/bash
source /openstack.env
if [ "${1}" == "--enter" ]; then
	mount -t sysfs -o rw,nosuid,nodev,noexec sysfs /sys
	GW="$(ip -4 -j route show default | jq -r '.[0].gateway')"
	if [ -z "${DNS_ADDR}" ];then DNS_ADDR="${GW}";fi
	rm -f /etc/resolv.conf
	echo "nameserver ${DNS_ADDR}" > /etc/resolv.conf
	chattr -i /etc/resolv.conf
	exec "${2}"
else
	exec nsenter \
		--no-fork \
		--net=/run/netns/stack \
		"${0}" --enter "${1}"
fi
