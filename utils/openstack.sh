#!/usr/bin/bash
cd "$(dirname "$0")/.."
source config/openstack.env
source config/openstack.pw.env
set -xe
openstack project create --domain default --description "Service Project" service
openstack user create --domain default --password $PWD_GLANCE    glance
openstack user create --domain default --password $PWD_PLACEMENT placement
openstack user create --domain default --password $PWD_NOVA      nova
openstack user create --domain default --password $PWD_NEUTRON   neutron
openstack user create --domain default --password $PWD_CINDER    cinder
openstack role add --project service --user glance    admin
openstack role add --project service --user placement admin
openstack role add --project service --user nova      admin
openstack role add --project service --user neutron   admin
openstack role add --project service --user cinder    admin
openstack service create --name glance    --description "OpenStack Image"          image
openstack service create --name placement --description "Placement API"            placement
openstack service create --name nova      --description "OpenStack Compute"        compute
openstack service create --name neutron   --description "OpenStack Networking"     network
openstack service create --name cinderv3  --description "OpenStack Block Storage"  volumev3
openstack endpoint create --region $REGION image        public   $SRV_API/service/glance
openstack endpoint create --region $REGION image        internal $SRV_API/service/glance
openstack endpoint create --region $REGION image        admin    $SRV_API/service/glance
openstack endpoint create --region $REGION placement    public   $SRV_API/service/placement
openstack endpoint create --region $REGION placement    internal $SRV_API/service/placement
openstack endpoint create --region $REGION placement    admin    $SRV_API/service/placement
openstack endpoint create --region $REGION network      public   $SRV_API/service/neutron
openstack endpoint create --region $REGION network      internal $SRV_API/service/neutron
openstack endpoint create --region $REGION network      admin    $SRV_API/service/neutron
openstack endpoint create --region $REGION compute      public   $SRV_API/service/nova/v2.1
openstack endpoint create --region $REGION compute      internal $SRV_API/service/nova/v2.1
openstack endpoint create --region $REGION compute      admin    $SRV_API/service/nova/v2.1
openstack endpoint create --region $REGION volumev3     public   $SRV_API/service/cinder/v3/%\(project_id\)s
openstack endpoint create --region $REGION volumev3     internal $SRV_API/service/cinder/v3/%\(project_id\)s
openstack endpoint create --region $REGION volumev3     admin    $SRV_API/service/cinder/v3/%\(project_id\)s
openstack role add --user glance --user-domain Default --system all reader
