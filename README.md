# Docker OpenStack

## Base info

Container distro: Rocky Linux 9

OpenStack release: OpenStack Bobcat (2023.2)

Supported OpenStack components: keystone, glance, placement, nova, neutron, horizon

## Simple One-Master Depoly Guide

1. Depoly MariaDB, RabbitMQ, MemCached, Etcd manually

[https://docs.openstack.org/install-guide/environment-sql-database.html](MariaDB)

[https://docs.openstack.org/install-guide/environment-messaging.html](RabbitMQ)

[https://docs.openstack.org/install-guide/environment-memcached.html](MemCached)

[https://docs.openstack.org/install-guide/environment-etcd.html](Etcd)

2. Copy ``openstack.env.example`` to ``openstack.env`` and edit

3. Copy ``openstack.pw.env.example`` to ``openstack.pw.env`` and edit

4. Edit ``host/stack-ns.sh`` to configure your network and install

```bash
make -C host install
systemctl enable --now openstack-netns.service
```

5. Run commands in Linux Shell

```bash
# Create base image
cd base
docker build -t rocky-openstack .
cd ..

# Create MariaDB databases and grant permissions
bash database.sh

# Bring up OpenStack Keystone when first run
docker compose up -d svc_keystone

# Wait for keystone up (healthy)

# Create OpenStack Users, Endpoints, etc.
bash openstack.sh

# Bring all others services
docker compose up -d

# Wait for nova compute up

# Discovery OpenStack Nova compute nodes manually
docker container exec -it openstack-svc_nova-1 nova-manage cell_v2 discover_hosts --verbose
```

6. Open http://127.0.0.1:8989/ in browser

## Sub Nodes Depoly Nodes

1. Copy ``openstack.env`` and ``openstack.pw.env`` from master node

2. Edit ``host/stack-ns.sh`` to configure your network and install

```bash
make -C host install
systemctl enable --now openstack-netns.service
```

3. Run commands in sub node's Linux Shell

```bash
# Create base image (you can copy from master node)
cd base
docker build -t rocky-openstack .
cd ..

# Bring all others services
docker compose -f compose.nodes.yml up -d
```

4. Wait for nova compute up

5. Run commands in master node's Linux Shell

```bash
# Discovery OpenStack Nova compute nodes manually
docker container exec -it openstack-svc_nova-1 nova-manage cell_v2 discover_hosts --verbose
```
