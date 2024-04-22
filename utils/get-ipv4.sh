#!/bin/bash
ip -j -4 -f inet address show "${1}" | \
	jq -r '.[0].addr_info[0].local'
