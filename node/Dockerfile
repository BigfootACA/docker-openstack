FROM rocky-openstack

# Systemd Shutdown Signal
STOPSIGNAL SIGRTMIN+4

# Add scripts
COPY neutron /neutron
COPY cinder /cinder
COPY config /config
COPY utils /utils
COPY swift /swift
COPY nova /nova
COPY node /node
COPY config/openstack.env config/openstack.pw.env config/swift.txt /
COPY node/lvm.conf /etc/lvm/
RUN find utils cinder nova swift neutron node -name '*.sh' | xargs chmod +x
RUN chmod 0600 /openstack.pw.env
RUN /node/config.sh
RUN /nova/config.sh
RUN /swift/config.sh
RUN /cinder/config.sh
RUN /neutron/config.sh
CMD ["/utils/startup.ns.sh", "/node/startup.sh"]
