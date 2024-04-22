#!/bin/bash
source /openstack.env
set -ex
trap "pgrep -P $$ | xargs kill" TERM

nginx -g 'daemon off;' &

wait
exit $?
