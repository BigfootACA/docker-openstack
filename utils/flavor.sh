#!/bin/bash
cd "$(dirname "$0")/.."
source openstack.env
set -e
grep -Ev '^\s*#.*$|^\s*//.*$|^\s*$' utils/flavors.txt | \
while read -r cpu ram disk name;do
	printf 'Creating %s with %d vCPUs, %dMiB RAM, %dGiB Disk\n' \
		"$name" "$cpu" "$ram" "$disk"
	openstack flavor create \
		--public \
		--vcpus "$cpu" \
		--ram "$ram" \
		--disk "$disk" \
		"$name"
done
