#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

placement-manage db sync

httpd -DFOREGROUND &

wait
exit $?
