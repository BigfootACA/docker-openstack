#!/bin/bash
set -e
cd /
for patch in "$1"/*.patch; do
	[ -f "$patch" ] || continue
	echo "Apply $patch"
	patch -Np1 < "$patch"
done
