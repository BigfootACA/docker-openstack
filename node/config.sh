#!/bin/bash
source /openstack.env
set -ex

# General systemd setup
systemctl disable rtkit-daemon.service
systemctl mask getty@.service
systemctl mask serial-getty@.service
systemctl mask console-getty.service
systemctl set-default multi-user.target

# Add services
cp /node/*.service /etc/systemd/system/

# Enable runtime config editor
systemctl enable config-runtime.service

# Force systemd write log to docker console
crudini --set /etc/systemd/system.conf Manager LogTarget journal
crudini --set /etc/systemd/system.conf Manager ShowStatus yes
crudini --set /etc/systemd/journald.conf Journal ForwardToConsole yes

# Setup libvirtd
rm -f /etc/libvirt/qemu/networks/autostart/default.xml
rm -f /etc/libvirt/qemu/networks/default.xml
echo 'unix_sock_group = "nova"' >> /etc/libvirt/libvirtd.conf
echo 'unix_sock_dir = "/var/lib/libvirt/state"' >> /etc/libvirt/libvirtd.conf
