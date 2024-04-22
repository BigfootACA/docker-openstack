#!/bin/bash
source /openstack.env
curl --fail --connect-timeout 1 http://127.0.0.1:8080/ping
