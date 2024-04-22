#!/bin/bash
source /openstack.env
set -ex

nginx -g 'daemon off;' &

wait
exit $?
