#!/bin/bash
source /openstack.env
set -ex

placement-manage db sync

httpd -DFOREGROUND &

wait
exit $?
