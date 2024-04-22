#!/bin/bash
set -xe
FILE="$(realpath "$0")"
DIR="$(dirname "$FILE")"

## Wait do you need to change?
##  1. Set you custom IPv4 address for eth-manage
##  2. Set you default gateway for eth-manage
##  3. Add your networks (eth-copper, eth-fiber)
##  4. Setup new MAC address for your interfaces

# Network Namespace name
_NS="stack"

# Force to root
[ "$(id -u)" == "0" ]
case "${1}" in
	enter)
		# Bootup all interfaces
		ip link set lo up
		ip link set eth-manage up
		ip link set eth-copper up
		ip link set eth-fiber up

		# Remove all addresses and configure later
		ip address flush lo
		ip address flush eth-manage
		ip address flush eth-copper
		ip address flush eth-fiber

		# Configure Loopback interface
		ip address add 127.0.0.1/8 dev lo
		ip address add ::1/128 dev lo

		# Configure management address (DO NOT REMOVE OR RENAME)
		ip address add 192.168.0.90/24 dev eth-manage

		# Configure default gateway
		ip route add default via 192.168.0.1 dev eth-manage
	;;
	stop)
		# Cleanup
		set +e
		umount /run/osnet-netns/stack
		rm -f /run/osnet-netns/stack
		ip link delete "${_NS}-manage"
		ip link delete "${_NS}-copper"
		ip link delete "${_NS}-fiber"
		ip netns delete "${_NS}"
		exit 0
	;;
	start)
		ip netns add "${_NS}"

		# Create virtual ethernet for new network namespace
		## Management Interface (DO NOT REMOVE OR RENAME THIS)
		ip link add name eth-manage type veth peer name "${_NS}-manage"
		## Networks for OpenStack Neutron
		ip link add name eth-copper type veth peer name "${_NS}-copper"
		ip link add name eth-fiber type veth peer name "${_NS}-fiber"

		# Set MAC address for interfaces
		ip link set eth-manage up netns "${_NS}" address "1e:60:e2:25:50:10"
		ip link set eth-copper up netns "${_NS}" address "1e:60:e2:25:50:11"
		ip link set eth-fiber up netns "${_NS}" address "1e:60:e2:25:50:12"

		# Connect virtual ethernet to bridge
		## Management network
		ip link set "${_NS}-manage" up master network
		## Copper Network Switch
		ip link set "${_NS}-copper" up master switch
		## Fiber Network Switch
		ip link set "${_NS}-fiber" up master fiberswitch

		# Switch into new namespace and configure addresses
		ip netns exec "${_NS}" bash "$0" enter

		# Create netns folder for container
		if ! [ -d /run/osnet-netns ]; then
			mkdir /run/osnet-netns
			mount -o rw,nosuid,nodev -t tmpfs tmpfs /run/osnet-netns
		fi
		if ! [ -e /run/osnet-netns/stack ]; then
			touch /run/osnet-netns/stack
			mount --bind /run/netns/stack /run/osnet-netns/stack
		fi
	;;
esac
