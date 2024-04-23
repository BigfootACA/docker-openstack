#!/bin/bash
source /openstack.env
curl --fail --connect-timeout 5 http://127.0.0.1:9292/
