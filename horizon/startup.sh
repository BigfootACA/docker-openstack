#!/bin/bash
source /openstack.env
set -ex

httpd -DFOREGROUND &

wait
exit $?
