# Rocky Linux 9
FROM rockylinux:9

# USTC mirrors
RUN sed \
	-e 's|^mirrorlist=|#mirrorlist=|g' \
	-e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.ustc.edu.cn/rocky|g' \
	/etc/yum.repos.d/rocky{,-extras}.repo
RUN dnf makecache

# Enable alt repos
RUN dnf install -y yum-utils
RUN dnf config-manager --set-enabled crb
RUN dnf install -y epel-release
RUN sed \
	-e 's|^metalink=|#metalink=|g' \
	-e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
	-e 's|^#baseurl=https\?://download.example/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
	/etc/yum.repos.d/epel{,-testing}.repo
RUN dnf makecache

# Initialize locale and timezone
RUN echo %_install_langs zh_CN > /etc/rpm/macros.image-language-conf
RUN dnf install -y langpacks-zh_CN glibc-langpack-zh glibc-locale-source gettext
RUN localedef -i zh_CN -c -f UTF-8 zh_CN.UTF-8
RUN echo LANG=zh_CN.UTF-8 > /etc/locale.conf
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Upgrade system
RUN dnf update -y

# Add OpenStack 23.02
RUN dnf install -y \
	centos-release-openstack-bobcat

# Add crudini
RUN dnf install -y python-pip
RUN pip config set global.index-url https://mirrors.bfsu.edu.cn/pypi/web/simple
RUN pip install crudini

# Add Tools
RUN dnf install -y \
	lvm2 \
	httpd \
	ebtables \
	targetcli \
	device-mapper-persistent-data

# Add Python Libraries
RUN dnf install -y \
	python3-openstackclient \
	python3-osc-placement \
	python3-dotenv \
	python3-mod_wsgi

# Add OpenStack Keystone
RUN dnf install -y \
	openstack-keystone

# Add OpenStack Glance
RUN dnf install -y \
	openstack-glance

RUN dnf install -y \
	openstack-placement-api

# Add OpenStack Neutron
RUN dnf install -y \
	openstack-neutron \
	openstack-neutron-ml2 \
	openstack-neutron-openvswitch \
	openstack-neutron-linuxbridge

# Add OpenStack Nova
RUN dnf install -y \
	openstack-nova-api \
	openstack-nova-compute \
	openstack-nova-conductor \
	openstack-nova-scheduler \
	openstack-nova-novncproxy

# Add OpenStack Horizon
RUN dnf install -y \
	openstack-dashboard

# Add OpenStack Cinder
RUN dnf install -y \
	openstack-cinder

# Add other utils
RUN dnf install -y \
	patch \
	mysql

# Add libvirtd
RUN dnf install -y \
	libvirt \
	libvirt-daemon \
	qemu-kvm \
	dmidecode

# Add nginx
RUN dnf install -y \
	nginx
