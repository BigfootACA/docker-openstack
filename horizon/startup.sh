#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

httpd -DFOREGROUND &

wait
exit $?
