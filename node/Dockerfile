FROM rocky-openstack

# Add scripts
COPY neutron /neutron
COPY cinder /cinder
COPY utils /utils
COPY nova /nova
COPY node /node
COPY ./openstack.env ./openstack.pw.env /
COPY node/lvm.conf /etc/lvm/
RUN find utils cinder nova neutron node -name '*.sh' | xargs chmod +x
RUN chmod 0600 /openstack.pw.env
RUN /node/config.sh
RUN /nova/config.sh
RUN /cinder/config.sh
RUN /neutron/config.sh
CMD ["/utils/startup.ns.sh", "/node/startup.sh"]
